//
//  ReferenceHistoryComparisonViewModel.swift
//  iRemember
//
//  Created by Privat on 10.08.23.
//

import Foundation
import SwiftData
import Charts
import SwiftUI

@Observable
class ReferenceHistoryComparisonViewModel {
	
	@ObservationIgnored let title: String
	@ObservationIgnored let source: PracticeSessionSourceType
	@ObservationIgnored let keyPath: (Statistic) -> Double?
	@ObservationIgnored let display: ((Double) -> String)
	@ObservationIgnored let greaterIsBetter: Bool
	@ObservationIgnored let historicValues: [Double]
	
	var timeRange: TimeRange = .month
	var referenceType: ReferenceType = .avg
	var showMore = false
	var showRelativeImprovements = true
	
	var formattedValue: String {
		guard let value = value(for: referenceType) else { return "-" }
		return display(value)
	}
	
	var tableData: [TableData] {
		ReferenceType.allCases.map {
			TableData(
				referenceType: $0,
				value: value(for: $0),
				reference: reference(for: $0),
				greaterIsBetter: greaterIsBetter,
				showRelativeImprovements: showRelativeImprovements
			)
		}
	}
	
	private var lastReferenceType: ReferenceType? = nil
	private var chartDataCache: [ChartData] = []
	var chartData: [ChartData] {
		if referenceType != lastReferenceType {
			lastReferenceType = referenceType
			switch source {
			case .practiceSession(_, let sessions):
				chartDataCache = sessions.enumerated().compactMap {
					let values = $0.element.sortedStatistics.compactMap { keyPath($0) }
					guard let value = referenceType.referenceValue(of: values) else { return nil }
					return ChartData(
						index: $0.offset,
						value: value,
						values: values
					)
				}
			case .statistic(_, let statistics):
				chartDataCache = statistics.enumerated().compactMap {
					guard let value = keyPath($0.element) else { return nil }
					return ChartData(
						index: $0.offset,
						value: value,
						values: []
					)
				}
			}
		}
		return chartDataCache
	}
	
	init(
		title: String,
		source: PracticeSessionSourceType,
		keyPath: @escaping (Statistic) -> Double?,
		display: @escaping (Double) -> String,
		greaterIsBetter: Bool
	) {
		self.title = title
		self.source = source
		self.keyPath = keyPath
		self.display = display
		self.greaterIsBetter = greaterIsBetter
		
		switch source {
		case .practiceSession(_, let sessions):
			self.historicValues = sessions.statistics.compactMap { keyPath($0) }
		case .statistic(_, let statistics):
			self.historicValues = statistics.compactMap { keyPath($0) }
		}
	}
	
	func reference(for referenceType: ReferenceType) -> Double? {
		referenceType.referenceValue(of: historicValues)
	}
	
	func value(for referenceType: ReferenceType) -> Double? {
		switch source {
		case .practiceSession(let practiceSession, _):
			referenceType.referenceValue(of: practiceSession.sortedStatistics.compactMap { keyPath($0) })
		case .statistic(let statistic, _):
			keyPath(statistic)
		}
	}
	
}

enum PracticeSessionSourceType {
	case practiceSession(PracticeSession, [PracticeSession])
	case statistic(Statistic, [Statistic])
}

enum TimeRange: String, CaseIterable, Identifiable {
	
	case day = "Day"
	case week = "Week"
	case month = "Month"
	case year = "Year"
	case all = "All"
	
	var id: Self { self }
	
	var date: Date {
		switch self {
		case .day: Date.now.startOfDay
		case .week: Date.now.startOfWeek
		case .month: Date.now.startOfMonth
		case .year: Date.now.startOfYear
		case .all: Date.distantPast
		}
	}
	
}

enum ReferenceType: String, CaseIterable, Identifiable {
	
	case min = "Min"
	case avg = "Avg"
	case max = "Max"
	case first = "First"
	case median = "Median"
	case last = "Last"
	
	var id: Self { self }
	static let selectableCases: [ReferenceType] = [.min, .avg, .median, .max]
	
	func referenceValue(of values: [Double]) -> Double? {
		switch self {
		case .min: values.min()
		case .avg: values.avg()
		case .max: values.max()
		case .first: values.first
		case .median: values.median
		case .last: values.dropLast().last
		}
	}
	
}

extension ReferenceHistoryComparisonViewModel {
	
	struct ChartData: Identifiable {
		
		var id: Int { index }
		let index: Int
		let value: Double
		let values: [Double]
		
	}
	
	struct TableData: Identifiable {
		
		let referenceType: ReferenceType
		let value: Double?
		let reference: Double?
		let greaterIsBetter: Bool
		let showRelativeImprovements: Bool
		
		var id: ReferenceType { referenceType }
		
		var attributedImprovement: AttributedString {
			var str = AttributedString(stringLiteral: formattedImprovement)
			str.foregroundColor = improvementType.color(using: greaterIsBetter)
			return str
		}
		
		var formattedValue: String {
			guard let value else { return "-" }
			return "\(value.rounded(to: 1))"
		}
		
		var formattedImprovement: String {
			guard let improvement else { return "-" }
			if improvement == 0 {
				return "Equal"
			}
			return "\(improvement > 0 ? "▲" : "▼")\(abs(improvement.rounded(to: 1)))\(showRelativeImprovements ? "%" : "")"
		}
		  
		var improvementType: ImprovementType {
			guard let improvement else { return .unknown }
			if improvement > 0 {
				return .positive
			} else if improvement < 0 {
				return .negative
			} else {
				return .neutral
			}
		}
		
		var improvement: Double? {
			if showRelativeImprovements {
				guard let reference, let value else { return nil }
				if value == reference {
					return 0
				}
				guard reference != 0 else { return nil }
				return ((value / reference) - 1) * 100
			} else {
				guard let reference, let value else { return nil }
				return value - reference
			}
		}
		
	}
	
	enum ImprovementType {
		case positive
		case neutral
		case negative
		case unknown
		
		func color(using greaterIsBetter: Bool) -> Color {
			switch self {
			case .positive: greaterIsBetter ? .green : .red
			case .neutral: .secondary
			case .negative: greaterIsBetter ? .red : .green
			case .unknown: .secondary
			}
		}
	}
	
}
