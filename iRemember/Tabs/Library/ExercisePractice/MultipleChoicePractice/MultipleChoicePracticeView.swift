//
//  MultipleChoicePracticeView.swift
//  iRemember
//
//  Created by Privat on 25.07.23.
//

import SwiftUI
import SwiftData

struct MultipleChoicePracticeView: View {
	
	@State var vm: MultipleChoicePracticeViewModel
	
	init(for multipleChoiceExercise: MultipleChoice, vm: ExercisePracticeViewModel) {
		self._vm = State(initialValue: MultipleChoicePracticeViewModel(for: multipleChoiceExercise, vm: vm))
	}
	
	var body: some View {
		ScrollView {
			VStack {
				header
				answers
			}
			.clipShape(.rect(cornerRadius: 10))
			.padding([.leading, .trailing])
		}
	}
	
	@ViewBuilder
	var header: some View {
		LabeledImage(vm.multipleChoiceExercise.image, alignment: .top) {
			Text(vm.multipleChoiceExercise.question)
				.font(.system(.title, design: .rounded, weight: .heavy))
			if let feedback = vm.rating {
				switch feedback {
				case .wrong:
					Text("All wrong")
						.foregroundStyle(.secondary)
				case .correct:
					Text("All correct")
						.gradientForeground()
				default:
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
	
	@ViewBuilder
	func answerContent(at i: Int) -> some View {
		HStack {
			Toggle(isOn: $vm.guesses[i]) {
				VStack(alignment: .leading) {
					Text(vm.multipleChoiceExercise.answers[i].text)
						.multilineTextAlignment(.leading)
						.font(.system(.title2, design: .rounded, weight: .semibold))
					if let explanation = vm.explanation(for: i), vm.vm.isRevealed {
						Text(explanation)
							.multilineTextAlignment(.leading)
							.foregroundStyle(.secondary)
							.font(.footnote)
					}
				}
			}
			.disabled(vm.vm.isRevealed)
			if vm.vm.isRevealed {
				Text(vm.guessedCorrectly(i) ? "✅" : "❌")
			}
		}
		.onTapGesture {
			if !vm.vm.isRevealed {
				vm.guesses[i].toggle()
			}
		}
	}
}
