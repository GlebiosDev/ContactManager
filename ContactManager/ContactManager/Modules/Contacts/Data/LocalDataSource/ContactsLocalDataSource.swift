//
//  ContactsLocalDataSource.swift
//  ContactManager
//
//  Created by Gleb Serediuk on 19.04.2023.
//

import Combine
import CoreData

protocol ContactsLocalDataSource: LocalDataSaving, LocalDataFetching {
    func removeontacts() -> Future<Bool, Error>
}

struct ContactsLocalDataSourceImpl: ContactsLocalDataSource {
    private let container: NSPersistentContainer

    init(container: NSPersistentContainer) {
        self.container = container
    }

    func removeontacts() -> Future<Bool, Error>  {
        return Future { completion in
            container.performBackgroundTask { privateContext in
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntity")
                let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

                do {
                    try privateContext.execute(batchDeleteRequest)
                    completion(.success(true))
                } catch {
                    debugPrint("NSBatchDeleteRequest Failed: \(error)")
                }
            }
        }
    }

    func create<T: NSManagedObjectConvertible>(_ object: [T]) -> Future<Bool, Error> {
        return Future { completion in
            container.performBackgroundTask { privateContext in

                object.forEach { object in
                    _ = object.toManagedObject(in: privateContext)
                }


                do {
                    try privateContext.save()
                    completion(.success(true))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }

    func fetchObjects<T: NSManagedObjectConvertible>() -> Future<[T], Error> {
        return Future { completion in
            container.performBackgroundTask { privateContext in
                let fetchRequest = T.ManagedObject.fetchRequest()

                do {
                    let objects = try privateContext.fetch(fetchRequest)
                    let convertedObjects = objects.compactMap { object in
                        if let managedObject = object as? T.ManagedObject {
                            return T.fromManagedObject(managedObject)
                        } else {
                            return nil
                        }
                    }
                    completion(.success(convertedObjects))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
}
