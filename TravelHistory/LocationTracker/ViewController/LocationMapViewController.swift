//
//  LocationMapViewController.swift
//  TravelHistory
//
//  Created by TravelHistory on 05/12/21.
//

import UIKit
import MapKit

class LocationMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var locationData: LocationEntity?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        // Do any additional setup after loading the view.
    }
    
    func configUI() {
        if let location = locationData {
            self.navigationController?.navigationBar.tintColor = UIColor.white
            self.navigationController?.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.close, target: self, action: #selector(self.barButtonItemAct))
            self.title = location.location_name
            let coordinates = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            self.mapView.setRegion(MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.09, longitudeDelta: 0.09)), animated: true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = location.location_name
            annotation.subtitle = location.dateString
            mapView.addAnnotation(annotation)
        }
    }
    @objc func barButtonItemAct() {
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
