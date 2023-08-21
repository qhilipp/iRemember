//
//  ExercisePracticeWireframeView.swift
//  iRemember
//
//  Created by Privat on 07.08.23.
//

import SwiftUI

struct ExercisePracticeWireframeView<Content: View, SpecificViewModel: ExercisePracticeWireframeViewModel>: View {
	
	@Environment(\.modelContext) var context
	@EnvironmentObject var learnlistManager: LearnlistManager
	@Binding var vm: SpecificViewModel
	var content: () -> Content
	
	init(vm: Binding<SpecificViewModel>, @ViewBuilder content: @escaping () -> Content) {
		self._vm = vm
		self.content = content
	}
	
    var body: some View {
		ScrollViewReader { proxy in
			ScrollView {
				VStack {
					content()
					ctaButton(proxy)
				}
				.padding(.horizontal)
				.id(1)
			}
		}
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				Menu {
					menu
				} label: {
					Image(systemName: "ellipsis.circle")
				}
			}
		}
		.onAppear {
			vm.context = context
			vm.learnlistManager = learnlistManager
		}
    }
	
	@ViewBuilder
	func ctaButton(_ proxy: ScrollViewProxy) -> some View {
		Button {
			withAnimation {
				proxy.scrollTo(1, anchor: .top)
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
		.padding(.bottom)
	}
	
	@ViewBuilder
	var menu: some View {
		Button {
			// TODO: Implement skiping logic
//			learnlistManager.next()
		} label: {
			Label("Skip", systemImage: "arrow.forward")
		}
		.disabled(learnlistManager.isEmpty)
	}
	
}
