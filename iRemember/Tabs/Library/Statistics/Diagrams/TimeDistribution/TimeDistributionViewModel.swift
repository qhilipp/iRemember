//
//  TimeDistributionViewModel.swift
//  iRemember
//
//  Created by Privat on 28.09.23.
//

import Foundation
import SwiftData

@Observable
class TimeDistributionViewModel {
	
	@ObservationIgnored let practiceSession: PracticeSession
	
	var chartValues: [(Int, Statistic)] {
		practiceSession.sortedStatistics.enumerated().map { ($0.offset, $0.element) }
	}
	
	init(practiceSession: PracticeSession) {
		self.practiceSession = practiceSession
	}
	
}
