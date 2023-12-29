//
//  AllModelsView.swift
//  iRemember
//
//  Created by Privat on 28.12.23.
//

import SwiftUI
import SwiftData

struct AllModelsView: View {
	
    var body: some View {
		NavigationStack {
			List {
				NavigationLink("Learnlists") {
					AllLearnlistsView()
				}
				NavigationLink("Exercises") {
					AllExercisesView()
				}
			}
			.navigationTitle("All Model Types")
			.navigationDestination(for: Learnlist.self) {
				LearnlistInfoView(learnlist: $0)
			}
			.navigationDestination(for: Exercise.self) {
				ExerciseInfoView(exercise: $0)
			}
		}
    }
	
}

struct AllLearnlistsView: View {
	
	@Query var learnlists: [Learnlist]
	
	var body: some View {
		List {
			ForEach(learnlists) { learnlist in
				NavigationLink(value: learnlist) {
					ListItemView(itemType: .learnlist(learnlist))
				}
			}
		}
		.navigationTitle("All learnlists")
	}
	
}

struct LearnlistInfoView: View {
	
	var learnlist: Learnlist
	
	var body: some View {
		Form {
			LabeledContent("Date", value: learnlist.creationDate.description)
			LabeledContent("Detail", value: learnlist.detail)
			Section("Time limitation") {
				LabeledContent("Has time limitation", value: learnlist.hasTimeLimitation.description)
				LabeledContent("Time limitation", value: learnlist.timeLimitation.description)
			}
			PersistentModelInfoView(model: learnlist)
		}
		.navigationTitle(learnlist.name)
	}
	
}

struct AllExercisesView: View {
	
	@Query var exercises: [Exercise]
	
	var body: some View {
		List {
			ForEach(exercises) { exercise in
				NavigationLink(value: exercise) {
					ListItemView(itemType: .exercise(exercise))
				}
			}
		}
		.navigationTitle("All exercises")
	}
	
}

struct ExerciseInfoView: View {
	
	var exercise: Exercise
	
	var body: some View {
		Form {
			Section {
				LabeledContent("Name", value: exercise.name)
				LabeledContent("Id", value: exercise.id.description)
				LabeledContent("Type", value: exercise.type.description)
				LabeledContent("Date", value: exercise.creationDate.description)
				LabeledContent("Score", value: exercise.score.description)
			}
		}
		.navigationTitle(exercise.name)
	}
	
}

struct PersistentModelInfoView: View {
	
	var model: any PersistentModel
	
	var body: some View {
		Section("Persistent model information") {
			LabeledContent("Id hash", value: model.persistentModelID.hashValue.description)
			LabeledContent("Deleted", value: model.isDeleted.description)
			LabeledContent("Has changes", value: model.hasChanges.description)
		}
		Section {
			Button("Delete", role: .destructive) {
				GlobalManager.shared.context.delete(model)
			}
		}
	}
	
}
