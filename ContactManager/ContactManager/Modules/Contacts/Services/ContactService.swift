//
//  ContactService.swift
//  ContactManager
//
//  Created by Gleb Serediuk on 19.04.2023.
//

import Combine
import Foundation

protocol ContactService {
    func loadContacts(isReloading: Bool) -> Future<Users, Error>
    func removeontacts() -> Future<Bool, Error>
}

final class ContactServiceImpl: ContactService {

    private let repository: ContactsRepository
    private let localRepository: ContactsLocalRepository
    private let keyValueStorage: KeyValueStorage = UserDefaults.standard
    private var cancellables = Set<AnyCancellable>()

    init(repository: ContactsRepository,
         localRepository: ContactsLocalRepository) {
        self.repository = repository
        self.localRepository = localRepository
    }

    func removeontacts() -> Future<Bool, Error> {
        return localRepository.removeontacts()
    }

    func loadContacts(isReloading: Bool = false) -> Future<Users, Error> {
        guard !isReloading else {
            return loadRemoteContacts()
        }
        if keyValueStorage.object(forKey: KeyValueStorageKeys.isFirstLaunchLoaded) as? Bool ?? false {
            return fetchLocalUsers()
        } else {
            keyValueStorage.set(true, forKey: KeyValueStorageKeys.isFirstLaunchLoaded)
            return loadRemoteContacts()
        }
    }

    func loadRemoteContacts() -> Future<Users, Error> {
        return Future { [weak self] completion in
            guard let self = self else { return }
            self.repository.loadContacts()
                .sink {
                    if case let .failure(error) = $0 {
                        completion(.failure(error))
                    }
                } receiveValue: { users in
                    self.saveUsers(users)
                        .sink {
                            if case let .failure(error) = $0 {
                                completion(.failure(error))
                            }
                        } receiveValue: { isSaved in
                            self.fetchLocalUsers()
                                .sink {
                                    if case let .failure(error) = $0 {
                                        completion(.failure(error))
                                    }
                                } receiveValue: { users in
                                    completion(.success(users))
                                }
                                .store(in: &self.cancellables)
                        }
                        .store(in: &self.cancellables)
                }
                .store(in: &self.cancellables)

        }
    }

    private func saveUsers(_ users: Users) -> Future<Bool, Error> {
        return Future { completion in
            self.localRepository.createUsers(users)
                .sink {
                    if case let .failure(error) = $0 {
                        completion(.failure(error))
                    }
                } receiveValue: { isSaved in
                    completion(.success(isSaved))
                }
                .store(in: &self.cancellables)
        }
    }

    private func fetchLocalUsers() -> Future<Users, Error> {
        return Future { completion in
            self.localRepository.fetchBarcodes()
                .sink {
                    if case let .failure(error) = $0 {
                        completion(.failure(error))
                    }
                } receiveValue: { users in
                    completion(.success(users))
                }
                .store(in: &self.cancellables)
        }

    }

}
