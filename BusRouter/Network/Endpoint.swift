//
//  Endpoint.swift
//  BusRouter
//
//  Created by Juan Colilla on 20/12/23.
//

import Foundation
/**
 A structure that represents the endpoint for an API request.

 - Properties:
    - appendingPath: A `String` value that specifies the path to be appended to the base URL for the request.
 
 Recommended usage:
 ```swift
 extension Endpoint {
    static let myEndpoint: Self = .init(appendingPath: "/api/v1/users")
 }
*/
struct Endpoint {
    var appendingPath: String
}
