//
//  ExerciseEditorView.swift
//  iRemember
//
//  Created by Privat on 24.07.23.
//

import SwiftUI
import SwiftData

struct ExerciseEditorView: View {
	
	@Environment(\.modelContext) var context: ModelContext
	@Environment(\.dismiss) var dismissAction
	@State var vm: ExerciseEditorViewModel
	@FocusState var focus: Int?
	
	init(learnlist: Learnlist) {
		_vm = State(initialValue: ExerciseEditorViewModel(learnlist: learnlist))
	}
	
    var body: some View {
		NavigationStack {
			Form {
				Section {
					TextField("Name", text: $vm.exercise.name)
						.focused($focus, equals: 0)
				}
				Section {
					ForEach(ExerciseType.allCases, id: \.self) { type in
						NavigationLink(type.rawValue, value: type)
							.disabled(!canNavigate)
					}
				}
			}
			.toolbar {
				ToolbarItem(placement: .topBarLeading) {
					Button("Cancel") {
						dismissAction()
					}
				}
				ToolbarItem(placement: .principal) {
					Text("Add Exercise")
						.bold()
				}
			}
			.navigationDestination(for: ExerciseType.self) { type in
				switch(type) {
				case .multipleChoice: MultipleChoiceEditorView(dismissAction: dismissAction, exercise: vm.exercise)
				case .number: Text("Number")
				case .vocabulary: Text("Vocabulary")
				case .location: Text("Location")
				}
			}
		}
		.onAppear {
			focus = 0
		}
    }
	
	var canNavigate: Bool {
		return vm.exercise.name != ""
	}
	
	enum ExerciseType: String, CaseIterable {
		case multipleChoice = "Multiple Choice"
		case number = "Number"
		case vocabulary = "Vocabulary"
		case location = "Location"
	}
}
