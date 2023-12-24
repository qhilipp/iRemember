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
				Learnlist.self,
				MultipleChoice.self,
				MultipleChoiceAnswer.self,
				IndexCard.self,
				IndexCardPage.self,
				Statistic.self,
				PracticeSession.self,
				MultipleChoiceStatistic.self
			])
    }
}
