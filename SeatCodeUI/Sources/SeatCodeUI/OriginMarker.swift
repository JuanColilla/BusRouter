//
//  SwiftUIView.swift
//  
//
//  Created by Juan Colilla on 1/1/24.
//

import SwiftUI

struct OriginMarker: View {
    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: "bus")
        }
        .foregroundStyle(.white)
        .padding()
        .frame(width: 40, height: 40)
        .background {
            Circle()
                .foregroundStyle(.green)
        }
//        .overlay(
//            Circle()
//                .stroke(Color.black, lineWidth: 2)        
//        )
    }
}

#Preview {
    OriginMarker()
}
