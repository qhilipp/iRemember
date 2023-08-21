//
//  learnlistListView.swift
//  iRemember
//
//  Created by Privat on 23.07.23.
//

import Foundation
import SwiftUI
import SwiftData

struct LearnlistListView: View {
	
	@Environment(\.modelContext) var context: ModelContext
	@State var vm = LearnlistViewModel()
	@StateObject var learnlistManager = LearnlistManager()
	
	var body: some View {
		NavigationStack(path: $learnlistManager.path) {
			List {
				ForEach(vm.filteredLearnlists) { learnlist in
					NavigationLink(value: learnlist) {
						ListItemView(itemType: .learnlist(learnlist))
					}
				}
				.onDelete(perform: vm.delete)
			}
			.navigationTitle("iRemember")
			.searchable(text: $vm.searchTerm)
			.navigationDestination(for: Learnlist.self) { learnlist in
				ExerciseListView(learnlist: learnlist)
			}
			.navigationDestination(for: Exercise.self) { exercise in
				ExercisePracticeView(for: exercise)
			}
			.navigationDestination(for: SessionStatistic.self) { sessionStatistic in
				SessionStatisticsView(for: sessionStatistic)
			}
			.toolbar {
				ToolbarItem {
					Button {
						vm.showAddLearnlist = true
					} label: {
						Image(systemName: "square.and.pencil")
					}
				}
			}
			.sheet(isPresented: $vm.showAddLearnlist) {
				vm.update()
			} content: {
				LearnlistEditorView()
			}
		}
		.onAppear {
			learnlistManager.context = context
			vm.context = context
			vm.update()
		}
		.environmentObject(learnlistManager)
	}
	
}
