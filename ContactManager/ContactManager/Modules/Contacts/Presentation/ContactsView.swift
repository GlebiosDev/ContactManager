//
//  ContactsView.swift
//  ContactManager
//
//  Created by Gleb Serediuk on 19.04.2023.
//

import SwiftUI

struct ContactsView: View {

    @StateObject var viewModel: ContactsViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                contentView
            }
            .navigationDestination(for: User.self, destination: { user in
                ConctactDetailsView(viewModel: .init(diContainer: viewModel.fetchDIContainer(),
                                                     user: user))
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.loadUsers(isReloading: true)
                    } label: {
                        Text("Reload")
                    }
                }
            }
        }

    }

    @ViewBuilder private var contentView: some View {
        switch viewModel.state {
            case let .loaded(users):
                Text("Count:")
                List {
                    ForEach(users, id: \.id) { user in

                        NavigationLink(value: user) {
                            VStack(alignment: .leading) {
                                Text("ID: \(user.id ?? "")")
                                Text("First Name: \(user.firstName ?? "")")
                                Text("Last Name: \(user.lastName ?? "")")
                                Text("Email: \(user.email ?? "")")
                                Text("ImageURL: \(user.imageURL ?? "")")
                            }
                        }
                    }
                }
                .refreshable {
                    viewModel.refreshableAction()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text("Conctas: \(users.count)")
                    }
                }

            case let .error(errorDescription):
                VStack(alignment: .center) {
                    Text("Error")
                        .bold()
                    Text(errorDescription)
                    Text("Please try Reload")
                }
                .padding(20)

            case .loading:
                ProgressView()
                    .onAppear {
                        viewModel.loadUsers(isReloading: false)
                    }
        }
    }

}

struct ContactsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsView(viewModel: .init(diContainer: .preview))
    }
}
