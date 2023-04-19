//
//  ConctactDetailsViewModel.swift
//  ContactManager
//
//  Created by Gleb Serediuk on 19.04.2023.
//

import Foundation

final class ConctactDetailsViewModel: ObservableObject {

    @Published var userToUpdate: User?

    var user: User

    private let diContainer: DIContainer

    init(diContainer: DIContainer, user: User) {
        self.diContainer = diContainer
        self.user = user
    }

    // TODO: UpdateUser
    func userToUpdate(with user: User) {
        //diContainer.services.contactDetailsService.userToUpdate(with: userToUpdate)
    }

}
