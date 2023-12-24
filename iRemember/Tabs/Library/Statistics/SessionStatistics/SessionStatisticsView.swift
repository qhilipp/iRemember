//
//  SessionStatisticsView.swift
//  iRemember
//
//  Created by Privat on 08.08.23.
//

import SwiftUI
import Charts
import SwiftData

struct SessionStatisticsView: View {
	
	@State var vm: SessionStatisticsViewModel

	init(for practiceSession: PracticeSession) {
		_vm = State(wrappedValue: SessionStatisticsViewModel(for: practiceSession))
	}
	
    var body: some View {
		ScrollView {
			VStack {
				referenceHistoryComparison
				distribution
				division
				TimeDistributionView(for: vm.practiceSession)
				CorrelationView(for: .practiceSession(vm.practiceSession, vm.historicSessions))
				moreButton
			}
		}
		.navigationBarTitleDisplayMode(.large)
		.navigationTitle("Statistics")
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				Button("Done") {
					GlobalManager.shared.navigationPath.removeLast()
				}
				.bold()
			}
		}
    }
	
	@ViewBuilder
	var exercisesList: some View {
		List(vm.practiceSession.sortedStatistics) { statistic in
			NavigationLink {
				ExerciseStatisticsView(for: statistic)
			} label: {
				VStack(alignment: .leading) {
					Text(statistic.exercise.name)
						.font(.headline)
					Text("\(statistic.score ?? 0)" as String)
						.font(.footnote)
						.foregroundStyle(.secondary)
				}
			}
		}
		.navigationTitle("Exercises")
	}
	
	@ViewBuilder
	var referenceHistoryComparison: some View {
		CardScrollView {
			ReferenceHistoryComparisonView("Score", with: .practiceSession(vm.practiceSession, vm.historicSessions)) { $0.score }
			ReferenceHistoryComparisonView("Correctness", with: .practiceSession(vm.practiceSession, vm.historicSessions)) { $0.correctness }
			ReferenceHistoryComparisonView("Time", with: .practiceSession(vm.practiceSession, vm.historicSessions), greaterIsBetter: false) { $0.timeInformation.totalTime }
		}
	}
	
	@ViewBuilder
	var distribution: some View {
		CardScrollView {
			DistributionView("Score", for: vm.practiceSession) { $0.score }
			DistributionView("Correctness", for: vm.practiceSession) { $0.correctness }
			DistributionView("Time", for: vm.practiceSession, greaterIsBetter: false) { $0.timeInformation.totalTime }
		}
	}
	
	@ViewBuilder
	var division: some View {
		CardScrollView {
			DivisionView("Count", for: vm.practiceSession) { Double($0.count) }
			DivisionView("Score", for: vm.practiceSession) { $0.compactMap { $0.score }.reduce(0, +) }
			DivisionView("Correctness", for: vm.practiceSession) { $0.compactMap { $0.correctness }.reduce(0, +) }
			DivisionView("Time", for: vm.practiceSession) { $0.map { $0.timeInformation.totalTime }.reduce(0, +) }
		}
	}
	
	@ViewBuilder
	var moreButton: some View {
		NavigationLink {
			exercisesList
		} label: {
			Text("Statistics for exercises")
				.padding()
				.foregroundStyle(Color(.label))
				.frame(maxWidth: .infinity)
				.background(Color(.systemGroupedBackground))
				.clipShape(.rect(cornerRadius: 5))
		}
		.padding()
	}
	
}
