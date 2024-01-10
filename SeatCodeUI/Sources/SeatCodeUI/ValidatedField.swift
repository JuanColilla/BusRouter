//
//  SwiftUIView.swift
//  
//
//  Created by Juan Colilla on 8/1/24.
//

import SwiftUI
import ValidationKit

public struct ValidatedField: View {
    
    @Environment(\.colorScheme)
    var appearance
    
    @Binding
    public var value: String
    
    public var validationState: ValidationState
    public var title: String
    public var hint: String
    
    public init(
        value: Binding<String>,
        title: String,
        hint: String,
        validationState: ValidationState
    ) {
        self._value = value
        self.title = title
        self.hint = hint
        self.validationState = validationState
    }
    
    private var validationImage: String {
        switch validationState {
        case .idle:
            return ""
        case .valid, .locked:
            return "checkmark.circle"
        case .notValid(_):
            return "x.circle"
        }
    }
    
    private var validationColor: Color {
        switch validationState {
        case .idle:
            return appearance == .light ? .black : .white
        case .valid:
            return .green
        case .locked:
            return .gray
        case .notValid(_):
            return .red
        }
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            Text(title)
            HStack {
                TextField(
                    hint,
                    text: $value
                )
                Image(
                    systemName: validationImage
                )
                .foregroundStyle(validationColor)
            }
            .padding(10)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 1.0)
                    .foregroundStyle(validationColor)
            }
        }
    }
}

#Preview {
    ValidatedField(
        value: .constant("Juan"),
        title: "Nombre",
        hint: "John",
        validationState: .idle
    )
}
