//
//  AttributeHistoryComparisionViewModel.swift
//  iRemember
//
//  Created by Privat on 10.08.23.
//

import Foundation
import SwiftData
import Charts

@Observable
class AttributeHistoryComparisionViewModel {
	
	var context: ModelContext!
	
	@ObservationIgnored let name: String
	@ObservationIgnored let session: SessionStatistic
	@ObservationIgnored let extractValue: (Statistic) -> Double
	@ObservationIgnored let display: ((Double) -> String)?
	
	var timeRange: TimeRange = .month
	var values: [(Date, Double)] = []
	
	var header = "-"
	
	init(_ name: String, for session: SessionStatistic, extractValue: @escaping (Statistic) -> Double, display: ((Double) -> String)?) {
		self.name = name
		self.session = session
		self.extractValue = extractValue
		self.display = display
	}
	
	func update() {
		let desciptor = FetchDescriptor<Statistic>(
			predicate: #Predicate { statistic in
				true
			}, sortBy: [SortDescriptor(\.date)]
		)
		values = ((try? context.fetch(desciptor)) ?? [])
//			.filter { session.stats.contains($0) }
			.filter { $0.date >= timeRange.date }
			.map { ($0.date, extractValue($0)) }
		updateHeader()
	}
	
	func updateHeader() {
		var avg = Double.zero
		for stat in session.stats {
			avg += extractValue(stat)
		}
		avg /= Double(session.stats.count)
		if let display {
			header = display(avg)
		} else {
			header = "\(avg.rounded(to: 2))"
		}
	}
	
}

enum TimeRange: String, CaseIterable, Identifiable {
	
	case day = "Day"
	case week = "Week"
	case month = "Month"
	case year = "Year"
	case all = "All"
	
	var id: String { self.rawValue }
	
	var date: Date {
		switch self {
		case .day: return Date.now.startOfDay
		case .week: return Date.now.startOfWeek
		case .month: return Date.now.startOfMonth
		case .year: return Date.now.startOfYear
		case .all: return Date.distantPast
		}
	}
	
}
