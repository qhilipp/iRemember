//
//  CorrelationViewModel.swift
//  iRemember
//
//  Created by Privat on 29.09.23.
//

import Foundation
import SwiftData

@Observable
class CorrelationViewModel {
	
	@ObservationIgnored let source: PracticeSessionSourceType
	
	var xAxisSelection: AxisKeyPath = .time
	var yAxisSelection: AxisKeyPath = .correctness
	
	var historicCorrelationData: [Point] {
		switch source {
		case .practiceSession(_, let sessions):
			sessions.statistics.map {
				Point(x: xAxisSelection.value(from: $0), y: yAxisSelection.value(from: $0))
			}
		case .statistic(_, let statistics):
			statistics.map {
				Point(x: xAxisSelection.value(from: $0), y: yAxisSelection.value(from: $0))
			}
		}
	}
	
	var currentCorrelationData: [Point] {
		switch source {
		case .practiceSession(let practiceSession, _):
			practiceSession.sortedStatistics.map {
				Point(x: xAxisSelection.value(from: $0), y: yAxisSelection.value(from: $0))
			}
		case .statistic(let statistic, _):
			[Point(x: xAxisSelection.value(from: statistic), y: yAxisSelection.value(from: statistic))]
		}
	}
	
	init(source: PracticeSessionSourceType) {
		self.source = source
	}
		
}

enum AxisKeyPath: String, CaseIterable, Identifiable {
	
	case time = "Time"
	case correctness = "Correctness"
	case score = "Score"
	
	var id: Self { self }
	
	var keyPath: (Statistic) -> Double? {
		switch self {
		case .time: { $0.timeInformation.totalTime }
		case .correctness: { $0.correctness }
		case .score: { $0.score }
		}
	}
	
	func value(from statistic: Statistic) -> Double {
		keyPath(statistic) ?? 0
	}
	
}
