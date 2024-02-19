//
//  ExerciseStatisticsView.swift
//  iRemember
//
//  Created by Privat on 30.09.23.
//

import SwiftUI

struct ExerciseStatisticsView: View {
	
	@State var vm: ExerciseStatisticsViewModel
	
	init(for statistic: Statistic) {
		self._vm = State(initialValue: ExerciseStatisticsViewModel(statistic: statistic))
	}
	
    var body: some View {
		ScrollView {
			VStack {
				CardScrollView {
					ReferenceHistoryComparisonView("Score", with: .statistic(vm.statistic, vm.historicalStatistics)) { $0.score }
					ReferenceHistoryComparisonView("Correctness", with: .statistic(vm.statistic, vm.historicalStatistics)) { $0.correctness }
//					ReferenceHistoryComparisonView("Time", with: .statistic(vm.statistic, vm.historicalStatistics), greaterIsBetter: false) { $0.timeInformation.totalTime }
				}
				CorrelationView(for: .statistic(vm.statistic, vm.historicalStatistics))
				ActionTimeView(for: vm.statistic)
			}
		}
    }
}
