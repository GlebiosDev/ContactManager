//
//  AppEnvironment.swift
//  ContactManager
//
//  Created by Gleb Serediuk on 19.04.2023.
//

import Foundation

import CoreData.NSPersistentContainer

struct AppEnvironment {

    let diContainer: DIContainer

    static func bootstrap() -> AppEnvironment {
        let persistentStore = CoreDataStack(version: CoreDataStack.Version.actual)
        let networkClient: NetworkClient = configureNetworkClient()
        let networkProviders: DIContainer.NetworkProviders = configurationNetworkProviders(networkClient: networkClient)
        let remoteDataSources: DIContainer.RemoteDataSourcesContainer = configureRemoteDataSource(networkProviders: networkProviders)
        let localDataSources: DIContainer.LocalDataSourcesContainer = configureLocalDataSource(persistentContainer: persistentStore.container)
        let repositories: DIContainer.RepositoriesContainer = configureRepository(remoteDataSources: remoteDataSources,
                                                                                  localDataSotuces: localDataSources)
        let services: DIContainer.Services = configureServices(repositories: repositories)
        let diContainer: DIContainer = DIContainer(services: services)
        return .init(diContainer: diContainer)
    }

}

// MARK: - DIContainer Configurations

extension AppEnvironment {

    private static func configureDIContainer(services: DIContainer.Services) -> DIContainer {
        return .init(services: services)
    }

}

// MARK: - Local Services Configurations

extension AppEnvironment {

    private static func configureServices(repositories: DIContainer.RepositoriesContainer) -> DIContainer.Services {
        let contactsService: ContactService = ContactServiceImpl(
            repository: repositories.contactsRepository,
            localRepository: repositories.contactsLocalRepository
        )

        let contactDetailsService: ContactDetailsService = ContactDetailsServiceImpl(
            repository: repositories.contctDetailsRepository
        )
        return .init(contactsService: contactsService,
                     contactDetailsService: contactDetailsService)
    }

}

// MARK: - Repository Configurations

extension AppEnvironment {

    private static func configureRepository(remoteDataSources: DIContainer.RemoteDataSourcesContainer,
                                            localDataSotuces: DIContainer.LocalDataSourcesContainer) -> DIContainer.RepositoriesContainer {
        let contatsRepository: ContactsRepository = ContactsRepositoryImpl(
            contactsRemoteDataSource: remoteDataSources.contactRemoteDataSource
        )

        let contactsLocalRepository: ContactsLocalRepository = ContactsLocalRepositoryImpl(
            contactsLocalDataSource: localDataSotuces.contactsLocalDataSource
        )

        let contactDetailsRepository: ContactDetailsRepository = ContactDetailsRepositoryImpl(
            localDataSource: localDataSotuces.contactDetailsLocalDataSource
        )

        return .init(contactsRepository: contatsRepository,
                     localRepository: contactsLocalRepository,
                     contactDetailsRepository: contactDetailsRepository)
    }

}

// MARK: - Remote Data Source Configurations

extension AppEnvironment {

    private static func configureRemoteDataSource(networkProviders: DIContainer.NetworkProviders) -> DIContainer.RemoteDataSourcesContainer {
        let contactsRemoteDataSource: ContactRemoteDataSource = ContactRemoteDataSourceImpl(
            networkClient: networkProviders.contactsNetworkProvider
        )
        return .init(contactRemoteDataSource: contactsRemoteDataSource)
    }

}

// MARK: - Local Data Source Configurations

extension AppEnvironment {

    private static func configureLocalDataSource(persistentContainer: NSPersistentContainer) -> DIContainer.LocalDataSourcesContainer {
        let contactsLocalDaraSource: ContactsLocalDataSource = ContactsLocalDataSourceImpl(
            container: persistentContainer
        )

        let contactDetailsLocalDataSOurce: ContactDetailsLocalDataSource = ContactDetailsLocalDataSourceImpl(
            container: persistentContainer
        )

        return .init(contactsLocalDataSource: contactsLocalDaraSource,
                     contactDetailsLocalDataSource: contactDetailsLocalDataSOurce)
    }

}

// MARK: NetworkClient

extension AppEnvironment {

    private static func configureNetworkClient() -> NetworkClient {
        return NetworkClient()
    }

}

// MARK: NetworkProviders

extension AppEnvironment {

    private static func configurationNetworkProviders(networkClient: NetworkProvider) -> DIContainer.NetworkProviders {
        let contactsNetworkProvider: ContactsNetworkProvider = ContactsRemoteClient(
            networkClient: networkClient
        )
        return .init(contactsNetworkProvider: contactsNetworkProvider)
    }
}
