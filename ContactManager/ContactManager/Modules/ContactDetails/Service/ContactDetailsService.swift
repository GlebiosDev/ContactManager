//
//  ContactDetailsService.swift
//  ContactManager
//
//  Created by Gleb Serediuk on 19.04.2023.
//

import Foundation
import Combine

protocol ContactDetailsService {
    func userToUpdate(with user: User) -> Future<Bool, Error>
}

struct ContactDetailsServiceImpl: ContactDetailsService {

    private let repository: ContactDetailsRepository

    init(repository: ContactDetailsRepository) {
        self.repository = repository
    }

    func userToUpdate(with user: User) -> Future<Bool, Error> {
        return repository.userToUpdate(with: user)
    }

}
