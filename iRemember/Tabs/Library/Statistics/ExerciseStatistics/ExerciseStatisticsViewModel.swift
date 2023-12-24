//
//  ExerciseStatisticsViewModel.swift
//  iRemember
//
//  Created by Privat on 30.09.23.
//

import Foundation
import SwiftData

@Observable
class ExerciseStatisticsViewModel {
	
	@ObservationIgnored let statistic: Statistic
	@ObservationIgnored let historicalStatistics: [Statistic]
	
	init(statistic: Statistic) {
		self.statistic = statistic
		
		let descriptor = FetchDescriptor<Statistic>()
		historicalStatistics = ((try? GlobalManager.shared.context.fetch(descriptor)) ?? []).filter { $0.exercise == statistic.exercise }
	}
	
}
