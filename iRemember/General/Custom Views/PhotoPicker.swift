//
//  PhotoPicker.swift
//  iRemember
//
//  Created by Privat on 29.07.23.
//

import SwiftUI
import PhotosUI

struct PhotoPicker<Content: View>: View {
	
	@Binding var imageData: Data?
	@State private var selectedPhotos: [PhotosPickerItem] = []
	private let content: Content
	
	init(_ imageData: Binding<Data?>, @ViewBuilder content: @escaping () -> Content) {
		self._imageData = imageData
		self.content = content()
	}
	
    var body: some View {
		Menu {
			Section {
				PhotosPicker(selection: $selectedPhotos, maxSelectionCount: 1, matching: .images) {
					Label("Select photo", systemImage: "checkmark.circle")
				}
				Button {
					
				} label: {
					Label("Take photo", systemImage: "camera")
				}
			}
			if imageData != nil {
				Section {
					Button(role: .destructive) {
						withAnimation {
							imageData = nil
						}
					} label: {
						Label("Remove image", systemImage: "trash")
					}
				}
			}
		} label: {
			content
		}
		.buttonStyle(BorderlessButtonStyle())
		.onChange(of: selectedPhotos) { oldValue, newValue in
			loadImage()
		}
    }
	
	func loadImage() {
		selectedPhotos[0].loadTransferable(type: Data.self) { result in
			switch result {
			case .success(let data):
				self.imageData = data
			case .failure:
				assertionFailure("Image could not be loaded")
			}
		}
	}
	
}
