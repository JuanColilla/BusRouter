//
//  ContactFormView.swift
//  BusRouter
//
//  Created by Juan Colilla on 3/1/24.
//

import SwiftUI
import SeatCodeUI
import ValidationKit
import ComposableArchitecture

struct ContactFormView: View {
    
    let store: StoreOf<ContactFormReducer>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Text("Reportar Bug")
                .font(.title3)
            VStack(spacing: 20) {
                // NAME
                ValidatedField(
                    value: viewStore.binding(
                        get: \.name,
                        send: ContactFormReducer.Action.nameChanged
                    ),
                    title: "Nombre:",
                    hint: "John",
                    validationState: viewStore.nameVS
                )
                // EMAIL
                ValidatedField(
                    value: viewStore.binding(
                        get: \.email,
                        send: ContactFormReducer.Action.emailChanged
                    ),
                    title: "Email:",
                    hint: "john@appleseed.com",
                    validationState: viewStore.emailVS
                )
                // PHONE
                ValidatedField(
                    value: viewStore.binding(
                        get: \.phone,
                        send: ContactFormReducer.Action.phoneChanged
                    ),
                    title: "Teléfono:",
                    hint: "600600600",
                    validationState: .idle
                )
                VStack(alignment: .leading) {
                    Text("Descripción:")
                    TextView(
                        text: viewStore.binding(
                            get: \.bugDescription,
                            send: ContactFormReducer.Action.bugDescriptionChanged
                        ),
                        placeholder: "Describe el error encontrado.",
                        characterLimit: 201
                    )
                    .frame(height: 250)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10.0)
                            .stroke()
                            .foregroundColor(viewStore.bugDescriptionVS == .notValid(.maxLenghtOverpassed) ? .red : .black)
                    }
                }
            }
            .padding()
            Button(
                action: {
                    viewStore.send(.completeForm)
                }, label: {
                    Text("Enviar")
                }
            )
            Spacer()
        }
    }
}

#Preview {
    ContactFormView(
        store: StoreOf<ContactFormReducer>(
            initialState: ContactFormReducer.State(
                bugDate: .now
            )
        ) {
            ContactFormReducer()
        }
    )
}
