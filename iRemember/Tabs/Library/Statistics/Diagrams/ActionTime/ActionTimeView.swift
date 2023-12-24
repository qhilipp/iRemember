//
//  ActionTimeView.swift
//  iRemember
//
//  Created by Privat on 01.10.23.
//

import Foundation
import SwiftUI
import Charts

struct ActionTimeView: View {
	
	@State var vm: ActionTimeViewModel
	
	init(for statistic: Statistic) {
		self._vm = State(initialValue: ActionTimeViewModel(statistic: statistic))
	}
	
	var body: some View {
		StatisticsCard("Action times") {
			Chart(vm.chartData, id: \.0) { index, actionTimes in
				ForEach(actionTimes, id: \.self) { time in
					BarMark(x: .value("Index", index), y: .value("Time", time))
				}
			}
		}
	}
	
}
