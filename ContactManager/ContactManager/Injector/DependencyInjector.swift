//
//  DependencyInjector.swift
//  ContactManager
//
//  Created by Gleb Serediuk on 19.04.2023.
//

import SwiftUI
import Combine

struct DIContainer: EnvironmentKey {
    
    let services: Services
    
    static var defaultValue: Self { Self.stub }
    private static var stub = DIContainer(services: .stub)
    
    init(services: Services) {
        self.services = services
    }
    
}

#if DEBUG
extension DIContainer {
    
    static var preview: Self {
        .init(services: .stub)
    }
    
}
#endif

// MARK: Services

extension DIContainer {
    
    struct Services {
        
        let contactsService: ContactService
        let contactDetailsService: ContactDetailsService
        
        init(contactsService: ContactService,
             contactDetailsService: ContactDetailsService) {
            self.contactsService = contactsService
            self.contactDetailsService = contactDetailsService
        }
        
        static var stub: Self {
            .init(contactsService: StubContatsService(),
                  contactDetailsService: StubContactDetailsService())
        }
        
    }
    
}

// MARK: StubContatsServices

extension DIContainer.Services {
    
    struct StubContatsService: ContactService {
        func removeontacts() -> Future<Bool, Error> {
            return Future { completion in completion(.success(true))
            }
        }
        
        func loadContacts(isReloading: Bool) -> Future<Users, Error> {
            return Future { completion in completion(.success([]))
            }
        }
    }
    
    
    struct StubContactDetailsService: ContactDetailsService {
        func userToUpdate(with user: User) -> Future<Bool, Error> {
            return Future { completion in completion(.success(true))
            }
        }
    }
    
}

// MARK: RepositoriesContainer

extension DIContainer {
    
    struct RepositoriesContainer {
        
        let contactsRepository: ContactsRepository
        let contactsLocalRepository: ContactsLocalRepository
        let contctDetailsRepository: ContactDetailsRepository
        
        init(contactsRepository: ContactsRepository,
             localRepository: ContactsLocalRepository,
             contactDetailsRepository: ContactDetailsRepository) {
            self.contactsRepository = contactsRepository
            self.contactsLocalRepository = localRepository
            self.contctDetailsRepository = contactDetailsRepository
        }
        
    }
    
}

// MARK: RemoteDataSourcesContainer

extension DIContainer {
    
    struct RemoteDataSourcesContainer {
        
        let contactRemoteDataSource: ContactRemoteDataSource
        
        init(contactRemoteDataSource: ContactRemoteDataSource) {
            self.contactRemoteDataSource = contactRemoteDataSource
        }
        
    }
    
}

// MARK: LocalDataSourcesContainer

extension DIContainer {
    
    struct LocalDataSourcesContainer {
        
        let contactsLocalDataSource: ContactsLocalDataSource
        let contactDetailsLocalDataSource: ContactDetailsLocalDataSource
        
        init(contactsLocalDataSource: ContactsLocalDataSource,
             contactDetailsLocalDataSource: ContactDetailsLocalDataSource) {
            self.contactsLocalDataSource = contactsLocalDataSource
            self.contactDetailsLocalDataSource = contactDetailsLocalDataSource
        }
        
    }
    
}

// MARK: LocalDataSourcesContainer

extension DIContainer {
    
    struct NetworkProviders {
        
        let contactsNetworkProvider: ContactsNetworkProvider
        
        init(contactsNetworkProvider: ContactsNetworkProvider) {
            self.contactsNetworkProvider = contactsNetworkProvider
        }
        
    }
    
}
