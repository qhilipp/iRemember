//
//  StopWatch.swift
//  iRemember
//
//  Created by Privat on 11.09.23.
//

import Foundation
import Combine
import SwiftData

@Observable
class StopWatch: Identifiable {
	
	static let clockRate: TimeInterval = 0.1
	
	var id: UUID
	var startDate: Date = .now
	var timeSpent: TimeInterval = 0
	var timeLimitation: TimeInterval?
	var ignoreTimeRanOut = false
	
	var timeLeft: TimeInterval? {
		guard let timeLimitation else { return nil }
		return timeLimitation - timeSpent
	}
	
	var timeLeftFormatted: String? {
		guard let timeLeft else { return nil }
		
		let formatter = DateComponentsFormatter()
		formatter.includesTimeRemainingPhrase = true
		formatter.allowedUnits = [.minute, .second, .nanosecond]
		formatter.zeroFormattingBehavior = .dropLeading
		
		return formatter.string(from: timeLeft)
	}
	
	var timeRanOut: Bool {
		guard let timeLeft else { return false }
		return timeLeft <= Self.clockRate
	}
	
	var shouldShowTimeRanOutAlert: Bool {
		get {
			timeRanOut == true && !ignoreTimeRanOut
		}
		set { }
	}
	
	var isTimeMeager: Bool {
		guard let timeLeft else { return false }
		return timeLeft < 60
	}
	
	var totalTimeSpent: TimeInterval {
		Date.now.timeIntervalSince(startDate)
	}
	
	var hasTimeLimitation: Bool {
		timeLimitation != nil
	}
	
	var timeSinceLastMeasure: TimeInterval {
		defer {
			lastMeasure = .now
		}
		return Date.now.timeIntervalSince(lastMeasure)
	}
	
	@ObservationIgnored private var timer: Publishers.Autoconnect<Timer.TimerPublisher>
	@ObservationIgnored private var cancellables: [AnyCancellable] = []
	@ObservationIgnored private var isRunning = true
	@ObservationIgnored private var lastMeasure: Date = .now
	@ObservationIgnored var delegate: StopWatchDelegate?
	@ObservationIgnored private var lastPauseReason: PauseReason?
	
	init(timeLimitation: TimeInterval? = nil, delegate: StopWatchDelegate? = nil) {
		self.id = UUID()
		self.timeLimitation = timeLimitation
		self.delegate = delegate
		timer = Timer.publish(every: StopWatch.clockRate, on: .main, in: .common).autoconnect()
		timer.sink { [weak self] _ in
			self?.update()
		}.store(in: &cancellables)
	}
	
	func update() {
		if shouldShowTimeRanOutAlert {
			pause(for: .alert)
		}
		if self.isRunning {
			self.timeSpent += StopWatch.clockRate
		}
	}
	
	func pause(for reason: PauseReason, triggerDelegate: Bool = true) {
		isRunning = false
		lastPauseReason = reason
		if triggerDelegate {
			delegate?.onPause(sender: self, reason: lastPauseReason!)
		}
	}
	
	func proceed(triggerDelegate: Bool = true) {
		isRunning = true
		guard let lastPauseReason else { return }
		if triggerDelegate {
			delegate?.onProceed(sender: self, reason: lastPauseReason)
		}
	}
	
	func reset() {
		timeSpent = 0
		lastMeasure = .now
		startDate = .now
	}
	
}

extension StopWatch: Equatable {
	
	static func == (lhs: StopWatch, rhs: StopWatch) -> Bool {
		lhs.id == rhs.id
	}
	
}

enum PauseReason {
	case appQuit
	case pause
	case alert
	case menu
}

protocol StopWatchDelegate {
	
	func onPause(sender: StopWatch, reason: PauseReason)
	func onProceed(sender: StopWatch, reason: PauseReason)
	
}
