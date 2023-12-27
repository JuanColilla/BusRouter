//
//  APIRequest.swift
//  BusRouter
//
//  Created by Juan Colilla on 20/12/23.
//

import Foundation

/// Protocol that defines the structure of an API request.
///
/// - Properties:
///    - endpoint: An `Endpoint` object that specifies the API endpoint for the request.
///    - cachePolicy: A `URLRequest.CachePolicy` value that defines the caching behavior for the request.
///    - body: An optional Dictionary of type `[String: Any]` that contains the request body for POST requests.
///    - httpMethod: A `HTTPMethod` value that defines the HTTP method for the request.
///
/// Usage:
/// ```swift
/// struct MyRequest: APIRequest {
///    var endpoint: Endpoint = .someEndpoint
///    var cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
///    var body: [String : Any]? = ["key": "value"]
///    var httpMethod: HTTPMethod = .GET
/// }
protocol APIRequest {
  var endpoint: Endpoint { get set }
  var cachePolicy: URLRequest.CachePolicy { get set }
  var body: [String: Any]? { get set }
  var httpMethod: HTTPMethod { get set }
}
