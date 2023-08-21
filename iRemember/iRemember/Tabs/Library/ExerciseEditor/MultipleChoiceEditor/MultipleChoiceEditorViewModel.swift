//
//  MultipleChoiceEditorViewModel.swift
//  iRemember
//
//  Created by Privat on 24.07.23.
//

import Foundation
import SwiftData
import SwiftUI
import PhotosUI
import Combine

@Observable
class MultipleChoiceEditorViewModel {
	
	var exercise: Exercise!
	var mcExercise = MultipleChoiceExercise(question: "")
	var context: ModelContext!
	var answers: [MultipleChoiceAnswer] = []
	
	var canAdd: Bool {
		if mcExercise.question == "" || answers.count == 0 {
			return false
		}
		for answer in answers {
			if answer.text == "" {
				return false
			}
		}
		return true
	}
	
	func initialize(exercise: Exercise, context: ModelContext) {
		self.exercise = exercise
		self.context = context
//		context.insert(mcExercise)
		mcExercise.question = exercise.name
		addAnswer()
	}
	
	func addMultipleChoiceExercise() {
//		context.insert(mcExercise)
		for answer in answers {
//			context.insert(answer)
			mcExercise.answers.append(answer)
		}
		exercise.exerciseType = .multipleChoice(mcExercise)
		mcExercise.exercise = exercise
	}
	
	func delete(indexSet: IndexSet) {
		answers.remove(atOffsets: indexSet)
	}
	
	func addAnswer() {
		answers.append(MultipleChoiceAnswer())
	}
	
}
