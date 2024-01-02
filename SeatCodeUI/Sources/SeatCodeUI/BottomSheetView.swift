//
//  SwiftUIView.swift
//
//
//  Created by Juan Colilla on 18/12/23.
//

import SwiftUI

public enum SheetState {
  case minimized, half, full
}

public struct BottomSheetView<Content: View>: View {

  private var offset: CGFloat {
    switch sheetState {
    case .minimized:
      return maxHeight * 0.9  // 10% visible
    case .half:
      return maxHeight * 0.5  // 50% visible
    case .full:
      return 0  // 100% visible
    }
  }
  @GestureState
  private var translation: CGFloat = 0

  @Binding
  var sheetState: SheetState

  let maxHeight: CGFloat
  var content: Content
  var colorScheme: ColorScheme

  public init(
    sheetState: Binding<SheetState>,
    maxHeight: CGFloat,
    colorScheme: ColorScheme,
    @ViewBuilder content: () -> Content
  ) {
    self._sheetState = sheetState
    self.maxHeight = maxHeight
    self.colorScheme = colorScheme
    self.content = content()
  }

  public var body: some View {
    GeometryReader { geometry in
      VStack(spacing: 0) {
        HStack {
          Spacer()
          RoundedRectangle(cornerRadius: 25.0)
            .fill(.gray.opacity(0.5))
            .frame(
              width: 40, height: 5, alignment: /*@START_MENU_TOKEN@*/ .center /*@END_MENU_TOKEN@*/
            )
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
            let dragThreshold = maxHeight * 0.1
            let dragDistance = abs(value.translation.height)

            // Si el arrastre está dentro del umbral, no cambia el estado
            if dragDistance < dragThreshold { return }

            if value.translation.height > 0 {  // Arrastre hacia abajo
              switch sheetState {
              case .minimized, .half:
                sheetState = .minimized
              case .full:
                // Si el arrastre hacia abajo es de una distancia superior a la mitad del máximo de altura permitido el nuevo estado será "minimized", si es de menos será "half"
                sheetState = dragDistance > abs(maxHeight * 0.5) ? .minimized : .half
              }
            } else {  // Arrastre hacia arriba
              switch sheetState {
              case .minimized:
                // Si el arrastre hacia arriba es de una distancia superior a la mitad del máximo de altura permitido el nuevo estado será "full", si es de menos será "half"
                sheetState = dragDistance > abs(maxHeight * 0.5) ? .full : .half
              case .half, .full:
                sheetState = .full
              }
            }
          }
      )
    }
  }
}

#Preview {
  BottomSheetView(sheetState: .constant(.half), maxHeight: 850, colorScheme: .dark) {
    VStack(alignment: .center) {
      ForEach(0..<5, id: \.self) { index in
        Text("Item \(index)")
      }
    }
  }
}
