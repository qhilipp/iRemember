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
	
	init(for multipleChoice: MultipleChoice, vm: ExercisePracticeViewModel) {
		self._vm = State(initialValue: MultipleChoicePracticeViewModel(for: multipleChoice, vm: vm))
	}
	
	var body: some View {
		ScrollView {
			VStack {
				header
				answers
			}
			.clipShape(.rect(cornerRadius: 10))
			.padding(.horizontal)
		}
		.onAppear {
			vm.setup()
		}
	}
	
	@ViewBuilder
	var header: some View {
		LabeledImage(vm.multipleChoice.image, alignment: .top) {
			Text(vm.multipleChoice.question)
				.font(.system(.title, design: .rounded, weight: .heavy))
			if vm.vm.isRevealed {
				switch vm.vm.currentStatistic.correctness.rating {
				case .wrong:
					Text("Wrong")
						.foregroundStyle(.secondary)
				case .correct:
					Text("Correct")
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
		ForEach(vm.multipleChoice.answers.indices, id: \.self) { i in
			if let image = vm.multipleChoice.answers[i].image {
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
					Text(vm.multipleChoice.answers[i].text)
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
