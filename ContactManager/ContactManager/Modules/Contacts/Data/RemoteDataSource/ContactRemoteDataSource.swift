//
//  ContactRemoteDataSource.swift
//  ContactManager
//
//  Created by Gleb Serediuk on 19.04.2023.
//

import Combine

protocol ContactRemoteDataSource {
    func loadContacts() -> Future<Users, Error>
}

final class ContactRemoteDataSourceImpl: ContactRemoteDataSource {

    private let networkClient: ContactsNetworkProvider
    private var anyCancellable = Set<AnyCancellable>()

    init(networkClient: ContactsNetworkProvider) {
        self.networkClient = networkClient
    }

    func loadContacts() -> Future<Users, Error> {
        return Future { [weak self] completion in
            guard let self = self else { return }
            self.networkClient.loadContacts()
                .sink {
                    if case let .failure(error) = $0 {
                        completion(.failure(error))
                    }
                } receiveValue: { dto in
                    var users: Users = []
                    dto.results?.forEach { result in
                        let user = User(id: result.login?.uuid,
                                        firstName:result.name?.first,
                                        lastName: result.name?.last,
                                        imageURL: result.picture?.medium,
                                        email: result.email)
                        users.append(user)
                    }
                    completion(.success(users))
                }
                .store(in: &self.anyCancellable)
        }
    }
    
}
