//
//  LearnlistStatisticsView.swift
//  iRemember
//
//  Created by Privat on 27.09.23.
//

import SwiftUI

struct LearnlistStatisticsView: View {
	
	@State var vm: LearnlistStatisticsViewModel
	
	init(for learnlist: Learnlist) {
		self._vm = State(initialValue: LearnlistStatisticsViewModel(learnlist: learnlist))
	}
	
    var body: some View {
		NavigationStack {
			List {
				ForEach(vm.filteredSessions) { session in
					NavigationLink(value: session) {
						ListItemView(for: session)
					}
				}
				.onDelete(perform: vm.delete(offsets:))
			}
			.toolbar {
				#if os(iOS)
				ToolbarItem(placement: .topBarTrailing) {
					menu
				}
				#else
				ToolbarItem {
					menu
				}
				#endif
			}
			.navigationDestination(for: PracticeSession.self) { practiceSession in
				SessionStatisticsView(for: practiceSession)
			}
			.searchable(text: $vm.searchTerm)
			.navigationTitle("Statistics")
		}
    }
	
	var menu: some View {
		Menu {
			Button {
				vm.deleteAll()
			} label: {
				Label("Delete all", systemImage: "trash")
			}
			Button {
				vm.deleteFiltered()
			} label: {
				Label("Delete filtered", systemImage: "line.3.horizontal.decrease.circle")
			}
			Button {
				vm.toggleShowAll()
			} label: {
				Label(vm.showAllStatistics ? "All" : "Only relevant", systemImage: vm.showAllStatistics ? "eye" : "eye.slash")
			}
		} label: {
			Image(systemName: "ellipsis.circle")
		}
	}
	
}
