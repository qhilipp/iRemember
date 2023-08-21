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
class MultipleChoicePracticeViewModel {
	
	var wireframeViewModel: ExercisePracticeWireframeViewModel
	var multipleChoiceExercise: MultipleChoiceExercise
	var guesses: [Bool]
	var feedback: Feedback?
	
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
		return guesses.count - correctGuesses
	}
	
	init(for multipleChoiceExercise: MultipleChoiceExercise, wireframeViewModel: ExercisePracticeWireframeViewModel) {
		self._wireframeViewModel = wireframeViewModel
		self._multipleChoiceExercise = multipleChoiceExercise
		self._guesses = [Bool].init(repeating: false, count: multipleChoiceExercise.answers.count)
		self.wireframeViewModel.exercise.exerciseType = .multipleChoice(multipleChoiceExercise)
		self.wireframeViewModel.revealAction = generateStatistic(with:)
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
	
	func generateStatistic(with statistic: Statistic) {
		let multipleChoiceStatistic = MultipleChoiceStatistic()
		wireframeViewModel.context.insert(multipleChoiceStatistic)
		
		statistic.statisticType = .multipleChoice(multipleChoiceStatistic)
		
		for i in guesses.indices {
			multipleChoiceStatistic.map[multipleChoiceExercise.answers[i].id] = guesses[i]
		}
		
		if correctGuesses == guesses.count {
			feedback = .allCorrect
		} else if correctGuesses == 0 {
			feedback = .allWrong
		} else {
			feedback = .partial
		}
	}
	
}
