//
//  APIError.swift
//  HTTPClient
//
//  Created by Tal Sahar on 4/2/19.
//  Copyright © 2019 Tal Sahar. All rights reserved.
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
    case decodingFailure
}
