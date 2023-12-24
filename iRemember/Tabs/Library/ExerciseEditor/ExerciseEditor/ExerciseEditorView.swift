//
//  ExerciseEditorView.swift
//  iRemember
//
//  Created by Privat on 24.07.23.
//

import SwiftUI
import SwiftData

struct ExerciseEditorView: View {
	
	@Environment(\.dismiss) var dismissAction
	@State var vm: ExerciseEditorViewModel
	@FocusState var focus: Int?
	@State var showMore = false
	
	init(exercise: Exercise = Exercise(), in learnlist: Learnlist) {
		_vm = State(initialValue: ExerciseEditorViewModel(exercise: exercise, in: learnlist))
	}
	
    var body: some View {
		NavigationStack {
			Form {
				Section {
					TextField("Name", text: $vm.exercise.name)
						.focused($focus, equals: 0)
				}
				Section {
					ForEach(ExerciseType.allCases) { type in
						NavigationLink(type.description, value: type)
							.disabled(!vm.canNavigate)
					}
				}
			}
			.toolbar {
				ToolbarItem(placement: .topBarLeading) {
					Button("Cancel") {
						dismissAction()
					}
				}
			}
			.navigationBarTitleDisplayMode(.inline)
			.navigationTitle("Add Exercise")
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
			vm.dismissAction = dismissAction
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
				Button("Add") {
					vm.add()
				}
			}
		}
	}
	
	@ViewBuilder
	func specificEditor(for type: ExerciseType) -> some View {
		switch(type) {
		case .multipleChoice: MultipleChoiceEditorView(vm: vm)
		case .indexCard: IndexCardEditor(vm: vm)
		case .number: Text("Number")
		case .vocabulary: Text("Vocabulary")
		case .location: Text("Location")
		case .list: Text("List")
		case .none: Text("None")
		}
	}
	
}
