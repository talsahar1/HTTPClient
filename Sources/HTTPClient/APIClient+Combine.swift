//
//  APIClient+Combine.swift
//  Stocks
//
//  Created by Tal Sahar on 20/03/2022.
//

import Combine
import Foundation

@available(iOS 13, *) 
extension APIClient {
    func requesetData(_ request: APIRequest) -> AnyPublisher<APIResponse<Data?>, APIError> {
        Future { [weak self] promise in
            self?.requestData(request, { result in
                promise(result)
            })
        }.eraseToAnyPublisher()
    }
    
    func requestDecodable<T: Decodable>(_ request: APIRequest) -> AnyPublisher<APIResponse<T>, APIError> {
        Future { [weak self] promise in
            self?.requestDecodable(request, { result in
                promise(result)
            })
        }.eraseToAnyPublisher()
    }
}
