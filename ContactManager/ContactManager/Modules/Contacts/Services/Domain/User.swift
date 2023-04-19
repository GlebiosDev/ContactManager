//
//  User.swift
//  ContactManager
//
//  Created by Gleb Serediuk on 19.04.2023.
//

import Foundation
import CoreData

typealias Users = [User]

struct User: Identifiable, Hashable {

    typealias Identifier = String

    let id: Identifier?
    let firstName: String?
    let lastName: String?
    let imageURL: String?
    let email: String?
}

extension User: NSManagedObjectConvertible {

    func toManagedObject(in context: NSManagedObjectContext) -> UserEntity {
        let userEntity = UserEntity(context: context)
        userEntity.id = id
        userEntity.imageURL = imageURL
        userEntity.firstName = firstName
        userEntity.lastName = lastName
        userEntity.email = email
        return userEntity
    }

    static func fromManagedObject(_ object: UserEntity) -> User? {
        guard let id = object.id else {
            return nil
        }
        return User(id: id,
                    firstName: object.firstName,
                    lastName: object.lastName,
                    imageURL: object.imageURL,
                    email: object.email)
    }
    
}
