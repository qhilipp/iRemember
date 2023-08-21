//
//  LabeledImage.swift
//  iRemember
//
//  Created by Privat on 01.08.23.
//

import SwiftUI

struct LabeledImage<Content: View>: View {
	
	var image: Image?
	var alignment: TopOrBottomAlignment
	var content: () -> Content
	
	init(_ image: Image?, alignment: TopOrBottomAlignment = .bottom, @ViewBuilder content: @escaping () -> Content) {
		self.image = image
		self.alignment = alignment
		self.content = content
	}
	
    var body: some View {
		if let image {
			ZStack(alignment: alignment.alignment) {
				image
					.resizable()
					.aspectRatio(4/3, contentMode: .fill)
					.frame(maxWidth: .infinity)
				VStack {
					content()
				}
				.padding()
				.frame(maxWidth: .infinity)
				.background(.thinMaterial)
			}
			.rounded()
			.ignoreCell()
		} else {
			VStack {
				content()
			}
		}
    }
	
}

enum TopOrBottomAlignment {
	case top
	case bottom
	
	var reversed: TopOrBottomAlignment {
		switch self {
		case .top: .bottom
		case .bottom: .top
		}
	}
	
	var alignment: Alignment {
		switch self {
		case .top: .top
		case .bottom: .bottom
		}
	}
	
	var edgeSet: Edge.Set {
		switch self {
		case .top: .top
		case .bottom: .bottom
		}
	}
}
