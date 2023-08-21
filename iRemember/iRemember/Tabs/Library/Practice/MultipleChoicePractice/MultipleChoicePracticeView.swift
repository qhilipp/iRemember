//
//  MultipleChoicePracticeView.swift
//  iRemember
//
//  Created by Privat on 25.07.23.
//

import SwiftUI
import SwiftData

struct MultipleChoicePracticeView: View {
	
	@Environment(\.modelContext) var context: ModelContext
	@EnvironmentObject var learnlistManager: LearnlistManager
	@State var vm: MultipleChoicePracticeViewModel
	
	init(for multipleChoiceExercise: MultipleChoiceExercise, wireframeViewModel: ExercisePracticeWireframeViewModel) {
		self._vm = State(initialValue: MultipleChoicePracticeViewModel(for: multipleChoiceExercise, wireframeViewModel: wireframeViewModel))
	}
	
    var body: some View {
		header
		answers
    }
	
	@ViewBuilder
	var header: some View {
		LabeledImage(vm.multipleChoiceExercise.image, alignment: .top) {
			Text(vm.multipleChoiceExercise.question)
				.font(.system(.title, design: .rounded, weight: .heavy))
			if let feedback = vm.feedback {
				switch feedback {
				case .allWrong:
					Text("All wrong")
						.foregroundStyle(.secondary)
				case .allCorrect:
					Text("All correct")
						.gradientForeground()
				case .partial:
					HStack(spacing: 0) {
						Text("\(vm.correctGuesses) correct")
							.gradientForeground()
						Text(" • ")
						Text("\(vm.incorrectGuesses) incorrect")
							.foregroundStyle(.secondary)
					}
				}
			}
		}
	}
	
	@ViewBuilder
	var answers: some View {
		ForEach(vm.multipleChoiceExercise.answers.indices, id: \.self) { i in
			Group {
				if let image = vm.multipleChoiceExercise.answers[i].image {
					LabeledImage(image) {
						answerContent(at: i)
							.onTapGesture {
								vm.guesses[i].toggle()
							}
					}
				} else {
					answerContent(at: i)
						.padding()
						.background(Color(.secondarySystemBackground))
						.rounded()
						.onTapGesture {
							vm.guesses[i].toggle()
						}
				}
			}
		}
	}
	
	@ViewBuilder
	func answerContent(at i: Int) -> some View {
		HStack {
			Toggle(isOn: $vm.guesses[i]) {
				VStack(alignment: .leading) {
					Text(vm.multipleChoiceExercise.answers[i].text)
						.multilineTextAlignment(.leading)
						.font(.system(.title2, design: .rounded, weight: .semibold))
					if let explanation = vm.explanation(for: i), vm.wireframeViewModel.isRevealed {
						Text(explanation)
							.multilineTextAlignment(.leading)
							.foregroundStyle(.secondary)
							.font(.footnote)
					}
				}
			}
			.disabled(vm.wireframeViewModel.isRevealed)
			if let _ = vm.wireframeViewModel.statistic {
				Text(vm.guessedCorrectly(i) ? "✅" : "❌")
			}
		}
		.onTapGesture {
			if !vm.wireframeViewModel.isRevealed {
				vm.guesses[i].toggle()
			}
		}
	}
}
