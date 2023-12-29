//
//  LearnlistEditorView.swift
//  iRemember
//
//  Created by Privat on 29.07.23.
//

import SwiftUI
import SwiftData

struct LearnlistEditorView: View {
	
	@Environment(\.dismiss) var dismissAction
	@State var vm: LearnlistEditorViewModel
	@FocusState var focus: Int?
	
	init(learnlist: Learnlist? = nil) {
		self._vm = State(initialValue: LearnlistEditorViewModel(learnlist))
	}
	
    var body: some View {
		NavigationStack {
			Form {
				Section {
					VStack(spacing: 15) {
						PhotoPicker($vm.learnlist.imageData) {
							if let image = vm.learnlist.image {
								image
									.resizable()
									.aspectRatio(contentMode: .fill)
							} else {
								Image(systemName: "list.bullet")
									.resizable()
									.aspectRatio(contentMode: .fit)
									.padding()
							}
						}
						.frame(width: 120, height: 120)
						.background(Color(.systemGroupedBackground))
						.rounded()
						TextField("Name", text: $vm.learnlist.name)
							.important()
							.background(Color(.systemGroupedBackground))
							.rounded()
							.focused($focus, equals: 0)
					}
				}
				Section {
					VStack {
						Toggle("Time limitation", isOn: $vm.learnlist.hasTimeLimitation)
						if vm.learnlist.hasTimeLimitation {
							Picker("", selection: $vm.learnlist.isTimeLimitationPerExercise) {
								Text("For entire Learnlist")
									.tag(false)
								Text("Per exercise")
									.tag(true)
							}
							.pickerStyle(.segmented)
							TimeSelector(time: $vm.learnlist.timeLimitation)
						}
					}
				}
				Section {
					TextField("Description", text: $vm.learnlist.detail, axis: .vertical)
						.lineLimit(2...5)
				}
//				Section {
//					Toggle("Dynamic", isOn: $vm.isDynamic)
//					if vm.isDynamic {
//						TextField("Rule", text: $vm.learnlist.containmentRule)
//					}
//				}
			}
			.toolbar {
				ToolbarItem(placement: .topBarLeading) {
					Button("Cancel") {
						dismissAction()
					}
				}
				ToolbarItem(placement: .principal) {
					Text(vm.principalText)
						.bold()
				}
				ToolbarItem(placement: .topBarTrailing) {
					Button(vm.ctaText) {
						vm.addLearnlist()
						dismissAction()
					}
					.disabled(!vm.canAdd)
				}
			}
		}
		.onAppear {
			focus = 0
		}
    }
}
