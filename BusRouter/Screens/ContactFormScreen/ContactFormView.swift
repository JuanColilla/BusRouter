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
    
    @Binding
    var bugReporterPresented: Bool
    
    let store: StoreOf<ContactFormReducer>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
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
                            .foregroundColor(
                                viewStore.bugDescriptionVS == .notValid(.maxLenghtOverpassed) ?
                                    .red : Current.colorScheme == .light ? .black : .white
                            )
                    }
                }
            }
            .padding()
            Button(
                action: {
                    viewStore.send(.completeForm)
                    if viewStore.isFormValid {
                        bugReporterPresented = false
                    }
                }, label: {
                    HStack {
                        Spacer()
                        Text("Enviar")
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.blue)
                    }
                }
            )
            .padding()
            Spacer()
                .navigationTitle("Reportar Bug")
        }
    }
}

#Preview {
    ContactFormView(
        bugReporterPresented: .constant(true),
        store: StoreOf<ContactFormReducer>(
            initialState: ContactFormReducer.State(
                bugDate: .now
            )
        ) {
            ContactFormReducer()
        }
    )
}
