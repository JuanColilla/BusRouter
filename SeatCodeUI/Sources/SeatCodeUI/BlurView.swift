//
//  BlurView.swift
//
//
//  Created by Juan Colilla on 29/12/23.
//

import SwiftUI

public struct BlurView: UIViewRepresentable {
  public var style: UIBlurEffect.Style
    
    public init(style: UIBlurEffect.Style) {
        self.style = style
    }

  public func makeUIView(context: Context) -> UIVisualEffectView {
    return UIVisualEffectView(effect: UIBlurEffect(style: style))
  }

  public func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
    uiView.effect = UIBlurEffect(style: style)
  }
}

#Preview {
    BlurView(style: .systemMaterial)
}
