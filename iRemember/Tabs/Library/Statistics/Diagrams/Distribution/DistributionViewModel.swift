//
//  DistributionViewModel.swift
//  iRemember
//
//  Created by Privat on 04.09.23.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
class DistributionViewModel {
		
	@ObservationIgnored let name: String
	@ObservationIgnored let practiceSession: PracticeSession
	@ObservationIgnored let keyPath: (Statistic) -> Double?
	@ObservationIgnored let greaterIsBetter: Bool
	
	var referenceType: ReferenceType = .avg
	var minChartValue = 0.0
	var maxChartValue = 0.0
	
	var chartData: [ChartData] {
		var max = -Double.infinity, min = Double.infinity
		let pairs: [(Int, Statistic)] = practiceSession.sortedStatistics.enumerated().compactMap {
			guard let value = keyPath($0.element) else { return nil }
			if value > max {
				max = value
			}
			if value < min {
				min = value
			}
			return ($0.offset, $0.element)
		}
		minChartValue = min
		maxChartValue = max
		return pairs.compactMap {
			guard let value = keyPath($0.1) else { return nil }
			return ChartData(
				index: $0.0,
				value: value,
				referenceValue: referenceValue(for: $0.1),
				color: getColor(for: $0.1, min...max)
			)
		}
	}
	
	var referenceValue: Double? {
		referenceType.referenceValue(of: practiceSession.sortedStatistics.compactMap { keyPath($0) })
	}
	
	init(_ name: String, practiceSession: PracticeSession, keyPath: @escaping (Statistic) -> Double?, greaterIsBetter: Bool) {
		self.name = name
		self.practiceSession = practiceSession
		self.keyPath = keyPath
		self.greaterIsBetter = greaterIsBetter
	}
	
	@ObservationIgnored private var lastReference: ReferenceType? = nil
	func referenceValue(for statistic: Statistic) -> Double? {
		referenceType.referenceValue(of: fetchStatistics(for: statistic).compactMap { keyPath($0) })
	}
	
	@ObservationIgnored private var statisticsCache: [Statistic: [Statistic]] = [:]
	private func fetchStatistics(for statistic: Statistic) -> [Statistic] {
		if let statistics = statisticsCache[statistic] {
			return statistics
		}
		let statistics: [Statistic]
		if let stats = statisticsCache[statistic] {
			statistics = stats
		} else {
			let descriptor = FetchDescriptor<Statistic>()
			statistics = ((try? GlobalManager.shared.context.fetch(descriptor)) ?? []).filter { $0.exercise == statistic.exercise }
			statisticsCache[statistic] = statistics
		}
		return statistics
	}
	
	private func getColor(for statistic: Statistic, _ range: ClosedRange<Double>) -> Color {
		guard let value = keyPath(statistic) else {
			return Styles.ratingColors(using: greaterIsBetter).interpolatedValue(at: keyPath(statistic)!.map(from: range, to: 0...1)) ?? .primary
		}
		return .accentColor
	}
	
}

struct ChartData: Identifiable {
	
	var index: Int
	var value: Double
	var referenceValue: Double?
	var color: Color
	
	var id: Int { index }
	
}
