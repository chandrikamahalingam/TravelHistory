//
//  LocationTrackerViewModel.swift
//  TravelHistory
//
//  Created by TravelHistory on 05/12/21.
//

import Foundation
import CoreData
import UIKit

protocol LocationTrackerDelegate {
    func fetchLocation()
}
class LocationTrackerViewModel {
    static let shared = LocationTrackerViewModel()
    var delegate: LocationTrackerDelegate?
    var locationArray = [LocationEntity]()
    static let dateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateStyle = .medium
      formatter.timeStyle = .medium
      return formatter
    }()
    init() {
        
    }
    init(_ delegate: LocationTrackerDelegate?) {
        self.delegate = delegate
    }
    func addLocation(_ id: String, location: String, date: Date, latitude: Double, longitude: Double) {
        self.retriveLocationData()
        
        let manageContext = CoreDataStorage.shared.managedObjectContext()
        let diffComponents = Calendar.current.dateComponents([.minute], from: (locationArray.last?.date ?? Date()), to: date)
        if (diffComponents.minute ?? 0) > 10 || self.locationArray.count == 0 {
            if let locationEntity = NSEntityDescription.entity(forEntityName: "LocationEntity", in: manageContext) {
                let newLocation = NSManagedObject(entity: locationEntity, insertInto: manageContext)
                newLocation.setValue(id, forKey: "id")
                newLocation.setValue(date, forKey: "date")
                newLocation.setValue(latitude, forKey: "latitude")
                newLocation.setValue(longitude, forKey: "longitude")
                newLocation.setValue(location, forKey: "location_name")
                newLocation.setValue(LocationTrackerViewModel.dateFormatter.string(from:date), forKey: "dateString")
                do {
                    try manageContext.save()
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.VC?.fetchLocation()

                } catch {
                    print("Failed to Save Location")
                }
            }
        }
    }
    func retriveLocationData() {
        let manageContext = CoreDataStorage.shared.managedObjectContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LocationEntity")
        let sort = [NSSortDescriptor(key: #keyPath(LocationEntity.date), ascending: true)]
        fetchRequest.sortDescriptors = sort
        do {
            let result = try manageContext.fetch(fetchRequest)
            if let resultArray = result as? [LocationEntity] {
                self.locationArray = resultArray
            }
        }
        catch {
            print("Failed to Save Location")
        }
    }
}
