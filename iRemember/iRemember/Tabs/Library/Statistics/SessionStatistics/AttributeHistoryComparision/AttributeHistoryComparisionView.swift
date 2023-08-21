//
//  AttributeHistoryComparisionView.swift
//  iRemember
//
//  Created by Privat on 10.08.23.
//

import SwiftUI
import Charts

struct AttributeHistoryComparisionView: View {
	
	@Environment(\.modelContext) var context
	@State var vm: AttributeHistoryComparisionViewModel

	init(_ name: String, for session: SessionStatistic, extractValue: @escaping (Statistic) -> Double, display: ((Double) -> String)? = nil) {
		_vm = State(initialValue: AttributeHistoryComparisionViewModel(name, for: session, extractValue: extractValue, display: display))
	}
	
    var body: some View {
		VStack {
			RollingText(value: $vm.header)
			Text("\(vm.name) \(vm.header)")
				.foregroundStyle(.secondary)
			Button("Click") {
				vm.header = "\(Int.random(in: 0...100000))"
			}
			Chart(vm.values, id: \.0) { value in
				LineMark(x: .value("Date", value.0), y: .value("Score", value.1))
			}
			.chartXAxis {
				AxisMarks(values: .automatic(desiredCount: 5))
			}
			HStack {
				Spacer()
				Picker("Time range", selection: $vm.timeRange) {
					ForEach(TimeRange.allCases) { timeRange in
						Text(timeRange.rawValue)
							.tag(timeRange)
					}
				}
			}
		}
		.navigationTitle("Statistics")
		.navigationBarTitleDisplayMode(.large)
		.padding()
		.background(Color(.secondarySystemFill))
		.rounded()
		.padding()
		.frame(width: UIScreen.main.bounds.width, height: 500)
		.onAppear {
			vm.context = context
			vm.update()
		}
    }
}
