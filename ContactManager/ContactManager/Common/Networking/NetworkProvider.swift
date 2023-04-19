//
//  NetworkProvider.swift
//  ContactManager
//
//  Created by Gleb Serediuk on 19.04.2023.
//

import Foundation
import Alamofire
import Combine

protocol NetworkProvider {
    func request(_ info: RequestInfoConvertible) -> AnyPublisher<Data, Error>
}

struct RequestInfo {

    var url: URLConvertible
    var method: HTTPMethod
    var parameters: Parameters?
    var encoding: JSONEncoding
    var headers: HTTPHeaders?
    var interceptor: RequestInterceptor?
    var requestModifier: Session.RequestModifier?
    var data: Data?
    var shouldContainAuthToken: Bool
    var shouldGetHeaders: Bool

    init(url: URLConvertible? = nil,
         endpoint: String? = nil,
         method: HTTPMethod = .get,
         parameters: Parameters? = nil,
         encoding: JSONEncoding = .default,
         headers: HTTPHeaders? = nil,
         interceptor: RequestInterceptor? = nil,
         requestModifier: Session.RequestModifier? = nil,
         data: Data? = nil,
         shouldContainAuthToken: Bool = true,
         getHeaders: Bool = false) {
        self.url = url ?? ""
        self.method = method
        self.parameters = parameters
        self.encoding = encoding
        self.headers = headers
        self.interceptor = interceptor
        self.requestModifier = requestModifier
        self.data = data
        self.shouldContainAuthToken = shouldContainAuthToken
        self.shouldGetHeaders = getHeaders
    }
}

protocol RequestInfoConvertible {
    func asRequestInfo() -> RequestInfo
}
