//
//  CodingUserInfoKey+Util.swift
//  TravelHistory
//
//  Created by TravelHistory on 05/12/21.
//

import Foundation

public extension CodingUserInfoKey {
    // Helper property to retrieve the Core Data managed object context
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}
