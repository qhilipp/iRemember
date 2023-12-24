//
//  TimeDistributionView.swift
//  iRemember
//
//  Created by Privat on 28.09.23.
//

import Foundation
import SwiftUI
import Charts

struct TimeDistributionView: View {
	
	@State var vm: TimeDistributionViewModel
	
	init(for practiceSession: PracticeSession) {
		self._vm = State(initialValue: TimeDistributionViewModel(practiceSession: practiceSession))
	}
	
	var body: some View {
		StatisticsCard("Time distribution") {
			Chart(vm.chartValues, id: \.0) { index, statistic in
				BarMark(x: .value("Index", index), y: .value("Reading", statistic.timeInformation.firstActionTime))
					.foregroundStyle(by: .value("Type", "Reading"))
				BarMark(x: .value("Index", index), y: .value("Actions", statistic.timeInformation.actionTime))
					.foregroundStyle(by: .value("Type", "Actions"))
				BarMark(x: .value("Index", index), y: .value("Reveal", statistic.timeInformation.revealTime))
					.foregroundStyle(by: .value("Type", "Reveal"))
				BarMark(x: .value("Index", index), y: .value("Finish", statistic.timeInformation.finishTime))
					.foregroundStyle(by: .value("Type", "Finish"))
				BarMark(x: .value("Index", index), y: .value("Alert", statistic.timeInformation.alertTime))
					.foregroundStyle(by: .value("Type", "Alert"))
				BarMark(x: .value("Index", index), y: .value("Menu", statistic.timeInformation.menuTime))
					.foregroundStyle(by: .value("Type", "Menu"))
			}
			.frame(height: 200)
			.chartLegend(.visible)
		}
	}
	
}
