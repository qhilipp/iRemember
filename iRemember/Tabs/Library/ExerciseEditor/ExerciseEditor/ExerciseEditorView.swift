//
//  ExerciseEditorView.swift
//  iRemember
//
//  Created by Privat on 24.07.23.
//

import SwiftUI
import SwiftData

struct ExerciseEditorView: View {
	
	@Environment(\.dismiss) var dismiss
	@State var vm: ExerciseEditorViewModel
	@FocusState var focus: Int?

	init(exercise: Exercise) {
		_vm = State(initialValue: ExerciseEditorViewModel(exercise: exercise, learnlist: nil))
	}
	
	init(in learnlist: Learnlist) {
		_vm = State(initialValue: ExerciseEditorViewModel(exercise: nil, learnlist: learnlist))
	}
	
    var body: some View {
		NavigationStack(path: $vm.navigationPath) {
			Form {
				Section {
					TextField("Name", text: $vm.exercise.name)
						.focused($focus, equals: 0)
				}
				Section {
					ForEach(ExerciseType.parameterAllCases(using: vm.exercise)) { type in
						NavigationLink(type.description, value: type)
							.disabled(!vm.canNavigate(to: type))
					}
				} footer: {
					if !vm.isInCreationMode {
						Text("The type of an exercise cannot be changed")
					}
				}
			}
			.toolbar {
				ToolbarItem(placement: .topBarLeading) {
					Button("Cancel") {
						dismiss()
					}
				}
			}
			.navigationBarTitleDisplayMode(.inline)
			.navigationTitle(vm.isInCreationMode ? "Add exercise" : "Edit exercise")
			.navigationDestination(for: ExerciseType.self) { type in
				ScrollViewReader { proxy in
					specificEditor(for: type)
						.onAppear {
							vm.scrollProxy = proxy
						}
				}
				.navigationTitle(type.description)
				.toolbar {
					ToolbarItem(placement: .topBarTrailing) {
						NavigationLink("Continue") {
							settings
						}
					}
				}
				.alert("Missing information", isPresented: $vm.showMissingInformationError) {} message: {
					if let errorMessage = vm.missingInformationErrorMessage {
						Text(errorMessage)
					}
				}
			}
		}
		.onAppear {
			focus = 0
			vm.setup()
		}
    }
	
	@ViewBuilder
	var settings: some View {
		Form {
			Section {
				Toggle("Time limitation", isOn: $vm.exercise.hasTimeLimitation)
				if vm.exercise.hasTimeLimitation {
					TimeSelector(time: $vm.exercise.timeLimitation)
				}
			}
		}
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				Button(vm.isInCreationMode ? "Add" : "Done") {
					vm.complete()
					dismiss()
				}
			}
		}
	}
	
	@ViewBuilder
	func specificEditor(for type: ExerciseType) -> some View {
		switch(type) {
		case .multipleChoice: MultipleChoiceEditorView(vm: vm)
		case .indexCard: IndexCardEditorView(vm: vm)
		case .number: Text("Number")
		case .vocabulary: Text("Vocabulary")
		case .location: Text("Location")
		case .list: Text("List")
		case .none: Text("None")
		}
	}
	
}
