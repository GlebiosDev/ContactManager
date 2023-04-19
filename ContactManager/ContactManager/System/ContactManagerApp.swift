//
//  ContactManagerApp.swift
//  ContactManager
//
//  Created by Gleb Serediuk on 19.04.2023.
//

import SwiftUI

@main
struct ContactManagerApp: App {

    public let environment: AppEnvironment

    init() {
        environment = AppEnvironment.bootstrap()
    }

    var body: some Scene {
        WindowGroup {
            ContactsView(viewModel: .init(diContainer: environment.diContainer))
        }
    }
    
}
