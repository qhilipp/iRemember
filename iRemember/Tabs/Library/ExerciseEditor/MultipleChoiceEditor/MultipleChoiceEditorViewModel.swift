//
//  MultipleChoiceEditorViewModel.swift
//  iRemember
//
//  Created by Privat on 24.07.23.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
class MultipleChoiceEditorViewModel: ExerciseEditorDelegate {
	
	var multipleChoice = MultipleChoice()
	var vm: ExerciseEditorViewModel
	var answers: [MultipleChoiceAnswer] = [MultipleChoiceAnswer()]
	
	init(vm: ExerciseEditorViewModel) {
		self.vm = vm
		if let multipleChoice = vm.exercise.multipleChoice {
			self.multipleChoice = multipleChoice
			answers = multipleChoice.answers
		}
		GlobalManager.shared.context.insert(multipleChoice)
	}
	
	func addAnswer() {
		answers.append(MultipleChoiceAnswer())
	}
	
	func removeAnswer(indexSet: IndexSet) {
		answers.remove(atOffsets: indexSet)
	}
	
	func onComplete() {
		multipleChoice.answers = answers
		vm.exercise.type = .multipleChoice(multipleChoice)
	}
	
	func hasMissingInformation() -> Bool {
		if multipleChoice.question == "" {
			return true
		}
		for answer in answers {
			if answer.text == "" && answer.imageData == nil {
				return true
			}
		}
		return false
	}
	
}
