//
//  FolderView.swift
//  iRemember
//
//  Created by Privat on 22.07.23.
//

import SwiftUI
import SwiftData

struct ExerciseListView: View {
	
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
					addMenu
				}
				ToolbarItem {
					menu
				}
			}
			.sheet(isPresented: $vm.showAddExercise) {
				ExerciseEditorView(in: vm.learnlist)
			}
			.exerciseSelectorSheet(isPresented: $vm.showSelectExercises, selection: $vm.learnlist.exercises)
			.sheet(isPresented: $vm.showEdit) {
				LearnlistEditorView(learnlist: vm.learnlist)
			}
			.learnlistInfoSheet(isPresented: $vm.showInfo, learnlist: vm.learnlist)
			.confirmationDialog("Confirm delete", isPresented: $vm.showConfirmDelete) {
				Button("Remove from Learnlist") {
					vm.remove(andDelete: false)
				}
				Button("Delete exercise", role: .destructive) {
					vm.remove(andDelete: true)
				}
			}
    }
	
}

extension ExerciseListView {
	
	var mainView: some View {
		List {
			Section {
				LearnlistHeaderView(learnlist: vm.learnlist)
					.ignoreCell()
			}
			Section {
				ForEach(vm.learnlist.exercises, id: \.id) { exercise in
					NavigationLink(value: PracticeSession(.queue([exercise]))) {
						ListItemView(for: exercise)
					}
					.swipeActions(edge: .leading) {
						Button {
							// TODO: Queue items
						} label: {
							Image(systemName: "plus.viewfinder")
						}
						.tint(.orange)
					}
				}
				.onDelete(perform: vm.confirmDelete(indexSet:))
			}
		}
	}
	
	var addMenu: some View {
		Menu {
			Button {
				vm.showAddExercise = true
			} label: {
				Label("Create new", systemImage: "plus.app")
			}
			Button {
				vm.showSelectExercises = true
			} label: {
				Label("Select existing", systemImage: "checkmark.circle")
			}
		} label: {
			Image(systemName: "square.and.pencil")
		}
	}
	
	var menu: some View {
		Menu {
			Button {
				vm.showInfo = true
			} label: {
				Label("Info", systemImage: "info.circle")
			}
			
			Button {
				// TODO: Implement share Folder
			} label: {
				Label("Share", systemImage: "square.and.arrow.up")
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
