//
//  IndexCardPracticeView.swift
//  iRemember
//
//  Created by Privat on 24.12.23.
//

import SwiftUI

struct IndexCardPracticeView: View, ExercisePracticeDelegate {

	@State var indexCard: IndexCard
	var vm: ExercisePracticeViewModel
	@State var frontRotation = 0.0
	@State var backRotation = 90.0
	@State var rating: Rating? = nil {
		didSet {
			vm.isCtaEnabled = rating != nil
		}
	}
	
	init(for indexCard: IndexCard, vm: ExercisePracticeViewModel) {
		self._indexCard = State(initialValue: indexCard)
		self.vm = vm
	}
	
    var body: some View {
		VStack {
			Spacer()
			ZStack {
				indexCardPracticeView(for: indexCard.front)
					.rotation3DEffect(.degrees(frontRotation), axis: (0, 1, 0))
				indexCardPracticeView(for: indexCard.back)
					.rotation3DEffect(.degrees(backRotation), axis: (0, 1, 0))
			}
			Spacer()
			if vm.isRevealed {
				HStack {
					ForEach(Rating.allCases) { rating in
						ratingButton(for: rating)
					}
				}
			}
		}
		.padding(.horizontal)
		.onAppear {
			vm.delegate = self
		}
    }
	
	@ViewBuilder
	func ratingButton(for rating: Rating) -> some View {
		Button {
			vm.isCtaEnabled = true
			withAnimation {
				self.rating = rating
			}
		} label: {
			Text(rating.rawValue)
				.bold()
				.frame(maxWidth: .infinity)
		}
		.buttonStyle(.bordered)
		.tint(rating.color)
		.background {
			if self.rating == rating {
				RoundedRectangle(cornerRadius: 5)
					.stroke(rating.color, lineWidth: 3)
			}
		}
	}
	
	@ViewBuilder
	func indexCardPracticeView(for page: IndexCardPage) -> some View {
		if let image = page.image {
			LabeledImage(image, hideContent: page.text.isEmpty) {
				Text(page.text).lineLimit(2)
			}
		} else {
			ZStack {
				Color(uiColor: .secondarySystemFill)
					.overlay {
						Image(systemName: "rectangle.fill")
							.resizable()
							.aspectRatio(contentMode: .fill)
							.hidden()
					}
					.aspectRatio(4/3, contentMode: .fit)
				Text(page.text)
			}
			.rounded()
		}
	}
	
	func revealAction() {
		let durationAndDelay = 0.25
		if vm.isRevealed == true {
			vm.isCtaEnabled = false
			withAnimation(.linear(duration: durationAndDelay)) {
				self.frontRotation = -90
			}
			withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)) {
				self.backRotation = 0
			}
		}
	}
}
