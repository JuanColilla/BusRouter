//
//  FetchTripsUseCase.swift
//  BusRouter
//
//  Created by Juan Colilla on 20/12/23.
//

import Foundation

struct FetchTripsUseCase {
  func execute() async -> Result<[Trip], APIError> {
    do {
      let tripListResult: [Trip] = try await Current.apiClient.send(TripListRequest())
      return .success(tripListResult)
    } catch let error as APIError {
      return .failure(error)
    } catch {
      return .failure(.UNDERLYING_ERROR(error))
    }
  }
}
