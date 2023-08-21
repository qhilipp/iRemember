//
//  FolderView.swift
//  iRemember
//
//  Created by Privat on 22.07.23.
//

import SwiftUI
import SwiftData

struct ExerciseListView: View {
	
	@EnvironmentObject var learnlistManager: LearnlistManager
	@Environment(\.modelContext) var context: ModelContext
	@State var vm: ExerciseListViewModel
	
	init(learnlist: Learnlist) {
		self._vm = State(initialValue: ExerciseListViewModel(learnlist: learnlist))
	}
	
    var body: some View {
		mainView
			.toolbarTitleDisplayMode(.inline)
			.searchable(text: $vm.searchTerm)
			.toolbar {
				ToolbarItem {
					Button {
						vm.showAddExercise.toggle()
					} label: {
						Image(systemName: "square.and.pencil")
					}
				}
				ToolbarItem {
					menu
				}
			}
			.onAppear {
				vm.context = context
			}
			.sheet(isPresented: $vm.showAddExercise) {
				ExerciseEditorView(learnlist: vm.learnlist)
			}
			.sheet(isPresented: $vm.showEdit) {
				LearnlistEditorView(learnlist: vm.learnlist)
			}
    }
	
}

extension ExerciseListView {
	
	var header: some View {
		VStack {
			if let image = vm.learnlist.image {
				image
					.resizable()
					.aspectRatio(contentMode: .fill)
					.frame(width: 220, height: 220)
					.rounded()
			}
			Text(vm.learnlist.name)
				.font(.system(.largeTitle, design: .rounded, weight: .bold))
			if !vm.learnlist.detail.isEmpty {
				Text(vm.learnlist.detail)
			}
			if !vm.learnlist.exercises.isEmpty {
				Button {
					learnlistManager.startSession(with: vm.learnlist.exercises)
				} label: {
					Label("Learn", systemImage: "play")
						.bold()
						.padding(5)
						.frame(maxWidth: .infinity)
				}
				.buttonStyle(.bordered)
				.tint(.accentColor)
			} else {
				ContentUnavailableView {
					Text("No exercises yet")
				} actions: {
					Button {
						vm.showAddExercise = true
					} label: {
						Label("Add exercise", systemImage: "square.and.pencil")
					}
				}
			}
		}
	}
	
	var mainView: some View {
		List {
			Section {
				header
					.ignoreCell()
			}
//			Section {
//				ForEach(vm.filteredExercises) { exercise in
//					NavigationLink(value: exercise) {
//						ListItemView(itemType: .exercise(exercise))
//					}
//					.swipeActions(edge: .leading) {
//						Button {
//							learnlistManager.insert(exercise)
//						} label: {
//							Image(systemName: "plus.viewfinder")
//						}
//						.tint(.orange)
//					}
//				}
//				.onDelete(perform: vm.delete)
//			}
		}
	}
	
	var menu: some View {
		Menu {
			Button {
				// TODO: Implement share Folder
			} label: {
				Label("Share", systemImage: "square.and.arrow.up")
			}
			
			Button {
				// TODO: Implement add Folder
			} label: {
				Label("Show statistics", systemImage: "folder.badge.plus")
			}
			
			Button {
				vm.showEdit = true
			} label: {
				Label("Edit", systemImage: "pencil")
			}
			
			Menu {
				Picker("", selection: $vm.sortBy) {
					ForEach(SortBy.allCases) {
						Text($0.rawValue)
							.tag($0)
					}
				}
				Picker("", selection: $vm.ordering) {
					ForEach(Ordering.allCases) {
						Text($0.rawValue)
							.tag($0)
					}
				}
			} label: {
				Label("Sort by", systemImage: "arrow.up.arrow.down")
			}

			
		} label: {
			Image(systemName: "ellipsis.circle")
		}
	}
	
}

enum SortBy: String, CaseIterable, Identifiable {
	var id: String {
		rawValue
	}
	case name
	case date
	case custom
}

enum Ordering: String, CaseIterable, Identifiable {
	var id: String {
		rawValue
	}
	case ascending
	case descending
}
