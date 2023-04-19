//
//  UserEntity+CoreDataProperties.swift
//  ContactManager
//
//  Created by Gleb Serediuk on 19.04.2023.
//
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var email: String?
    @NSManaged public var firstName: String?
    @NSManaged public var id: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var lastName: String?

}

extension UserEntity : Identifiable {

}
