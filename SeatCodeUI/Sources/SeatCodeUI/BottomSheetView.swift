//
//  SwiftUIView.swift
//
//
//  Created by Juan Colilla on 18/12/23.
//

import SwiftUI

public struct BottomSheetView<Content: View>: View {
    
    public enum SheetState {
        case minimized, half, full
    }
    
    private var offset: CGFloat {
        switch sheetState {
        case .minimized:
            return maxHeight * 0.9 // 10% visible
        case .half:
            return maxHeight * 0.5 // 50% visible
        case .full:
            return 0 // 100% visible
        }
    }
    @GestureState
    private var translation: CGFloat = 0
    
    @Environment(\.colorScheme)
    private var colorScheme: ColorScheme
    
    @Binding
    var sheetState: SheetState
    
    let maxHeight: CGFloat
    var content: Content
    
    public init(
        sheetState: Binding<SheetState>,
        maxHeight: CGFloat,
        @ViewBuilder content: () -> Content
    ) {
        self._sheetState = sheetState
        self.maxHeight = maxHeight
        self.content = content()
    }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 25.0)
                        .fill(.gray.opacity(0.5))
                        .frame(width: 60, height: 6, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    Spacer()
                }
                .padding()
                content
            }
            .frame(width: geometry.size.width, height: maxHeight, alignment: .top)
            .background {
                BlurView(style: colorScheme == .light ? .systemMaterial : .systemMaterialDark)
            }
            .cornerRadius(25.0)
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: max(offset + translation, 0))
            .animation(.interactiveSpring, value: sheetState)
            .animation(.interactiveSpring(), value: translation)
            .gesture(
                DragGesture()
                    .updating($translation) { value, state, _ in
                        state = value.translation.height
                    }
                    .onEnded { value in
                        let snapDistances = [maxHeight * 0.9, maxHeight * 0.5, 0] // Minimizado, Medio, Completo
                        let closestSnapDistance = snapDistances.min(by: { abs($0 - value.translation.height) < abs($1 - value.translation.height) }) ?? maxHeight

                            switch closestSnapDistance {
                            case snapDistances[0]: // Minimizado
                                sheetState = .minimized
                            case snapDistances[1]: // Medio
                                sheetState = .half
                            default: // Completo
                                sheetState = .full
                            }
                        let dragThreshold = maxHeight * 0.25 // Ajusta según sea necesario
                        if value.translation.height > dragThreshold {
                            sheetState = value.translation.height > 0 ? .minimized : .half
                        } else if value.translation.height < -dragThreshold {
                            sheetState = value.translation.height < 0 ? .full : .half
                        }
                    }
            )
        }
    }
}

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

#Preview {
    BottomSheetView(sheetState: .constant(.half), maxHeight: 850) {
        VStack(alignment: .center) {
            ForEach(0..<5, id: \.self) { index in
                Text("Item \(index)")
            }
        }
    }
}
