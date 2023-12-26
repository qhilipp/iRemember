//
//  ExercisePracticeView.swift
//  iRemember
//
//  Created by Privat on 14.08.23.
//

import Foundation
import SwiftUI

struct ExercisePracticeView: View {
	
	@State var vm: ExercisePracticeViewModel
	
	init(for practiceSession: PracticeSession) {
		self._vm = State(initialValue: ExercisePracticeViewModel(practiceSession: practiceSession))
	}
	
	var body: some View {
		ZStack(alignment: .bottom) {
			VStack {
				content
					.id(vm.currentExercise.id)
				ctaButton
					.disabled(true)
					.opacity(0)
			}
			ctaButton
				.background(Color(uiColor: .systemBackground))
				.clipShape(.rect(cornerRadius: 10))
				.padding(.horizontal)
				.frame(maxWidth: .infinity)
		}
		.toolbar(.hidden, for: .tabBar)
		.navigationTitle(vm.currentExercise.name)
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				Menu {
					menu
				} label: {
					Image(systemName: "ellipsis.circle")
				}
			}
			ToolbarItem(placement: .principal) {
				VStack {
					Text(vm.currentExercise.name)
						.bold()
					if vm.showTimer {
						HStack(spacing: 0) {
							if let formattedSessionTimeLeft = vm.formattedSessionTimeLeft {
								Text(formattedSessionTimeLeft)
									.foregroundStyle(vm.sessionStopWatch.isTimeMeager ? .red : .secondary)
							}
							if vm.hasBothTimeLimitations {
								Text(" • ")
									.foregroundStyle(.secondary)
							}
							if let formattedExerciseTimeLeft = vm.formattedExerciseTimeLeft {
								Text(formattedExerciseTimeLeft)
									.foregroundStyle(vm.exerciseStopWatch.isTimeMeager ? .red : .secondary)
							}
						}
						.font(.footnote)
					}
				}
				.onTapGesture {
					withAnimation {
						vm.showTimer.toggle()
					}
				}
			}
		}
		.sheet(isPresented: $vm.showStatistics) {
			NavigationStack {
				SessionStatisticsView(for: vm.practiceSession)
			}
		}
		.alert("Time is up", isPresented: $vm.sessionStopWatch.shouldShowTimeRanOutAlert) {
			Button("Continue") {
				vm.continueSession()
			}
			Button("Conclude") {
				vm.forceSkipSession()
			}
			.bold()
		}
		.alert("Time is up", isPresented: $vm.exerciseStopWatch.shouldShowTimeRanOutAlert) {
			Button("Continue") {
				vm.continueExercise()
			}
			Button(vm.nextText) {
				vm.forceSkipExercise()
			}
			.bold()
		}
	}
	
	@ViewBuilder
	var content: some View {
		switch vm.currentExercise.type {
		case let .multipleChoice(multipleChoice): MultipleChoicePracticeView(for: multipleChoice!, vm: vm)
		case let .indexCard(indexCard): IndexCardPracticeView(for: indexCard!, vm: vm)
		default: Text("Comming soon :)")
		}
	}
	
	@ViewBuilder
	var ctaButton: some View {
		Button {
			withAnimation {
				vm.ctaClicked()
			}
		} label: {
			Text(vm.ctaText)
				.padding()
				.frame(maxWidth: .infinity)
				.font(.system(.title2, design: .rounded, weight: .bold))
		}
		.buttonStyle(.bordered)
		.tint(.accentColor)
	}
	
	@ViewBuilder
	var menu: some View {
		Button {
			vm.next()
		} label: {
			Label("Skip", systemImage: "arrow.forward")
		}
		.disabled(!vm.hasNext)
	}
	
}
