//
//  MultipleChoiceEditorView.swift
//  iRemember
//
//  Created by Privat on 24.07.23.
//

import SwiftUI
import SwiftData
import PhotosUI

struct MultipleChoiceEditorView: View {
	
	@State var vm: MultipleChoiceEditorViewModel
	@FocusState var focus: Int?
	
	init(vm: ExerciseEditorViewModel) {
		self._vm = State(initialValue: MultipleChoiceEditorViewModel(vm: vm))
	}
	
    var body: some View {
		Form {
			Section {
				LabeledImage(vm.multipleChoice.image) {
					HStack {
						TextField("Question", text: $vm.multipleChoice.question)
							.focused($focus, equals: 0)
						PhotoPicker($vm.multipleChoice.imageData) {
							Image(systemName: "photo")
						}
					}
				}
			}
			answers
			Section {
				Button("Add answer") {
					withAnimation {
						vm.addAnswer()
						focus = vm.multipleChoice.answers.count - 1
						vm.vm.scrollTo(vm.answers.count, anchor: .top)
					}
				}
			}
			.id(1)
		}
		.onAppear {
			focus = 0
			vm.setup()
		}
    }
	
	var answers: some View {
		ForEach($vm.answers) { answer in
			Section {
				LabeledImage(answer.wrappedValue.image) {
					HStack(alignment: .center) {
						Toggle(isOn: answer.isCorrect) {
							VStack {
								TextField("Answer", text: answer.text)
								TextField("Explanation", text: answer.explanation)
							}
						}
						PhotoPicker(answer.imageData) {
							Image(systemName: "photo")
								.resizable()
						}
					}
				}
			}
		}
		.optionalModifier(vm.answers.count > 1) { view in
			view.onDelete(perform: vm.removeAnswer)
		}
	}
	
}
