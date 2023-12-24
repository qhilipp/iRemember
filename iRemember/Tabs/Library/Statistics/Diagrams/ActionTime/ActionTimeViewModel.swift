//
//  ActionTimeViewModel.swift
//  iRemember
//
//  Created by Privat on 01.10.23.
//

import Foundation
import SwiftData

@Observable
class ActionTimeViewModel {
	
	@ObservationIgnored let statistic: Statistic
	
	var chartData: [(Int, [Double])] {
		print(statistic.timeInformation.actionTimes)
		return statistic.timeInformation.actionTimes.values.enumerated().map { ($0.offset, $0.element) }
	}
	
	init(statistic: Statistic) {
		self.statistic = statistic
	}
	
}
