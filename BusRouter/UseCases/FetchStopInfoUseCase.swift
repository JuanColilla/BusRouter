//
//  FetchStopInfoUseCase.swift
//  BusRouter
//
//  Created by Juan Colilla on 2/1/24.
//

import Foundation

struct FetchStopInfoUseCase {
    func execute() async -> Result<Stop, APIError> {
        do {
            let stopInfo: Stop = try await Current.apiClient.send(StopInfoRequest())
            return .success(stopInfo)
        } catch let error as APIError {
            return .failure(error)
        } catch {
            return .failure(.UNDERLYING_ERROR(error))
        }
    }
}
