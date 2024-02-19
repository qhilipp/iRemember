//
//  StatisticInfoView.swift
//  iRemember
//
//  Created by Privat on 06.02.24.
//

import SwiftUI

struct StatisticInfoView: View {
	
	let statistic: Statistic
	
    var body: some View {
		Form {
			Section {
				LabeledContent("Id", value: statistic.id.description)
				LabeledContent("Correctness", value: statistic.correctness.description)
				LabeledContent("Score", value: statistic.score?.description ?? "-")
				LabeledContent("Time out", value: statistic.timeOut.description)
			}
			Section("Time information") {
				LabeledContent("Date", value: statistic.timeInformation.date.description)
				LabeledContent("Total time", value: statistic.timeInformation.totalTime.description)
				LabeledContent("Action time", value: statistic.timeInformation.actionTime.description)
				LabeledContent("First action", value: statistic.timeInformation.firstActionTime.description)
				LabeledContent("Reveal", value: statistic.timeInformation.revealTime.description)
				LabeledContent("Finish", value: statistic.timeInformation.finishTime.description)
				LabeledContent("Alert", value: statistic.timeInformation.alertTime.description)
				LabeledContent("Menu", value: statistic.timeInformation.menuTime.description)
				LabeledContent("First action index", value: statistic.timeInformation.firstActionIndex?.description ?? "-")
			}
			Section("Exercise") {
				NavigationLink(value: statistic.exercise) {
					ListItemView(for: statistic.exercise)
				}
			}
			NavigationLink("Visual") {
				ExerciseStatisticsView(for: statistic)
			}
			#if DEBUG
			PersistentModelInfoView(model: statistic)
			#endif
		}
		.navigationTitle("\(statistic.exercise.name) statistic")
    }
}
