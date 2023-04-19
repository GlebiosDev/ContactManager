//
//  ConctactDetailsView.swift
//  ContactManager
//
//  Created by Gleb Serediuk on 19.04.2023.
//

import SwiftUI

struct ConctactDetailsView: View {

    @StateObject var viewModel: ConctactDetailsViewModel

    var body: some View {
        GeometryReader { screen in
            ZStack {
                VStack {
                    Text("Contact Information")

                    GroupBox {
                        HStack {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("ID: " + (viewModel.user.id ?? ""))
                                Text("First Name: " + (viewModel.user.firstName ?? ""))
                                Text("Last Name: " + (viewModel.user.lastName ?? ""))
                                Text("ImageURL: " + (viewModel.user.imageURL ?? ""))
                                Text("Email: " + (viewModel.user.email ?? ""))
                            }
                            Spacer()
                        }
                        .frame(width: screen.size.width * 0.9)
                        Spacer()
                    }
                }
            }
        }
    }
}

struct ConctactDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ConctactDetailsView(viewModel: .init(diContainer: .preview,
                                             user: User(id: "123",
                                                        firstName: "Name",
                                                        lastName: "LastName",
                                                        imageURL: "ImageURL",
                                                        email: "Email"))
        )
    }
}
