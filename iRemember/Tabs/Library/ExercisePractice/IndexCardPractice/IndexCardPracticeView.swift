//
//  IndexCardPracticeView.swift
//  iRemember
//
//  Created by Privat on 24.12.23.
//

import SwiftUI

struct IndexCardPracticeView: View {
	
	@State var vm: IndexCardPracticeViewModel
	@State var rating: IndexCardRating = .none
	
	var frontRotation: Double {
		vm.vm.isRevealed ? 0 : 90
	}
	
	var backRotation: Double {
		vm.vm.isRevealed ? -90 : 0
	}
	
	init(for indexCard: IndexCard, vm: ExercisePracticeViewModel) {
		self._vm = State(initialValue: IndexCardPracticeViewModel(indexCard: indexCard, vm: vm))
	}
	
    var body: some View {
		VStack {
			Spacer()
			ZStack {
				indexCardPracticeView(for: vm.indexCard.front)
					.rotation3DEffect(.degrees(vm.frontRotation), axis: (0, 1, 0))
				indexCardPracticeView(for: vm.indexCard.back)
					.rotation3DEffect(.degrees(vm.backRotation), axis: (0, 1, 0))
			}
			.onChange(of: vm.vm.isRevealed) {
				vm.flipAnimation()
			}
			Spacer()
			if vm.vm.isRevealed {
				HStack {
					ForEach(IndexCardRating.allCases) { rating in
						if rating != .none {
							ratingButton(for: rating)
						}
					}
				}
//				Picker("Rating", selection: $rating) {
//					ForEach(IndexCardRating.allCases) { rating in
//						if rating != .none {
//							Text(rating.rawValue)
//								.tag(rating)
//						}
//					}
//				}
//				.pickerStyle(.segmented)
			}
		}
		.padding(.horizontal)
    }
	
	@ViewBuilder
	func ratingButton(for rating: IndexCardRating) -> some View {
		Button(rating.rawValue) {
			self.rating = rating
		}
		.frame(maxWidth: .infinity)
		.tint(.green)
		.bold()
	}
	
	@ViewBuilder
	func indexCardPracticeView(for page: IndexCardPage) -> some View {
		VStack {
			Text(page.text)
				.font(.title)
			if !page.explanation.isEmpty {
				Text(page.explanation)
					.foregroundStyle(.secondary)
					.font(.footnote)
			}
		}
		.padding()
		.frame(maxWidth: .infinity, minHeight: 250)
		.background(Color(uiColor: UIColor.secondarySystemBackground))
		.clipShape(.rect(cornerRadius: 10))
	}
	
}
