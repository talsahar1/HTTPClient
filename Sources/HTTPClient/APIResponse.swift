//
//  APIResponse.swift
//  Stocks
//
//  Created by Tal Sahar on 20/03/2022.
//

import Foundation

typealias APIResult<Body> = Result<APIResponse<Body>, APIError>

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
            throw APIError.decodingFailure(NSError(domain: "Decoding failed", code: 0))
        }
        let decodedJSON = try JSONDecoder().decode(type, from: data)
        return APIResponse<BodyType>(statusCode: statusCode, body: decodedJSON)
    }
}
