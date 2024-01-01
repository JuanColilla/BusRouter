//
//  SwiftUIView.swift
//  
//
//  Created by Juan Colilla on 1/1/24.
//

import SwiftUI

struct StopMarker: View {
    
    var body: some View {
        Circle()
            .foregroundStyle(.blue)
            .frame(width: 10, height: 10)
        .foregroundStyle(.white)
        .overlay(
            Circle()
                .stroke(Color.white, lineWidth: 2)
        )
    }
}

#Preview {
    StopMarker()
}
