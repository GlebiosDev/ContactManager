//
//  ContactsViewModel.swift
//  ContactManager
//
//  Created by Gleb Serediuk on 19.04.2023.
//

import Foundation
import Combine
import Kingfisher

final class ContactsViewModel: ObservableObject {

    enum State: Equatable {
        case loading
        case loaded(users: Users)
        case error(String)
    }

    @Published var state: State = .loading

    private let diContainer: DIContainer
    private var users: Users = []
    private var anyCancellable = Set<AnyCancellable>()

    init(diContainer: DIContainer) {
        self.diContainer = diContainer
    }

    func refreshableAction() {
        diContainer.services.contactsService.removeontacts()
            .sink { [weak self] in
                guard let self = self else { return }
                if case let .failure(error) = $0 {
                    debugPrint("render failed \(error)")
                    DispatchQueue.main.async {
                        self.state = .error(error.localizedDescription)
                    }
                }
            } receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.loadUsers(isReloading: true)
            }
            .store(in: &anyCancellable)
    }

    func loadUsers(isReloading: Bool) {
        diContainer.services.contactsService.loadContacts(isReloading: isReloading)
            .sink { [weak self] in
                guard let self = self else { return }
                if case let .failure(error) = $0 {
                    debugPrint("render failed \(error)")
                    DispatchQueue.main.async {
                        self.state = .error(error.localizedDescription)
                    }
                }
            } receiveValue: { [weak self] users in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.users = users
                    self.state = .loaded(users: self.users)
                }
            }
            .store(in: &anyCancellable)
    }

    func fetchDIContainer() -> DIContainer {
        return diContainer
    }


    // TODO: Downlaod Image

    func downloadImage(with urlString : String){
        guard let url = URL.init(string: urlString) else {
            return
        }
        let resource = ImageResource(downloadURL: url)
        let urls = users.compactMap { user in
            return URL(string: user.imageURL ?? "")
        }

        ImagePrefetcher(urls: urls) { skippedResources, failedResources, completedResources in
            // impl
        }
    }

}
