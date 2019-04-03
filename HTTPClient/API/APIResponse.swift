//
//  APIResponse.swift
//  HTTPClient
//
//  Created by Tal Sahar on 4/2/19.
//  Copyright © 2019 Tal Sahar. All rights reserved.
//

import Foundation

/// Generic response, encapsulates response StatusCode with generic Body.
struct APIResponse<Body> {
    let statusCode: Int
    let body: Body
}

/// Decodes APIResponse where Body is type of Data into top-level type.
/// - returns: A new APIResponse value containing the decoded JSON data.
extension APIResponse where Body == Data? {
    func decode<BodyType: Decodable>(to type: BodyType.Type) throws -> APIResponse<BodyType> {
        guard let data = body else {
            throw APIError.decodingFailure
        }
        let decodedJSON = try JSONDecoder().decode(type, from: data)
        return APIResponse<BodyType>(statusCode: statusCode, body: decodedJSON)
    }
}
