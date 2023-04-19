//
//  AnyPublisher+Extension.swift
//  ContactManager
//
//  Created by Gleb Serediuk on 19.04.2023.
//

import Combine
import Foundation

extension AnyPublisher where Output == Data, Failure == Error {

    func decode<T: Decodable>(jsonDecoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<T, Error> {
        return tryMap { data -> T in
            return try jsonDecoder.decode(T.self, from: data)
        }
        .eraseToAnyPublisher()
    }
    
}
