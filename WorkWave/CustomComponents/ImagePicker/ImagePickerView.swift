//
//  ImagePickerView.swift
//  WorkWave
//
//  Created by 조규연 on 11/28/24.
//

import SwiftUI
import ComposableArchitecture
import PhotosUI

struct ImagePickerView: View {
    @Bindable var store: StoreOf<ImagePicker>
    
    var body: some View {
        PHPickerView(configuration: store.configuration, isPresented: $store.isPresented) { data in
            store.send(.imageSelected(data))
        }
        .onAppear {
            store.send(.presented(true))
        }
    }
}

struct PHPickerView: UIViewControllerRepresentable {
    let configuration: PHPickerConfiguration
    @Binding var isPresented: Bool
    let onImageSelected: (Data?) -> Void
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onImageSelected: onImageSelected)
    }
    
    class Coordinator: PHPickerViewControllerDelegate {
        let onImageSelected: (Data?) -> Void
        
        init(onImageSelected: @escaping (Data?) -> Void) {
            self.onImageSelected = onImageSelected
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            guard let provider = results.first?.itemProvider else {
                picker.dismiss(animated: true)
                onImageSelected(nil)
                return
            }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    if let image = image as? UIImage {
                        let data = image.jpegData(compressionQuality: 0.8)
                        DispatchQueue.main.async {
                            self?.onImageSelected(data)
                        }
                    }
                }
            }
            
            picker.dismiss(animated: true)
        }
    }
}
