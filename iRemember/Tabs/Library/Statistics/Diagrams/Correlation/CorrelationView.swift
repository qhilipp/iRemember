//
//  CorrelationView.swift
//  iRemember
//
//  Created by Privat on 29.09.23.
//

import SwiftUI
import Charts

struct CorrelationView: View {
	
	@State var vm: CorrelationViewModel
	
	init(for source: PracticeSessionSourceType) {
		self._vm = State(initialValue: CorrelationViewModel(source: source))
	}
	
    var body: some View {
		StatisticsCard("Correlation") {
			VStack {
				HStack {
					Picker("X-Axis", selection: $vm.xAxisSelection) {
						ForEach(AxisKeyPath.allCases) {
							Text($0.rawValue)
								.tag($0)
						}
					}
					Picker("Y-Axis", selection: $vm.yAxisSelection) {
						ForEach(AxisKeyPath.allCases) {
							Text($0.rawValue)
								.tag($0)
						}
					}
				}
				Chart {
					ForEach(vm.historicCorrelationData) { point in
						PointMark(
							x: .value(vm.xAxisSelection.rawValue, point.x),
							y: .value(vm.yAxisSelection.rawValue, point.y)
						)
						.foregroundStyle(.gray.opacity(0.3))
					}
					.zIndex(1)
					ForEach(vm.currentCorrelationData) { point in
						PointMark(
							x: .value(vm.xAxisSelection.rawValue, point.x),
							y: .value(vm.yAxisSelection.rawValue, point.y)
						)
					}
					.zIndex(2)
				}
				.aspectRatio(1, contentMode: .fit)
			}
		}

    }
}
