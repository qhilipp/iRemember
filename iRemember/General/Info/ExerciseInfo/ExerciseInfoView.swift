//
//  ExerciseInfoView.swift
//  iRemember
//
//  Created by Privat on 05.01.24.
//

import SwiftUI

struct ExerciseInfoView: View {
	
	@State var vm: ExerciseInfoViewModel
	
	init(for exercise: Exercise) {
		self._vm = State(initialValue: ExerciseInfoViewModel(exercise: exercise))
	}
	
	var body: some View {
		Form {
			Section {
				LabeledContent("Id", value: vm.exercise.id.description)
				LabeledContent("Type", value: vm.exercise.type.description)
				LabeledContent("Date", value: vm.exercise.creationDate.description)
				LabeledContent("Score", value: vm.exercise.score.description)
			}
			Section {
				Button("Edit") {
					vm.showEditSheet = true
				}
			}
			#if DEBUG
			PersistentModelInfoView(model: vm.exercise)
			#endif
		}
		.navigationTitle(vm.exercise.name)
		.exerciseEditorSheet(isPresented: $vm.showEditSheet, for: vm.exercise)
	}
}
