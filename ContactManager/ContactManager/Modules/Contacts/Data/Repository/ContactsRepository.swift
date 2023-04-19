//
//  ContactsRepository.swift
//  ContactManager
//
//  Created by Gleb Serediuk on 19.04.2023.
//

import Combine

protocol ContactsRepository {
    func loadContacts() -> Future<Users, Error>
}

struct ContactsRepositoryImpl: ContactsRepository {

    private let contactsRemoteDataSource: ContactRemoteDataSource

    init(contactsRemoteDataSource: ContactRemoteDataSource) {
        self.contactsRemoteDataSource = contactsRemoteDataSource
    }

    func loadContacts() -> Future<Users, Error> {
       return contactsRemoteDataSource.loadContacts()
    }
    
}
