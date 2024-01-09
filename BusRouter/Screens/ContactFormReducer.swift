//
//  ContactFormReducer.swift
//  BusRouter
//
//  Created by Juan Colilla on 3/1/24.
//

import Foundation
import ComposableArchitecture
import ValidationKit

struct ContactFormReducer: Reducer {
    
    enum Action: Equatable {
        case onAppear
        case nameChanged(String)
        case emailChanged(String)
        case phoneChanged(String)
        case bugDescriptionChanged(String)
        case completeForm
    }
    
    struct State: Equatable {
        @Validated(.notEmpty)
        var name: String
        
        var nameVS: ValidationState {
            if formCompleted { return _name.validationState }
            else { return .idle }
        }
        
        @Validated(.email)
        var email: String
        
        var emailVS: ValidationState {
            if formCompleted { return _email.validationState }
            else { return .idle }
        }
        
        var phone: String = ""
        
        var bugDate: Date
        
        @Validated(.notEmpty, .maxLenght(200))
        var bugDescription: String
        
        var bugDescriptionVS: ValidationState {
            if formCompleted { return _bugDescription.validationState }
            else { return .idle }
        }
        
        var formCompleted: Bool = false
        var isFormValid: Bool { [nameVS, emailVS, bugDescriptionVS].allSatisfy{ $0 == .valid } }
        
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            case .nameChanged(let name):
                state.formCompleted = false
                state.name = name
                return .none
            case .emailChanged(let email):
                state.formCompleted = false
                state.email = email
                return .none
            case .phoneChanged(let phone):
                state.formCompleted = false
                state.phone = phone
                return .none
            case .bugDescriptionChanged(let bugDescription):
                state.formCompleted = false
                state.bugDescription = bugDescription
                return .none
            case .completeForm:
                state.formCompleted = true
                return .none
            }
        }
    }
}
