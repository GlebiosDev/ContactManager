//
//  ContactsLocalRepository.swift
//  ContactManager
//
//  Created by Gleb Serediuk on 19.04.2023.
//

import Combine

protocol ContactsLocalRepository {
    func createUsers(_ users: Users) -> Future<Bool, Error>
    func fetchBarcodes() -> Future<Users, Error>
    func removeontacts() -> Future<Bool, Error>
}

struct ContactsLocalRepositoryImpl: ContactsLocalRepository {

    private let contactsLocalDataSource: ContactsLocalDataSource

    init(contactsLocalDataSource: ContactsLocalDataSource) {
        self.contactsLocalDataSource = contactsLocalDataSource
    }

    func createUsers(_ users: Users) -> Future<Bool, Error> {
        return contactsLocalDataSource.create(users)
    }

    func fetchBarcodes() -> Future<Users, Error> {
        return contactsLocalDataSource.fetchObjects()
    }

    func removeontacts() -> Future<Bool, Error> {
        return contactsLocalDataSource.removeontacts()
    }
    
}
