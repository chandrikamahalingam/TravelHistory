//
//  LocationEntity+CoreDataClass.swift
//  TravelHistory
//
//  Created by TravelHistory on 05/12/21.
//
//

import Foundation
import CoreData

class LocationEntity: NSManagedObject, Codable {
    

    
    @NSManaged var id: String
    @NSManaged var date: Date
    @NSManaged var latitude:Double
    @NSManaged var longitude: Double
    @NSManaged var location_name: String
    @NSManaged var dateString: String

    enum CodingKeys: String, CodingKey {
        case id
        case date
        case latitude
        case longitude
        case location_name
        case coordinates
        case dateString
    }
    required convenience init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "LocationEntity", in: managedObjectContext) else {
            fatalError("Failed to decode User")
        }

        self.init(entity: entity, insertInto: managedObjectContext)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        date = try container.decode(Date.self, forKey: .date)
        location_name = try container.decode(String.self, forKey: .location_name)
        dateString = try container.decode(String.self, forKey: .dateString)
        
        let coordinates = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .coordinates)
        latitude = try coordinates.decode(Double.self, forKey: .latitude)
        longitude = try coordinates.decode(Double.self, forKey: .longitude)
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
        try container.encode(dateString, forKey: .dateString)
        
        var coordinates = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .coordinates)
        try coordinates.encode(latitude, forKey: .latitude)
        try coordinates.encode(longitude, forKey: .longitude)
    }
}
