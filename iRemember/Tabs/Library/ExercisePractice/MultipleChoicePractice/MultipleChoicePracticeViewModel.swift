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
	var multipleChoice: MultipleChoice
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
			if guesses[i] == multipleChoice.answers[i].isCorrect {
				correctGuesses += 1
			}
		}
		return correctGuesses
	}
	
	var incorrectGuesses: Int {
		guesses.count - correctGuesses
	}
	
	init(for multipleChoice: MultipleChoice, vm: ExercisePracticeViewModel) {
		self.vm = vm
		self.multipleChoice = multipleChoice
		self.guesses = [Bool].init(repeating: false, count: multipleChoice.answers.count)
	}
	
	func guessedCorrectly(_ index: Int) -> Bool {
		guesses[index] == multipleChoice.answers[index].isCorrect
	}
	
	func explanation(for index: Int) -> String? {
		let explanation = multipleChoice.answers[index].explanation
		if explanation == "" {
			return nil
		}
		return explanation
	}
	
	func attachSpecificStatistic(to statistic: Statistic) {
		let multipleChoiceStatistic = MultipleChoiceStatistic()
		multipleChoiceStatistic.multipleChoice = multipleChoice
		
		GlobalManager.shared.context.insert(multipleChoiceStatistic)
		
		statistic.statisticType = .multipleChoice(multipleChoiceStatistic)
		
		for i in guesses.indices {
			multipleChoiceStatistic.map[multipleChoice.answers[i].id] = guesses[i]
		}
	}
	
	func evaluateCorrectness() -> Double {
		Double(correctGuesses) / Double(guesses.count)
	}
	
}
