//
//  ExerciseSelectorView.swift
//  iRemember
//
//  Created by Privat on 30.12.23.
//

import SwiftUI

struct ExerciseSelectorView: View {
	
	@Binding var selection: [Exercise]
	@Binding var isPresented: Bool
	@State var exercises: [Exercise]
	@State var searchTerm: String = ""
	
	var filteredExercises: [Exercise] {
		if searchTerm.isEmpty {
			exercises
		} else {
			exercises.filter { $0.matches(searchTerm: searchTerm) }
		}
	}
	
	init(isPresented: Binding<Bool>, selection: Binding<[Exercise]>) {
		self._isPresented = isPresented
		self._selection = selection
		self._exercises = State(initialValue: GlobalManager.shared.fetch())
	}
	
    var body: some View {
		NavigationStack {
			List(filteredExercises) { exercise in
				Toggle(isOn: binding(for: exercise)) {
					ListItemView(for: exercise)
				}
			}
			.searchable(text: $searchTerm)
			.navigationTitle("Select exercises")
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button("Done") {
						isPresented = false
					}.bold()
				}
			}
		}
    }
	
	func binding(for exercise: Exercise) -> Binding<Bool> {
		Binding(
			get: {
				selection.contains(exercise) == true
			},
			set: { isOn in
				if isOn {
					selection.append(exercise)
				} else {
					selection.remove(at: selection.firstIndex(of: exercise)!)
				}
			}
		)
	}
}
