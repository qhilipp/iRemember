//
//  LearnlistInfoView.swift
//  iRemember
//
//  Created by Privat on 01.01.24.
//

import SwiftUI

struct LearnlistInfoView: View {
	
	@State var vm: LearnlistInfoViewModel
	
	init(for learnlist: Learnlist) {
		self._vm = State(initialValue: LearnlistInfoViewModel(learnlist: learnlist))
	}
	
	var body: some View {
		Form {
			Section {
				LearnlistHeaderView(learnlist: vm.learnlist)
					.ignoreCell()
			}
			LabeledContent("Date", value: vm.learnlist.creationDate.description)
			LabeledContent("Detail", value: vm.learnlist.detail)
			NavigationLink("Exercises", value: PredicateWrapper<Exercise>(vm.predicate))
			Section("Time limitation") {
				LabeledContent("Has time limitation", value: vm.learnlist.hasTimeLimitation.description)
				LabeledContent("Time limitation", value: vm.learnlist.timeLimitation.description)
			}
			#if DEBUG
			PersistentModelInfoView(model: vm.learnlist)
			#endif
		}
		.navigationDestination(for: PredicateWrapper<Exercise>.self) {
			ListView(predicate: $0.predicate)
		}
	}
}
