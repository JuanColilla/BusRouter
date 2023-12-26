//
//  RemoteResult.swift
//  BusRouter
//
//  Created by Juan Colilla on 20/12/23.
//

import Foundation

enum RemoteResult<Success: Equatable, Failure: Equatable & Error>: Equatable {
  case idle
  case loading
  case success(Success)
  case failure(Failure)
}

extension RemoteResult {
  init(_ result: Result<Success, Failure>) {
    switch result {
    case .success(let data):
      self = .success(data)
    case .failure(let error):
      self = .failure(error)
    }
  }
}
