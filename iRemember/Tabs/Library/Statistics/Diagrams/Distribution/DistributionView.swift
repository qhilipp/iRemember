//
//  DistributionView.swift
//  iRemember
//
//  Created by Privat on 04.09.23.
//

import SwiftUI
import Charts

struct DistributionView: View {
	
	@State var vm: DistributionViewModel
	
	init(_ name: String, for practiceSession: PracticeSession, greaterIsBetter: Bool = true, _ keyPath: @escaping (Statistic) -> Double?) {
		self._vm = State(initialValue: DistributionViewModel(name, practiceSession: practiceSession, keyPath: keyPath, greaterIsBetter: greaterIsBetter))
	}
	
    var body: some View {
		StatisticsCard(vm.name) {
			Spacer()
			Picker("Reference type", selection: $vm.referenceType) {
				ForEach(ReferenceType.selectableCases) { attributeType in
					Text(attributeType.rawValue)
						.tag(attributeType)
				}
			}
		} content: {
			Chart(vm.chartData) { value in
				BarMark(x: .value("Index", value.index), y: .value("Value", value.value))
					.foregroundStyle(value.color)
					.zIndex(1)
				if let referenceValue = value.referenceValue {
					LineMark(x: .value("Index", value.index), y: .value("Reference", referenceValue))
						.zIndex(2)
						.interpolationMethod(.catmullRom)
						.foregroundStyle(.gray)
				}
				if let referenceValue = vm.referenceValue {
					RuleMark(y: .value("Reference", referenceValue))
						.zIndex(2)
						.foregroundStyle(.gray)
						.opacity(0.5)
				}
			}
			.frame(height: 200)
		}
    }
}
