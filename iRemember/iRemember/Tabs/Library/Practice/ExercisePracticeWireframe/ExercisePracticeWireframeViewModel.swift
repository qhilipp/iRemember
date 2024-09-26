//
//  ExercisePracticeWireframeViewModel.swift
//  iRemember
//
//  Created by Privat on 07.08.23.
//

import Foundation
import SwiftData

@Observable
class ExercisePracticeWireframeViewModel {
	
	var context: ModelContext!
	var startTime = Date.now
	var statistic: Statistic?
	var showStatistics = false
	var exercise: Exercise
	var learnlistManager: LearnlistManager!
	@ObservationIgnored var revealAction: (Statistic) -> Void = { _ in }
	
	var ctaText: String {
		isRevealed ? (learnlistManager.isEmpty ? "Show statistics" : "Next") : "Reveal"
	}
	
	var isRevealed: Bool {
		statistic != nil
	}
	
	init(exercise: Exercise) {
		self.exercise = exercise
	}
	
	func ctaClicked() {
		if isRevealed {
			if learnlistManager.isEmpty {
				showStatistics = true
			} else {
				if let nextExercise = learnlistManager.next(with: statistic) {
					exercise = nextExercise
				}
				statistic = nil
			}
		} else {
			reveal()
		}
	}
	
	func reveal() {
		let statistic = Statistic(for: exercise, startedOn: startTime)
		context.insert(statistic)
		
		self.statistic = statistic
		revealAction(statistic)
	}
	
}
