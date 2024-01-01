//
//  IndexCardPracticeView.swift
//  iRemember
//
//  Created by Privat on 24.12.23.
//

import SwiftUI

struct IndexCardPracticeView: View {
	
	@State var vm: IndexCardPracticeViewModel
	
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
					ForEach(Rating.allCases) { rating in
						ratingButton(for: rating)
					}
				}
			}
		}
		.padding(.horizontal)
    }
	
	@ViewBuilder
	func ratingButton(for rating: Rating) -> some View {
		Button {
			withAnimation {
				vm.rating = rating
			}
		} label: {
			Text(rating.rawValue)
				.bold()
				.frame(maxWidth: .infinity)
		}
		.buttonStyle(.bordered)
		.tint(rating.color)
		.background {
			if vm.rating == rating {
				RoundedRectangle(cornerRadius: 5)
					.stroke(rating.color, lineWidth: 3)
			}
		}
	}
	
	@ViewBuilder
	func indexCardPracticeView(for page: IndexCardPage) -> some View {
		Text(page.text)
			.font(.title)
			.padding()
			.frame(maxWidth: .infinity, minHeight: 250)
			.background(Color(uiColor: UIColor.secondarySystemBackground))
			.clipShape(.rect(cornerRadius: 10))
	}
	
}
