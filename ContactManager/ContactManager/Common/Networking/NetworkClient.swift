//
//  NetworkClient.swift
//  ContactManager
//
//  Created by Gleb Serediuk on 19.04.2023.
//

import Foundation
import Combine
import Alamofire

final class NetworkClient: NetworkProvider {

    private var session: Session = Session.default

    func request(_ info: RequestInfoConvertible) -> AnyPublisher<Data, Error> {
        let requestInfo = info.asRequestInfo()
        return session.request(requestInfo.url,
                               method: requestInfo.method,
                               parameters: requestInfo.parameters,
                               encoding: requestInfo.encoding,
                               headers: requestInfo.headers,
                               requestModifier: requestInfo.requestModifier)
        .validate(statusCode: 200..<305)
        .publishData().tryMap { response -> Data in
            switch response.result {
                case .success(let data):
                    return data
                case .failure(let error):
                    throw error
            }
        }
        .eraseToAnyPublisher()
    }

}
