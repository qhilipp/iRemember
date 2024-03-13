//
//  MultipleChoicePracticeView.swift
//  iRemember
//
//  Created by Privat on 25.07.23.
//

import SwiftUI
import SwiftData

struct MultipleChoicePracticeView: View, ExercisePracticeDelegate {
	
	@State var vm: ExercisePracticeViewModel
	@State var multipleChoice: MultipleChoice
	
	@State var guesses: [Bool] {
		willSet {
			guard newValue != guesses else { return }
			guard newValue.count == guesses.count, !newValue.isEmpty else { return }
			var index = 0
			for i in guesses.indices {
				if newValue[i] != guesses[i] {
					index = i
					break
				}
			}
			vm.currentStatistic.timeInformation.registerActionTime(for: index)
		}
	}
	
	var correctGuesses: Int {
		var correctGuesses = 0
		for i in 0..<guesses.count {
			if guesses[i] == multipleChoice.answers[i].isCorrect {
				correctGuesses += 1
			}
		}
		return correctGuesses
	}
	
	var incorrectGuesses: Int {
		guesses.count - correctGuesses
	}
	
	init(for multipleChoice: MultipleChoice, vm: ExercisePracticeViewModel) {
		self._vm = State(initialValue: vm)
		self.multipleChoice = multipleChoice
		self.guesses = [Bool].init(repeating: false, count: multipleChoice.answers.count)
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
			vm.delegate = self
		}
	}
	
	@ViewBuilder
	var header: some View {
		LabeledImage(multipleChoice.image, alignment: .top) {
			Text(multipleChoice.question)
				.font(.system(.title, design: .rounded, weight: .heavy))
			if vm.isRevealed == true {
				switch vm.currentStatistic.correctness.rating {
				case .wrong:
					Text("Wrong")
						.foregroundStyle(.secondary)
				case .correct:
					Text("Correct")
						.gradientForeground()
				default:
					HStack(spacing: 0) {
						Text("\(correctGuesses) correct")
							.gradientForeground()
						Text(" • ")
						Text("\(incorrectGuesses) incorrect")
							.foregroundStyle(.secondary)
					}
				}
			}
		}
	}
	
	@ViewBuilder
	var answers: some View {
		ForEach(multipleChoice.answers.indices, id: \.self) { i in
			if let image = multipleChoice.answers[i].image {
				LabeledImage(image) {
					answerContent(at: i)
						.onTapGesture {
							guesses[i].toggle()
						}
				}
			} else {
				answerContent(at: i)
					.padding()
					.background(Color(.secondarySystemBackground))
					.rounded()
					.onTapGesture {
						guesses[i].toggle()
					}
			}
		}
	}
	
	@ViewBuilder
	func answerContent(at i: Int) -> some View {
		HStack {
			Toggle(isOn: $guesses[i]) {
				VStack(alignment: .leading) {
					Text(multipleChoice.answers[i].text)
						.multilineTextAlignment(.leading)
						.font(.system(.title2, design: .rounded, weight: .semibold))
					if let explanation = explanation(for: i), vm.isRevealed == true {
						Text(explanation)
							.multilineTextAlignment(.leading)
							.foregroundStyle(.secondary)
							.font(.footnote)
					}
				}
			}
			.disabled(vm.isRevealed == true)
			if vm.isRevealed == true {
				Text(guessedCorrectly(i) ? "✅" : "❌")
			}
		}
		.onTapGesture {
			if vm.isRevealed == false {
				guesses[i].toggle()
			}
		}
	}
	
	func guessedCorrectly(_ index: Int) -> Bool {
		guesses[index] == multipleChoice.answers[index].isCorrect
	}
	
	func explanation(for index: Int) -> String? {
		let explanation = multipleChoice.answers[index].explanation
		if explanation == "" {
			return nil
		}
		return explanation
	}
	
	func attachSpecificStatistic(to statistic: Statistic) {
		let multipleChoiceStatistic = MultipleChoiceStatistic()
		multipleChoiceStatistic.multipleChoice = multipleChoice
		
		GlobalManager.shared.context.insert(multipleChoiceStatistic)
		
		statistic.statisticType = .multipleChoice(multipleChoiceStatistic)
		
		for i in guesses.indices {
			multipleChoiceStatistic.map[multipleChoice.answers[i].id] = guesses[i]
		}
	}
	
	func evaluateCorrectness() -> Double {
		Double(correctGuesses) / Double(guesses.count)
	}
}
