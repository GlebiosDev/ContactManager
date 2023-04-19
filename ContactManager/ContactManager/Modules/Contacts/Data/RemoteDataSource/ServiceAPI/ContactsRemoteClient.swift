//
//  ContactsRemoteClient.swift
//  ContactManager
//
//  Created by Gleb Serediuk on 19.04.2023.
//

import Combine
import Foundation
import Alamofire

protocol ContactsNetworkProvider {
    func loadContacts() -> Future<UserDTO, Error>
}

final class ContactsRemoteClient: ContactsNetworkProvider  {

    private let networkClient: NetworkProvider
    private var cancellables = Set<AnyCancellable>()

    init(networkClient: NetworkProvider) {
        self.networkClient = networkClient
    }

    func loadContacts() -> Future<UserDTO, Error> {
        return Future { [weak self] completion in
            guard let self = self else { return }
            self.networkClient.request(ContactsEndpoint.contacts).decode()
                .sink(receiveCompletion: { result in
                    if case let .failure(error) = result {
                        completion(.failure(error))
                    }
                }, receiveValue: { response in
                    completion(.success(response))
                })
                .store(in: &self.cancellables)
        }
    }

}

private enum ContactsEndpoint: RequestInfoConvertible {

    case contacts

    // TODO: Refactor counts and url
    var url: URLConvertible {
        switch self {
            case .contacts:
                return URL(string: "https://randomuser.me/api")!
        }
    }

    var endpoint: String {
        switch self {
            case .contacts:
                return "/?results=50"
        }
    }

    func asRequestInfo() -> RequestInfo {
        return RequestInfo(url: url,endpoint: endpoint, method: .get)
    }

}
