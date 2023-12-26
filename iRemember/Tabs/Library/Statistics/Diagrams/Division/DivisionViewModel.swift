//
//  DivisionViewModel.swift
//  iRemember
//
//  Created by Privat on 24.09.23.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
class DivisionViewModel {
	
	@ObservationIgnored let title: String
	@ObservationIgnored let practiceSession: PracticeSession
	@ObservationIgnored let generateValue: ([Statistic]) -> Double
	
	var completedChartData: [DivisionPart] {
		Rating.allCases.map { rating in
			DivisionPart(
				title: rating.rawValue,
				value: generateValue(practiceSession.sortedStatistics.filter { $0.correctness.rating == rating })
			)
		}
	}
	
	var completedChartForegroundStyleScale: KeyValuePairs<String, Color> {
		[
			Rating.correct.rawValue: Rating.correct.color,
			Rating.ok.rawValue: Rating.ok.color,
			Rating.good.rawValue: Rating.good.color,
			Rating.correct.rawValue: Rating.correct.color
		]
	}
	
	init(title: String, practiceSession: PracticeSession, generateValue: @escaping ([Statistic]) -> Double) {
		self.title = title
		self.practiceSession = practiceSession
		self.generateValue = generateValue
	}
	
}

struct DivisionPart: Identifiable {
	var id: String { title }
	
	let title: String
	let value: Double
}
