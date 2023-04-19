//
//  ContactDetailsLocalDataSource.swift
//  ContactManager
//
//  Created by Gleb Serediuk on 19.04.2023.
//

import Foundation
import CoreData
import Combine

protocol ContactDetailsLocalDataSource {
    func userToUpdate(with user: User) -> Future<Bool, Error>
}

struct ContactDetailsLocalDataSourceImpl: ContactDetailsLocalDataSource {

    private let container: NSPersistentContainer

    init(container: NSPersistentContainer) {
        self.container = container
    }

    func userToUpdate(with user: User) -> Future<Bool, Error> {
        return Future { completion in
            container.performBackgroundTask { privateManagedObjectContext in
                guard let userObject = NSEntityDescription.entity(forEntityName: "UserEntity", in: privateManagedObjectContext) else { return }
                let updateRequest = NSBatchUpdateRequest(entity: userObject)
                updateRequest.predicate = NSPredicate(format: "id = %@", user.id ?? "")
                updateRequest.propertiesToUpdate = ["id": user.id ?? "",
                                                    "firstName": user.firstName ?? "",
                                                    "lastName": user.firstName ?? "",
                                                    "email": user.email ?? ""]
                updateRequest.resultType = .updatedObjectIDsResultType

                do {
                    let result = try privateManagedObjectContext.execute(updateRequest) as? NSBatchUpdateResult
                    guard let objectIDs = result?.result as? [NSManagedObjectID] else { return }
                    let changes = [NSUpdatedObjectsKey: objectIDs]
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [container.viewContext])
                    completion(.success(true))
                } catch let error {
                    completion(.failure(error))
                }
            }
        }
    }

}
