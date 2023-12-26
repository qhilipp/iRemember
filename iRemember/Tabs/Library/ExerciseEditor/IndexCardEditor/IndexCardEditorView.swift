//
//  IndexCardEditorView.swift
//  iRemember
//
//  Created by Privat on 14.10.23.
//

import SwiftUI

struct IndexCardEditorView: View {
	
	@State var vm: IndexCardEditorViewModel
	
	init(vm: ExerciseEditorViewModel) {
		self._vm = State(initialValue: IndexCardEditorViewModel(vm: vm))
	}
	
    var body: some View {
		Form {
			Section("Front") {
				indexCardPageEditor(for: $vm.front)
			}
			Section("Back") {
				indexCardPageEditor(for: $vm.back)
			}
		}
		.onAppear {
			vm.setup()
		}
    }
	
	@ViewBuilder
	func indexCardPageEditor(for page: Binding<IndexCardPage>) -> some View {
		LabeledImage(page.wrappedValue.image, contract: false) {
			HStack(alignment: .center) {
				TextField("Text", text: page.text, axis: .vertical)
				PhotoPicker(page.imageData) {
					Image(systemName: "photo")
				}
			}
		}
	}
}
