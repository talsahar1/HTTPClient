//
//  APIClient.swift
//  Stocks
//
//  Created by Tal Sahar on 20/03/2022.
//

import Foundation


/// APIClient provides simple and efficient integration with URLSession.
/// To use, we initialize an instance of 'APIClient' on our provider and specify the baseURL.
/// Then we allow to perform http requests using 'perform' method passing 'APIRequest' object which encapsulates request's parameters.
class APIClient {
    
    private let session = URLSession.shared
    private let baseURL: URL
    
    
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
    func requestData(_ request: APIRequest, _ completion: @escaping (APIResult<Data?>) -> Void) {
        /// Prepare request
        var urlComponents = URLComponents()
        urlComponents.scheme = baseURL.scheme
        urlComponents.host = baseURL.host
        urlComponents.path = baseURL.path
        urlComponents.queryItems = request.queryItems
        
        guard let url = urlComponents.url?.appendingPathComponent(request.path) else {
            return completion(.failure(.invalidURL))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        
        request.header?.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.key) }
        
        // Perform dataTask.
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard let response = response as? HTTPURLResponse else {
                return completion(.failure(.requestFailed))
            }
            completion(.success(APIResponse<Data?>(statusCode: response.statusCode, body: data)))
        }
        task.resume()
    }
    
    func requestDecodable<T: Decodable>(_ request: APIRequest, _ completion: @escaping (APIResult<T>) -> Void) {
        requestData(request) { result in
            switch result {
            case .success(let response):
                do {
                    let decodable = try response.decode(to: T.self)
                    completion(.success(decodable))
                } catch {
                    completion(.failure(.decodingFailure(error)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
