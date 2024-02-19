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
				NavigationLink("Statistics", value: PredicateWrapper<Statistic>.all)
				NavigationLink("Practice Session", value: PredicateWrapper<PracticeSession>.all)
			}
			.navigationTitle("All Model Types")
			.navigationDestination(for: PredicateWrapper<Learnlist>.self) {
				ListView(predicate: $0.predicate)
			}
			.navigationDestination(for: Learnlist.self) {
				LearnlistInfoView(for: $0)
			}
			.navigationDestination(for: PredicateWrapper<Exercise>.self) {
				ListView(predicate: $0.predicate)
			}
			.navigationDestination(for: Exercise.self) {
				ExerciseInfoView(for: $0)
			}
			.navigationDestination(for: PredicateWrapper<Statistic>.self) {
				ListView(predicate: $0.predicate)
			}
			.navigationDestination(for: Statistic.self) {
				StatisticInfoView(statistic: $0)
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
