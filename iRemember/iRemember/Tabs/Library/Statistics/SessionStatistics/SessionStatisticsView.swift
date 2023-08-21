//
//  SessionStatisticsView.swift
//  iRemember
//
//  Created by Privat on 08.08.23.
//

import SwiftUI

struct SessionStatisticsView: View {
	
	@State var vm: SessionStatisticsViewModel
	
	init(for sessionStatistic: SessionStatistic) {
		_vm = State(wrappedValue: SessionStatisticsViewModel(for: sessionStatistic))
	}
	
    var body: some View {
		NavigationStack {
			ScrollView {
				VStack {
					ScrollView(.horizontal) {
						HStack(spacing: 0) {
							AttributeHistoryComparisionView("Score", for: vm.sessionStatistic) { statistic in
								statistic.score
							}
							AttributeHistoryComparisionView("Time", for: vm.sessionStatistic) { statistic in
								statistic.time
							}
							AttributeHistoryComparisionView("Score/Time", for: vm.sessionStatistic) { statistic in
								statistic.score / statistic.time
							}
						}
					}
					.scrollTargetBehavior(.paging)
					.scrollIndicators(.hidden)
				}
			}
			.navigationBarTitleDisplayMode(.large)
			.navigationTitle("Statistics")
		}
    }
}
