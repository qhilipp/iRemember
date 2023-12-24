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
	
	@State var vm = LearnlistViewModel()
	@State var globalManager = GlobalManager.shared
	
	var body: some View {
		NavigationStack(path: $globalManager.navigationPath) {
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
			.navigationDestination(for: PracticeSession.self) { practiceSession in
				ExercisePracticeView(for: practiceSession)
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
			vm.update()
		}
	}
	
}
