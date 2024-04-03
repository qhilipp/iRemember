//
//  LabeledImage.swift
//  iRemember
//
//  Created by Privat on 01.08.23.
//

import SwiftUI

struct LabeledImage<Content: View>: View {
	
	var image: Image?
	var aspectRatio: CGFloat
	var hideContent: Bool
	var content: () -> Content
	
	init(_ image: Image?, aspectRatio: CGFloat = 4/3, hideContent: Bool = false, @ViewBuilder content: @escaping () -> Content) {
		self.image = image
		self.aspectRatio = aspectRatio
		self.hideContent = hideContent
		self.content = content
	}
	
    var body: some View {
		if let image {
			ZStack(alignment: .bottom) {
				Color.clear
					.overlay {
						image
							.resizable()
							.aspectRatio(contentMode: .fill)
					}
					.aspectRatio(aspectRatio, contentMode: .fit)
				if !hideContent {
					VStack(alignment: .leading) {
						content()
					}
					.textFieldStyle(.ultraThin)
					.frame(maxWidth: .infinity, alignment: .leading)
					.padding([.horizontal, .bottom])
					.padding(.top, 35)
					.background {
						Rectangle()
							.fill(.ultraThinMaterial)
							.mask {
								VStack(spacing: 0) {
									LinearGradient(
										colors: [
											.black,
											.black.opacity(0.75),
											.clear
										],
										startPoint: .bottom,
										endPoint: .top
									)
									.frame(height: 50)
									Rectangle()
								}
							}
					}
				}
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
