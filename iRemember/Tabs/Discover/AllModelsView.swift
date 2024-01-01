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
				NavigationLink("Learnlists", value: PredicateWrapper<Learnlist>.all)
				NavigationLink("Exercises", value: PredicateWrapper<Exercise>.all)
			}
			.navigationTitle("All Model Types")
			.navigationDestination(for: PredicateWrapper<Learnlist>.self) {
				ListView(predicate: $0.predicate)
			}
			.navigationDestination(for: PredicateWrapper<Exercise>.self) {
				ListView(predicate: $0.predicate)
			}
			.navigationDestination(for: Learnlist.self) {
				LearnlistInfoView(learnlist: $0)
			}
			.navigationDestination(for: Exercise.self) {
				ExerciseInfoView(exercise: $0)
			}
		}
    }
	
}

struct ListView<T: PersistentModel>: View {
	
	let predicate: Predicate<T>
	@State var models: [T] = []
	
	var body: some View {
		List {
			ForEach(models) { model in
				NavigationLink(value: model) {
					ListItemView(for: model)
				}
			}
		}
		.navigationTitle(String(describing: T.self))
		.onAppear(perform: update)
	}
	
	func update() {
		models = GlobalManager.shared.fetch(using: predicate)
	}
	
}

struct LearnlistInfoView: View {
	
	let learnlist: Learnlist
	var exerciseIds: [UUID] { learnlist.exercises.map { $0.id } }
	var customPredicate: Predicate<Exercise> { #Predicate<Exercise> { exerciseIds.contains($0.id) } }
	
	var body: some View {
		Form {
			LabeledContent("Date", value: learnlist.creationDate.description)
			LabeledContent("Detail", value: learnlist.detail)
			NavigationLink("Exercises", value: PredicateWrapper<Exercise>(customPredicate))
			Section("Time limitation") {
				LabeledContent("Has time limitation", value: learnlist.hasTimeLimitation.description)
				LabeledContent("Time limitation", value: learnlist.timeLimitation.description)
			}
			PersistentModelInfoView(model: learnlist)
		}
		.navigationTitle(learnlist.name)
	}
	
}

struct ExerciseInfoView: View {
	
	var exercise: Exercise
	
	var body: some View {
		Form {
			Section {
				LabeledContent("Id", value: exercise.id.description)
				LabeledContent("Type", value: exercise.type.description)
				LabeledContent("Date", value: exercise.creationDate.description)
				LabeledContent("Score", value: exercise.score.description)
			}
			PersistentModelInfoView(model: exercise)
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
