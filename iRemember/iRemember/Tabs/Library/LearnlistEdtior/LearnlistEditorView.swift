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
	@Environment(\.modelContext) var context: ModelContext
	@State var vm = LearnlistEditorViewModel()
	let learnlist: Learnlist?
	@FocusState var focus: Int?
	
	init(learnlist: Learnlist? = nil) {
		self.learnlist = learnlist
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
						.background(Color(.secondarySystemBackground))
						.rounded()
						TextField("Name", text: $vm.learnlist.name)
							.important()
							.background(Color(.secondarySystemBackground))
							.rounded()
							.focused($focus, equals: 0)
					}
				}
				Section {
					TextField("Description", text: $vm.learnlist.detail, axis: .vertical)
						.lineLimit(2...5)
				}
			}
			.toolbar {
				ToolbarItem(placement: .topBarLeading) {
					Button("Cancel") {
						dismissAction()
					}
				}
				ToolbarItem(placement: .principal) {
					Text("Add Learnlist")
						.bold()
				}
				ToolbarItem(placement: .topBarTrailing) {
					Button("Add") {
						vm.addLearnlist()
						dismissAction()
					}
					.disabled(!vm.canAdd)
				}
			}
		}
		.onAppear {
			focus = 0
			vm.context = context
			if let learnlist {
				vm.learnlist = learnlist
			}
		}
    }
}
