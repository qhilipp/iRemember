//
//  MultipleChoicePracticeViewModel.swift
//  iRemember
//
//  Created by Privat on 14.08.23.
//

import Foundation
import SwiftUI
import SwiftData

@Observable
class MultipleChoicePracticeViewModel: ExercisePracticeDelegate {
	
	var vm: ExercisePracticeViewModel
	var multipleChoiceExercise: MultipleChoice
	var guesses: [Bool] {
		willSet {
			guard newValue != guesses else { return }
			guard newValue.count == guesses.count, !newValue.isEmpty else { return }
			var index = 0
			for i in guesses.indices {
				if newValue[i] != guesses[i] {
					index = i
					break
				}
			}
			vm.currentStatistic.timeInformation.registerActionTime(for: index)
		}
	}
	
	var correctGuesses: Int {
		var correctGuesses = 0
		for i in 0..<guesses.count {
			if guesses[i] == multipleChoiceExercise.answers[i].isCorrect {
				correctGuesses += 1
			}
		}
		return correctGuesses
	}
	
	var incorrectGuesses: Int {
		guesses.count - correctGuesses
	}
	
	init(for multipleChoiceExercise: MultipleChoice, vm: ExercisePracticeViewModel) {
		self._vm = vm
		self._multipleChoiceExercise = multipleChoiceExercise
		self._guesses = [Bool].init(repeating: false, count: multipleChoiceExercise.answers.count)
		self.vm.delegate = self
	}
	
	func guessedCorrectly(_ index: Int) -> Bool {
		guesses[index] == multipleChoiceExercise.answers[index].isCorrect
	}
	
	func explanation(for index: Int) -> String? {
		let explanation = multipleChoiceExercise.answers[index].explanation
		if explanation == "" {
			return nil
		}
		return explanation
	}
	
	func attachSpecificStatistic(to statistic: Statistic) {
		let multipleChoiceStatistic = MultipleChoiceStatistic()
		multipleChoiceStatistic.multipleChoiceExercise = multipleChoiceExercise
		
		GlobalManager.shared.context.insert(multipleChoiceStatistic)
		
		statistic.statisticType = .multipleChoice(multipleChoiceStatistic)
		
		for i in guesses.indices {
			multipleChoiceStatistic.map[multipleChoiceExercise.answers[i].id] = guesses[i]
		}
	}
	
	func evaluateCorrectness() -> Double {
		Double(correctGuesses) / Double(guesses.count)
	}
	
}
