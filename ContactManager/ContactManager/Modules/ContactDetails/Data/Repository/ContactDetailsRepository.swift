//
//  ContactDetailsRepository.swift
//  ContactManager
//
//  Created by Gleb Serediuk on 19.04.2023.
//

import Foundation
import Combine

protocol ContactDetailsRepository {
    func userToUpdate(with user: User) -> Future<Bool, Error>
}

struct ContactDetailsRepositoryImpl: ContactDetailsRepository {

    private let localDataSource: ContactDetailsLocalDataSource

    init(localDataSource: ContactDetailsLocalDataSource) {
        self.localDataSource = localDataSource
    }

    func userToUpdate(with user: User) -> Future<Bool, Error> {
        return localDataSource.userToUpdate(with: user)
    }
    
}
