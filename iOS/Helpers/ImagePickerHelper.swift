//
//  ImagePicker.swift
//  DefiWallet (iOS)
//
//  Created by Brandon Shaw on 3/7/22.
//

import SwiftUI

// FIXME: I am not sure why this is throwing an error

/*
struct ImagePickerHelper: UIViewControllerRepresentable {

    @Environment(\.presentationMode)
    private var presentationMode

    let sourceType: UIImagePickerController.SourceType
    let onImagePicked: (URL, UIImage?) -> Void

    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

        @Binding
        private var presentationMode: PresentationMode
        private let sourceType: UIImagePickerController.SourceType
        private let onImagePicked: (URL, UIImage?) -> Void
        
        init(presentationMode: Binding<PresentationMode>,
             sourceType: UIImagePickerController.SourceType,
             onImagePicked: @escaping (URL, UIImage?) -> Void) {
            _presentationMode = presentationMode
            self.sourceType = sourceType
            self.onImagePicked = onImagePicked
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            presentationMode.dismiss()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                let imageUrl = info[UIImagePickerController.InfoKey.imageURL] as! URL
                let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
                
                self.onImagePicked(imageUrl, img)
            }
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            presentationMode.dismiss()
        }

    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(presentationMode: presentationMode,
                           sourceType: sourceType,
                           onImagePicked: onImagePicked)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {

    }

}
*/
