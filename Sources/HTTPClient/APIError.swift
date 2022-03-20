//
//  APIError.swift
//  Stocks
//
//  Created by Tal Sahar on 20/03/2022.
//

import Foundation

/// APIError
///
/// - invalidURL: Malformed url.
/// - requestFailed: Request failure.
/// - decodingFailure: Decode failure.
enum APIError: Error {
    case invalidURL
    case requestFailed
    case decodingFailure(Error)
}
