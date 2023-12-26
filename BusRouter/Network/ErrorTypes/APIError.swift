//
//  APIError.swift
//  BusRouter
//
//  Created by Juan Colilla on 20/12/23.
//

import Foundation

enum APIError: LocalizedError {
  // CODE
  case BAD_URL
  case MISSING_RESPONSE

  // INTERACTION
  case CLIENT_ERROR(Int)
  case SERVER_ERROR(Int)
  case UNKNOWN_ERROR(Int)
  case UNDERLYING_ERROR(Error)
}

extension APIError: Equatable {
  static func == (lhs: APIError, rhs: APIError) -> Bool {
    switch (lhs, rhs) {
    case (.BAD_URL, .BAD_URL),
      (.MISSING_RESPONSE, .MISSING_RESPONSE):
      return true

    case let (.CLIENT_ERROR(lhsCode), .CLIENT_ERROR(rhsCode)),
      let (.SERVER_ERROR(lhsCode), .SERVER_ERROR(rhsCode)),
      let (.UNKNOWN_ERROR(lhsCode), .UNKNOWN_ERROR(rhsCode)):
      return lhsCode == rhsCode

    case let (.UNDERLYING_ERROR(lhsError), .UNDERLYING_ERROR(rhsError)):
      return lhsError.localizedDescription == rhsError.localizedDescription

    default:
      return false
    }
  }
}
