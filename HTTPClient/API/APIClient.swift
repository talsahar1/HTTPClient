//
//  APIClient.swift
//  HTTPClient
//
//  Created by Tal Sahar on 4/2/19.
//  Copyright © 2019 Tal Sahar. All rights reserved.
//

import Foundation


/// APIClient provides simple and efficient integration with URLSession.
/// To use, we initialize an instance of 'APIClient' on our provider and specify the baseURL.
/// Then we allow to perform http requests using 'perform' method passing 'APIRequest' object which encapsulates request's parameters.
struct APIClient {
    
    typealias APIClientCompletion = (APIResult<Data?>) -> Void
    
    private let session = URLSession.shared
    private let baseURL: URL // For example: http://apple.com
    
    
    /// Initialize by baseURL String
    ///
    /// - Parameter baseURL: Creates URL object by baseURL
    /// - Throws: Throws APIError.invalidURL if URL initialization fails.
    init(baseURL: String) throws {
        if let baseURL = URL(string: baseURL) {
            self.baseURL = baseURL
        } else {
            throw APIError.invalidURL
        }
    }
    
    
    /// Perform HTTP request by APIRequest parameters and pass the result to completion closure.
    ///
    /// - Parameters:
    ///   - request: Encapsulates request parameters.
    ///   - completion: Completion closure.
    func perform(_ request: APIRequest, _ completion: @escaping APIClientCompletion) {
        /// Prepare request
        var urlComponents = URLComponents()
        urlComponents.scheme = baseURL.scheme
        urlComponents.host = baseURL.host
        urlComponents.path = baseURL.path
        urlComponents.queryItems = request.queryItems
        
        guard let url = urlComponents.url?.appendingPathComponent(request.path) else {
            completion(.failure(.invalidURL)); return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        
        request.header?.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.key) }
        
        // Perform dataTask.
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed)); return
            }
            completion(.success(APIResponse<Data?>(statusCode: response.statusCode, body: data)))
        }
        task.resume()
    }
}
