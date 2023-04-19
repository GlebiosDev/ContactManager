//
//  Interfaces.swift
//  ContactManager
//
//  Created by Gleb Serediuk on 19.04.2023.
//

import CoreData
import Combine

protocol NSManagedObjectConvertible {
    associatedtype ManagedObject: NSManagedObject

    func toManagedObject(in context: NSManagedObjectContext) -> ManagedObject
    static func fromManagedObject(_ managedObject: ManagedObject) -> Self?
}

protocol LocalDataSaving {
    func create<T: NSManagedObjectConvertible>(_ object: [T]) -> Future<Bool, Error>
}

protocol LocalDataFetching {
    func fetchObjects<T: NSManagedObjectConvertible>() -> Future<[T], Error>
}
