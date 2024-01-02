//
//  SwiftUIView.swift
//
//
//  Created by Juan Colilla on 1/1/24.
//

import SwiftUI

public struct StopMarker: View {
    
    @State
    var isFocused: Bool = false
    var stopInfo: StopInfo = StopInfo(
        passengerName: "N/A",
        address: "N/A",
        stopTime: "N/A",
        paid: false,
        price: 0.0
    )
    
    public init(stopInfo: StopInfo?) {
        self.isFocused = isFocused
        if let stopInfo { self.stopInfo = stopInfo }
    }
    
    public var body: some View {
        
        if isFocused {
            VStack {
                Text(stopInfo.address)
                    .font(.title3)
                HStack {
                    HStack {
                        Image(systemName: "person.fill")
                        Text(stopInfo.passengerName)
                    }
                    Spacer()
                    HStack {
                        Image(systemName: "clock.fill")
                        Text(stopInfo.stopTime)
                    }
                }
                HStack {
                    HStack {
                        Image(systemName: "eurosign.circle.fill")
                        Text("\(stopInfo.price)")
                    }
                    Spacer()
                    HStack {
                        Text("Pagado: ")
                        Image(systemName: stopInfo.paid ? "checkmark.circle.fill" : "x.circle.fill")
                            .foregroundStyle(.white, stopInfo.paid ? .green : .red)
                    }
                }
            }
            .frame(width: 250)
            .foregroundStyle(.white)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 10.0)
                    .foregroundStyle(.blue)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 10.0)
                    .stroke(Color.white, lineWidth: 2)
            )
            .onTapGesture {
                isFocused = false
            }
        } else {
            Circle()
                .foregroundStyle(.blue)
                .frame(width: 10, height: 10)
                .foregroundStyle(.white)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                )
                .transition(.scale)
                .animation(.easeIn, value: isFocused)
                .onTapGesture {
                    isFocused = true
                }
        }
    }
}

extension StopMarker {
    public struct StopInfo: Equatable {
        var passengerName: String
        var address: String
        var stopTime: String
        var paid: Bool
        var price: Double
        
        public init(
            passengerName: String, address: String, stopTime: String, paid: Bool, price: Double) {
            self.passengerName = passengerName
            self.address = address
            self.stopTime = stopTime
            self.paid = paid
            self.price = price
        }
    }
}

#Preview {
    StopMarker(
        stopInfo: StopMarker.StopInfo(
            passengerName: "Juan Colilla",
            address: "Ramblas, Barcelona",
            stopTime: "18:00",
            paid: true,
            price: 2.5
        )
    )
}
