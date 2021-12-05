//
//  AppDelegate.swift
//  TravelHistory
//
//  Created by TravelHistory on 05/12/21.
//

import UIKit
import CoreLocation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let locationManager = CLLocationManager()
    var locationTimer: Timer?
    var myLocation:CLLocation?
    var viewModel = LocationTrackerViewModel()
    static let geoCoder = CLGeocoder()
    var VC: ViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.trackLocation()

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        self.createRegion(location: myLocation)
//        self.locationManager.startUpdatingLocation()
    }


    func createRegion(location:CLLocation?) {
        guard let location = location else {
            print("Location return nil")
            return
        }
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            
            let coordinate = CLLocationCoordinate2DMake((location.coordinate.latitude), (location.coordinate.longitude))
            let regionRadius = 50.0
            
            let region = CLCircularRegion(center: CLLocationCoordinate2D(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude),
                                          radius: regionRadius,
                                          identifier: "aabb")
            
            //region.notifyOnEntry = true
            region.notifyOnExit = true
            
            print("Region Created \(location.coordinate) with \(location.horizontalAccuracy)")
            self.locationManager.stopUpdatingLocation()
            print("stopUpdatingLocation")
            self.locationManager.startMonitoring(for: region)
            print("Start Monitoring")
        }
        else {
            print("System can't track regions")
        }
    }
}
extension AppDelegate: CLLocationManagerDelegate {
    @objc func trackLocation() {
        let status = locationManager.authorizationStatus
        switch status {
            // 1
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            //                    return
            // 2
        case .denied, .restricted:
            let alert = UIAlertController(title: "Location Services disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
        case .authorizedAlways, .authorizedWhenInUse:
            break
        default:
            break
        }
        // 4
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 10
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.activityType = .automotiveNavigation
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.allowsBackgroundLocationUpdates = true
        self.startMySignificantLocationChanges()
    }
    func startMySignificantLocationChanges() {
        if !CLLocationManager.significantLocationChangeMonitoringAvailable() {
            // The device does not support this service.
            return
        }
        locationManager.startMonitoringSignificantLocationChanges()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error.local\(error.localizedDescription)")
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        self.myLocation = location
        print("didUpdateLocations \(location!.coordinate) and \(location!.horizontalAccuracy)")
        let uuid = NSUUID().uuidString
        let clLocation = CLLocation(latitude: (location!.coordinate.latitude), longitude: (location!.coordinate.longitude))
        AppDelegate.geoCoder.reverseGeocodeLocation(clLocation) { placemarks, _ in
            if let place = placemarks?.first {
              print("place\(place)")
                let locationString = [place.subThoroughfare, place.thoroughfare, place.locality, place.subLocality, place.administrativeArea, place.postalCode, place.country].compactMap({$0}).joined(separator: ", ")
                self.viewModel.addLocation(uuid, location: locationString, date: Date(), latitude: (location!.coordinate.latitude), longitude: (location!.coordinate.longitude))

            }
        }
    }
}
