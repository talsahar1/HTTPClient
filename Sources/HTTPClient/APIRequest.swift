//
//  APIRequest.swift
//  Stocks
//
//  Created by Tal Sahar on 20/03/2022.
//

import Foundation

/// HTTP method definitions.
enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

/// HTTPHeader typealias.
typealias HTTPHeader = [String: String]

/// API Request passed to APIClient and encapsulates request parameters.
struct APIRequest {
    let method: HTTPMethod
    let path: String
    var queryItems: [URLQueryItem]?
    var header: HTTPHeader?
    var body: Data?
    
    /// Initialize APIRequeset by HTTPMethod and path.
    init(method: HTTPMethod, path: String) {
        self.method = method
        self.path = path
    }
    
    /// Initialize APIRequest and encodes the given body Encodable into JSON representation.
    ///
    /// - throws: An error if any value throws an error during encoding.
    init<Body: Encodable>(method: HTTPMethod, path: String, body: Body) throws {
        self.method = method
        self.path = path
        self.body = try JSONEncoder().encode(body)
    }
}
