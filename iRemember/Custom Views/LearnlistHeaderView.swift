//
//  LearnlistHeaderView.swift
//  iRemember
//
//  Created by Privat on 02.01.24.
//

import SwiftUI

struct LearnlistHeaderView: View {
	
	let learnlist: Learnlist
	
    var body: some View {
		VStack {
			if let image = learnlist.image {
				image
					.resizable()
					.aspectRatio(contentMode: .fill)
					.frame(width: 220, height: 220)
					.rounded()
			}
			Text(learnlist.name)
				.font(.system(.largeTitle, design: .rounded, weight: .bold))
			if !learnlist.detail.isEmpty {
				Text(learnlist.detail)
			}
			if learnlist.hasTimeLimitation {
				Text("Timelimit: \(learnlist.timeLimitation)")
			}
			if !learnlist.exercises.isEmpty {
				Button {
					GlobalManager.shared.navigationPath.append(PracticeSession(.learnlist(learnlist)))
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
//						vm.showAddExercise = true
					} label: {
						Label("Add exercise", systemImage: "square.and.pencil")
					}
				}
			}
		}
    }
}
