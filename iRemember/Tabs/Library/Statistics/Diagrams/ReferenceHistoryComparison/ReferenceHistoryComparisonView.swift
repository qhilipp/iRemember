//
//  ReferenceHistoryComparisonView.swift
//  iRemember
//
//  Created by Privat on 10.08.23.
//

import SwiftUI
import Charts

struct ReferenceHistoryComparisonView: View {
	
	@State var vm: ReferenceHistoryComparisonViewModel
	
	init(
		_ title: String,
		with source: PracticeSessionSourceType,
		greaterIsBetter: Bool = true,
		keyPath: @escaping (Statistic) -> Double?,
		display: @escaping (Double) -> String = { "\($0.rounded(to: 1))" }
	) {
		_vm = State(
			initialValue: ReferenceHistoryComparisonViewModel(
				title: title,
				source: source,
				keyPath: keyPath,
				display: display,
				greaterIsBetter: greaterIsBetter
			)
		)
	}
	
	var body: some View {
		StatisticsCard(vm.formattedValue) {
			header
		} content: {
			VStack {
				chart()
					.id("Chart")
				NavigationLink("Details") {
					details
				}
			}
		}
	}
	
	@ViewBuilder
	var header: some View {
		Text("(\(vm.referenceType.rawValue)) \(vm.title)")
			.font(.footnote)
			.foregroundStyle(.secondary)
		Spacer()
		Picker("Reference type", selection: $vm.referenceType) {
			ForEach(ReferenceType.selectableCases) { attributeType in
				Text(attributeType.rawValue)
					.tag(attributeType)
			}
		}
		Picker("Time range", selection: $vm.timeRange) {
			ForEach(TimeRange.allCases) { timeRange in
				Text(timeRange.rawValue)
					.tag(timeRange)
			}
		}
	}
	
	@ViewBuilder
	func chart(height: CGFloat = 200) -> some View {
		Group {
			Chart(vm.chartData) { data in
				LineMark(x: .value("Index", data.index), y: .value("Value", data.value))
					.interpolationMethod(.catmullRom)
				ForEach(data.values, id: \.self) { value in
					PointMark(x: .value("Session", data.index), y: .value(vm.title, value))
						.foregroundStyle(.gray.opacity(0.3))
				}
			}
			.foregroundStyle(
				LinearGradient(colors: Styles.ratingColors(using: vm.greaterIsBetter), startPoint: .bottom, endPoint: .top)
			)
			.chartXAxis {
				AxisMarks(values: .automatic(desiredCount: 5))
			}
			.chartXScale(domain: 0...vm.chartData.count)
			.frame(height: height)
		}
	}
	
	@ViewBuilder
	var details: some View {
		ScrollView {
			VStack {
				HStack {
					header
				}
				chart(height: 350)
				Divider()
					.padding(.vertical)
				Grid {
					GridRow {
						Text("Reference")
						Spacer()
						Text("Value")
						Spacer()
						Text("Improvement")
					}
					.bold()
					ForEach(vm.tableData) { data in
						GridRow {
							Text(data.referenceType.rawValue)
							Spacer()
							Text(data.formattedValue)
							Spacer()
							Text(data.attributedImprovement)
						}
					}
				}
				.onTapGesture {
					vm.showRelativeImprovements.toggle()
				}
				Divider()
					.padding(.vertical)
				Text("The improvement is relative to the \(vm.referenceType.rawValue) of your entire history")
					.font(.footnote)
					.foregroundStyle(.secondary)
					.multilineTextAlignment(.leading)
			}
			.padding()
		}
		.navigationTitle("History comparison details")
	}
		
}
