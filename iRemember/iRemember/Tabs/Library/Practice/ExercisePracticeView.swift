//
//  ExercisePracticeView.swift
//  iRemember
//
//  Created by Privat on 14.08.23.
//

import Foundation
import SwiftUI

struct ExercisePracticeView: View {
	
	@State var vm: ExercisePracticeWireframeViewModel
	
	init(for exercise: Exercise) {
		self._vm = State(initialValue: ExercisePracticeWireframeViewModel(exercise: exercise))
	}
	
	var body: some View {
		ExercisePracticeWireframeView(vm: $vm) {
			if vm.showStatistics {
				Text("Moin")
			} else {
				content
					.id(vm.exercise.id)
			}
		}
		.sheet(isPresented: $vm.showStatistics) {
			vm.learnlistManager.path.removeLast()
		} content: {
			if let sessionStatistic = vm.learnlistManager.sessionStatistic {
				SessionStatisticsView(for: sessionStatistic)
			} else {
				Text("Error while loading statistics :(")
			}
			
		}
	}
	
	@ViewBuilder
	var content: some View {
		switch vm.exercise.exerciseType {
		case .multipleChoice(let multipleChoiceExercise): MultipleChoicePracticeView(for: multipleChoiceExercise, wireframeViewModel: vm)
		default: Text("Coming soon :)")
		}
	}
	
}
