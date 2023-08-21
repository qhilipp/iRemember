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
	
	@Environment(\.modelContext) var context: ModelContext
	@State var vm = MultipleChoiceEditorViewModel()
	@FocusState var focus: Int?
	let dismissAction: DismissAction
	
	var exercise: Exercise
	
    var body: some View {
		ScrollViewReader { p in
			Form {
				Section {
					LabeledImage(vm.mcExercise.image) {
						HStack {
							TextField("Question", text: $vm.mcExercise.question)
								.focused($focus, equals: 0)
							PhotoPicker($vm.mcExercise.imageData) {
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
							focus = vm.answers.count
							p.scrollTo(169)
						}
					}
				}
				.id(1)
			}
			.onChange(of: vm.answers.count) { oldValue, newValue in
				withAnimation {
					p.scrollTo(1, anchor: .top)
				}
			}
		}
		.toolbar {
			ToolbarItem(placement: .principal) {
				Text("Multiple Choice")
					.bold()
			}
			ToolbarItem {
				Button("Add") {
					vm.addMultipleChoiceExercise()
					dismissAction()
				}
				.disabled(!vm.canAdd)
			}
		}
		.onAppear {
			vm.initialize(exercise: exercise, context: context)
			focus = 0
		}
    }
	
	var answers: some View {
		ForEach(vm.answers, id: \.id) { answer in
			Section {
				LabeledImage(answer.image) {
					HStack {
						Toggle(isOn: getAnswer(answer).isCorrect) {
							TextField("Answer", text: getAnswer(answer).text)
								.focused($focus, equals: getAnswerIndex(of: answer) + 1)
						}
						PhotoPicker(getAnswer(answer).imageData) {
							Image(systemName: "photo")
						}
					}
					TextField("Explanation", text: getAnswer(answer).explanation)
				}
			}
		}
		.optionalModifier(vm.answers.count > 1) { view in
			view.onDelete(perform: vm.delete)
		}
	}
	
}

extension MultipleChoiceEditorView {
	
	func getAnswer(_ answer: MultipleChoiceAnswer) -> Binding<MultipleChoiceAnswer> {
		return $vm.answers[getAnswerIndex(of: answer)]
	}
	
	func getAnswerIndex(of answer: MultipleChoiceAnswer) -> Int {
		let index = vm.answers.firstIndex { ans in
			ans.id == answer.id
		} ?? 0
		return index
	}
	
}
