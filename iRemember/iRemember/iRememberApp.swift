//
//  iRememberApp.swift
//  iRemember
//
//  Created by Privat on 22.07.23.
//

import SwiftUI
import SwiftData

@main
struct iRememberApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
		.modelContainer(
			for: [
				Exercise.self,
				Learnlist.self,
				MultipleChoiceExercise.self,
				MultipleChoiceAnswer.self,
				Statistic.self,
				SessionStatistic.self,
				MultipleChoiceStatistic.self
			],
			isAutosaveEnabled: false)
    }
}
