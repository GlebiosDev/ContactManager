//
//  KeyValueStorage.swift
//  ContactManager
//
//  Created by Gleb Serediuk on 19.04.2023.
//

import Foundation

// MARK: - KeyValueStorage

protocol KeyValueStorage: AnyObject {
    func set(_ value: Any?, forKey defaultName: String)
    func object(forKey defaultName: String) -> Any?
    func removeObject(forKey defaultName: String)

#if targetEnvironment(simulator)
    @discardableResult func synchronize() -> Bool
#endif
}

extension UserDefaults: KeyValueStorage {}

// MARK: - keyValueStorageKeys

enum KeyValueStorageKeys {
    static let isFirstLaunchLoaded = "isFirstLaunchLoaded"
}
