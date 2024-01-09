//
//  TextView.swift
//  BusRouter
//
//  Created by Juan Colilla on 9/1/24.
//

import SwiftUI

struct TextView: UIViewRepresentable {
    @Binding
    var text: String
    @State
    private var isEditing = false
    var placeholder: String
    var characterLimit: Int

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.font = .systemFont(ofSize: 17)
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isEditing {
            uiView.text = placeholder
            uiView.textColor = .lightGray
        } else {
            uiView.text = text
            uiView.textColor = .black
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextView

        init(_ parent: TextView) {
            self.parent = parent
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            let currentText = textView.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
            return updatedText.count <= parent.characterLimit
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.textColor == .lightGray {
                textView.text = nil
                textView.textColor = .black
            }
            parent.isEditing = true
        }

        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                textView.text = parent.placeholder
                textView.textColor = .lightGray
                parent.text = ""
            }
            parent.isEditing = false

        }
    }
}
