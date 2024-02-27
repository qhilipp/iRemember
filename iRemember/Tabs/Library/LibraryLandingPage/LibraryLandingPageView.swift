//
//  LibraryLandingPageView.swift
//  iRemember
//
//  Created by Privat on 01.10.23.
//

import SwiftUI

struct LibraryLandingPageView: View {
	
	@State var vm = LibraryLandingPageViewModel()
	@State var globalManager = GlobalManager.shared
	
    var body: some View {
		NavigationStack(path: $globalManager.navigationPath) {
			ScrollView {
				VStack(spacing: 20) {
					LearnlistRow(title: "Learn now", learnlists: vm.learnNow)
					LearnlistRow(title: "For you", learnlists: vm.forYou)
					LearnlistRow(title: "Favorites", learnlists: vm.favorites)
					LearnlistRow(title: "Due soon", learnlists: vm.dueSoon)
					LearnlistRow(title: "A lot to do", learnlists: vm.aLotToDo)
					LearnlistRow(title: "All", learnlists: vm.all)
				}
				.padding(.horizontal)
			}
			.navigationTitle("Library")
			.navigationDestination(for: Learnlist.self) {
				LearnlistView(learnlist: $0)
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
			.learnlistEditorSheet(isPresented: $vm.showAddLearnlist) {
				vm.fetch()
			}
		}
		.onAppear {
			vm.fetch()
		}
    }
}
