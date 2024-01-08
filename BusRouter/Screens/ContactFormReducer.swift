//
//  ContactFormReducer.swift
//  BusRouter
//
//  Created by Juan Colilla on 3/1/24.
//

import Foundation
import ComposableArchitecture

struct ContactFormReducer: Reducer {
    
    enum Action: Equatable {
        case onAppear
        
    }
    
    struct State: Equatable {
        
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            }
        }
    }
}
