//
//  CoreDataStack.swift
//  ContactManager
//
//  Created by Gleb Serediuk on 19.04.2023.
//

import Foundation
import CoreData
import Combine

struct CoreDataStack {

    private struct Constants {
        static let modelName = "ContactManagerModel"
        static let subPathToDB = "db.contactManager"
        static let coreDataStackQueue = DispatchQueue(label: "com.ContactManager.CoreDataQueue")
    }

    private let isStoreLoaded = CurrentValueSubject<Bool, Error>(false)

    let container: NSPersistentContainer

    init(directory: FileManager.SearchPathDirectory = .documentDirectory,
         domainMask: FileManager.SearchPathDomainMask = .userDomainMask,
         version vNumber: UInt) {
        let version = Version(vNumber)

        container = NSPersistentContainer(name: version.modelName)
        if let url = version.dbFileURL(directory, domainMask) {
            debugPrint("DB Container URL: \(url)")
            let store = NSPersistentStoreDescription(url: url)
            container.persistentStoreDescriptions = [store]
        }

        Constants.coreDataStackQueue.async { [weak isStoreLoaded, weak container] in
            container?.loadPersistentStores { _, error in
                DispatchQueue.main.async {
                    if let error = error {
                        isStoreLoaded?.send(completion: .failure(error))
                    } else {
                        container?.viewContext.configureContext()
                        isStoreLoaded?.value = true
                    }
                }
            }
        }
    }

}

// MARK: - Versioning

extension CoreDataStack.Version {
    static var actual: UInt { 2 }
}

extension CoreDataStack {

    struct Version {
        private let number: UInt

        init(_ number: UInt) {
            self.number = number
        }

        var modelName: String {
            return Constants.modelName
        }

        func dbFileURL(_ directory: FileManager.SearchPathDirectory,
                       _ domainMask: FileManager.SearchPathDomainMask) -> URL? {
            let path = FileManager.default
                .urls(for: directory, in: domainMask).first?
                .appendingPathComponent(subPathToDB)
            return path
        }

        private var subPathToDB: String {
            return Constants.subPathToDB
        }
    }

}

// MARK: - NSManagedObjectContext Configuration

extension NSManagedObjectContext {

    func configureContext() {
        automaticallyMergesChangesFromParent = true
    }

}
