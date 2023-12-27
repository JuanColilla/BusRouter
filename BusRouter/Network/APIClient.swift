//
//  APIClient.swift
//  BusRouter
//
//  Created by Juan Colilla on 20/12/23.
//

import Foundation

class APIClient {
  /// Provided base URL for API calls and Endpoint appending.
  private let baseURL: String

  init(baseURL: String) {
    self.baseURL = baseURL
  }

  /**
     Sends a network request to the API and returns the result as a Codable object.

     - Parameters:
        - request: An `APIRequest` object that encapsulates all the necessary information for the request.

     - Returns: The response data decoded as the generic `Codable` type `T`.

     - Throws:
        - `APIError.BAD_URL` if there's an issue with the URL.
        - `APIError.MISSING_RESPONSE` if there's no HTTP response.
        - `APIError.CLIENT_ERROR(_:)` if the HTTP response status code is between 400 and 499.
        - `APIError.SERVER_ERROR(_:)` if the HTTP response status code is between 500 and 599.
        - `APIError.UNKNOWN_ERROR(_:)` if the HTTP response status code is not within the expected ranges.
        - `JSONError.ENCODING_ERROR(_:)` if there's an issue encoding the request body to JSON.
        - `JSONError.DECODING_ERROR(_:)` if there's an issue decoding the response data from JSON.

     - Note: This function uses Swift 5.5's new concurrency model with async/await.

     Usage:
     ```swift
     do {
        let request = APIRequest(endpoint: "/endpoint", httpMethod: .GET)
        let result: MyResponse = try await apiClient.send(request)
        print("Received response: \(result)")
     } catch {
        print("Error sending request: \(error)")
     }
     ```

     */
  func send<T: Codable>(_ request: APIRequest) async throws -> T {

    // URL CREATION
    guard let url = URL(string: baseURL.appending(request.endpoint.appendingPath)) else {
      Current.logger.critical(
        "Failed to form a baseURL from \(self.baseURL.appending(request.endpoint.appendingPath), privacy: .auto)"
      )
      throw APIError.BAD_URL
    }

    // REQUEST CREATION
    var urlRequest = URLRequest(url: url, cachePolicy: request.cachePolicy)
    urlRequest.httpMethod = request.httpMethod.rawValue
    urlRequest.allHTTPHeaderFields = [
      "Content-Type": "application/json",
      "User-Agent": "BusRouter/\(Current.appVersion)/\(Current.compilationNumber)",
      "Accept": "application/json",
      "Accept-Language": Current.languageCode,
    ]

    // HTTPMethod DEFINITION
    switch request.httpMethod {
    case .POST, .PUT:
      do {
        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: request.body!, options: [])
      } catch {
        throw JSONError.ENCODING_ERROR(error)
      }
    default:
      break
    }

    print(
      "⬆️ Sending: \(String(describing: urlRequest.allHTTPHeaderFields)) \n to \(String(describing: urlRequest.url))"
    )

    // CALL
    let (data, response) = try await URLSession.shared.data(for: urlRequest)

    guard let httpResponse = response as? HTTPURLResponse else {
      throw APIError.MISSING_RESPONSE
    }

    // DEBUG ZONE
    print(
      "⬇️ Receiving: \(httpResponse.statusCode) \n \(String(data: data, encoding: .utf8) ?? "Data can not be processed to a String") "
    )

    // STATUS CODE PROCESSMENT
    switch httpResponse.statusCode {
    case 200..<300:
      //            if T.self is EmptyBodyDecoded.Type {
      //                return (EmptyBodyDecoded() as! T)
      //            } else {
      do {
        let decodedData = try JSONDecoder().decode(T.self, from: data)
        return decodedData
      } catch {
        throw JSONError.DECODING_ERROR(error)
      }
    //}
    case 400..<499:
      throw APIError.CLIENT_ERROR(httpResponse.statusCode)
    case 500..<599:
      throw APIError.SERVER_ERROR(httpResponse.statusCode)
    default:
      throw APIError.UNKNOWN_ERROR(httpResponse.statusCode)
    }
  }

  func cleanCache() {
    URLCache.shared.removeAllCachedResponses()
  }
}
