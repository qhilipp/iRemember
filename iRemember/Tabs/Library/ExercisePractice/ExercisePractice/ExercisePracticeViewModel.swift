//
//  ExercisePracticeViewModel.swift
//  iRemember
//
//  Created by Privat on 07.08.23.
//

import Foundation
import SwiftData
import Combine
import SwiftUI

@Observable
class ExercisePracticeViewModel: StopWatchDelegate {

	var practiceSession: PracticeSession
	var currentIndex: Int = 0
	@ObservationIgnored var currentStatistic = Statistic()
	var scrollProxy: ScrollViewProxy?
	var isCtaEnabled = true
	var showStatistics = false
	var showTimer = true
	var exerciseStopWatch = StopWatch()
	var sessionStopWatch = StopWatch()
	
	var isRevealed = false
	@ObservationIgnored var delegate: ExercisePracticeDelegate!
	
	var hasNext: Bool {
		currentIndex < practiceSession.exercises.count - 1
	}
	
	var ctaText: String {
		isRevealed ? nextText : "Reveal"
	}
	
	var nextText: String {
		hasNext ? "Next" : "Conclude"
	}
	
	var currentExercise: Exercise {
		practiceSession.exercises[currentIndex]
	}
	
	var formattedSessionTimeLeft: String? {
		guard let timeLeft = sessionStopWatch.timeLeftFormatted else { return nil }
		return "Session: \(timeLeft)"
	}
	
	var formattedExerciseTimeLeft: String? {
		guard let timeLeft = exerciseStopWatch.timeLeftFormatted else { return nil }
		return "Exercise: \(timeLeft)"
	}
	
	var hasAtLeastOneTimer: Bool {
		exerciseStopWatch.hasTimeLimitation || sessionStopWatch.hasTimeLimitation
	}
	
	var hasBothTimeLimitations: Bool {
		exerciseStopWatch.hasTimeLimitation && sessionStopWatch.hasTimeLimitation
	}
	
	init(practiceSession: PracticeSession) {
		self.practiceSession = practiceSession
		if case .learnlist(let learnlist) = practiceSession.type, learnlist.hasTimeLimitation {
			sessionStopWatch.timeLimitation = learnlist.timeLimitation
		}
		if currentExercise.hasTimeLimitation {
			exerciseStopWatch.timeLimitation = currentExercise.timeLimitation
		} else {
			exerciseStopWatch.timeLimitation = nil
		}
		exerciseStopWatch.delegate = self
		sessionStopWatch.delegate = self
	}
	
	func ctaClicked() {
		if isRevealed {
			next()
		} else {
			reveal()
		}
	}
	
	func openStatistics() {
		GlobalManager.shared.context.insert(practiceSession)
		showStatistics = true
	}
	
	func next(registerFinishTimeAndCorrectness: Bool = true) {
		if registerFinishTimeAndCorrectness {
			currentStatistic.timeInformation.registerFinishTime()
			currentStatistic.correctness = delegate.evaluateCorrectness()
		}
		currentStatistic = Statistic()
		if hasNext {
			if hasNext {
				currentIndex += 1
				exerciseStopWatch.reset()
				if currentExercise.hasTimeLimitation {
					exerciseStopWatch.timeLimitation = currentExercise.timeLimitation
				} else {
					exerciseStopWatch.timeLimitation = nil
				}
			}
		} else {
			openStatistics()
		}
		isRevealed = false
	}
	
	func reveal(registerRevealTime: Bool = true) {
		GlobalManager.shared.context.insert(currentStatistic)
		
		if registerRevealTime {
			currentStatistic.timeInformation.registerRevealTime()
		}
		currentStatistic.exercise = currentExercise
		
		delegate.attachSpecificStatistic(to: currentStatistic)
		practiceSession.register(currentStatistic)
		
		scrollProxy?.scrollTo(1, anchor: .top)
		
		isRevealed = true
	}
	
	func continueSession() {
		sessionStopWatch.ignoreTimeRanOut = true
		sessionStopWatch.proceed()
	}
	
	func forceSkipSession() {
		if !isRevealed {
			reveal()
		}
		while hasNext {
			next(registerFinishTimeAndCorrectness: false )
			reveal(registerRevealTime: false)
		}
		next(registerFinishTimeAndCorrectness: false)
	}
	
	func continueExercise() {
		exerciseStopWatch.ignoreTimeRanOut = true
		exerciseStopWatch.proceed()
	}
	
	func forceSkipExercise() {
		reveal()
		next()
	}
	
	// StopWatchDelegate
	func onPause(sender: StopWatch, reason: PauseReason) {
		if sender == exerciseStopWatch {
			sessionStopWatch.pause(for: reason, triggerDelegate: false)
		} else {
			exerciseStopWatch.pause(for: reason, triggerDelegate: false)
		}
	}
	
	func onProceed(sender: StopWatch, reason: PauseReason) {
		if sender == exerciseStopWatch {
			sessionStopWatch.proceed(triggerDelegate: false)
		} else {
			exerciseStopWatch.proceed(triggerDelegate: false)
		}
	}
	
}

protocol ExercisePracticeDelegate {
	
	var vm: ExercisePracticeViewModel { get }
	func attachSpecificStatistic(to statistic: Statistic)
	func evaluateCorrectness() -> Double
	func setup()
	
}

extension ExercisePracticeDelegate {
	func setup() {
		vm.delegate = self
	}
}
