//
//  LearnlistView.swift
//  iRemember
//
//  Created by Privat on 22.07.23.
//

import SwiftUI
import SwiftData

struct LearnlistView: View {
	
	@State var vm: LearnlistViewModel
	
	init(learnlist: Learnlist) {
		self._vm = State(initialValue: LearnlistViewModel(learnlist: learnlist))
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
			.sheet(item: $vm.editExercise) {
				ExerciseEditorView(exercise: $0)
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

extension LearnlistView {
	
	var mainView: some View {
		List {
			Section {
				LearnlistHeaderView(learnlist: vm.learnlist)
					.ignoreCell()
			}
			Section {
				exerciseList
			}
		}
	}
	
	@ViewBuilder
	var exerciseList: some View {
		if vm.learnlist.exercises.isEmpty {
			ContentUnavailableView("No exercises", systemImage: "nosign", description: Text("Add exercises to the learnlist to see them here"))
				.ignoreCell()
		} else if vm.exerciseResults.isEmpty {
			ContentUnavailableView("No exercises", systemImage: "magnifyingglass", description: Text("The searchtearm yielded no results"))
				.ignoreCell()
		} else {
			ForEach(vm.exerciseResults, id: \.id) { exercise in
				NavigationLink(value: PracticeSession(.queue([exercise]))) {
					ListItemView(for: exercise)
						.contextMenu{
							Button {
								vm.editExercise = exercise
							} label: {
								Label("Edit", systemImage: "pencil")
							}
							Button(role: .destructive) {
								vm.confirmDelete(for: exercise)
							} label: {
								Label("Delete", systemImage: "trash")
							}
						}
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
				Picker("", selection: $vm.learnlist.sortBy) {
					ForEach(SortBy.allCases) {
						Text($0.rawValue)
							.tag($0)
					}
				}
				Picker("", selection: $vm.learnlist.ordering) {
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
