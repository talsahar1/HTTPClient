//
//  APIResult.swift
//  HTTPClient
//
//  Created by Tal Sahar on 4/2/19.
//  Copyright © 2019 Tal Sahar. All rights reserved.
//

import Foundation


/// Represents APIResult enum with generic body type.
enum APIResult<Body> {
    case success(APIResponse<Body>)
    case failure(APIError)
}
