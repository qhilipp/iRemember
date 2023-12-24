//
//  LibraryLandingPageView.swift
//  iRemember
//
//  Created by Privat on 01.10.23.
//

import SwiftUI

struct LibraryLandingPageView: View {
	
	@State var vm = LibraryLandingPageViewModel()
	
    var body: some View {
		VStack {
			LearnlistRow(title: "Learn now", learnlists: [Learnlist(name: "Moinsen", detail: "Das ist das Detail")])
		}
    }
}
