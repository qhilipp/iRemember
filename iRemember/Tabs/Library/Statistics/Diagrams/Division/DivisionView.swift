//
//  DivisionView.swift
//  iRemember
//
//  Created by Privat on 24.09.23.
//

import SwiftUI
import Charts

struct DivisionView: View {
	
	@State var vm: DivisionViewModel
	
	init(_ title: String, for practiceSession: PracticeSession, generateValue: @escaping ([Statistic]) -> Double) {
		self._vm = State(initialValue: DivisionViewModel(title: title, practiceSession: practiceSession, generateValue: generateValue))
	}
	
    var body: some View {
		StatisticsCard(vm.title) {
			HStack(alignment: .top) {
				Chart(vm.completedChartData) { value in
					SectorMark(
						angle: .value(value.title, value.value),
						innerRadius: .ratio(0.618),
						angularInset: 1
					)
					.cornerRadius(5)
					// TODO: Figure out why this crashes the app
					.foregroundStyle(by: .value("Type", value.title))
				}
				.frame(height: 200)
				.chartForegroundStyleScale(vm.completedChartForegroundStyleScale)
				.chartLegend(position: .trailing)
			}
		}
    }
}
