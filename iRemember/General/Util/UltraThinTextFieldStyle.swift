//
//  UltraThinTextFieldStyle.swift
//  iRemember
//
//  Created by Privat on 01.04.24.
//

import Foundation
import SwiftUI

struct UltraThinTextFieldStyle: TextFieldStyle {
	
	func _body(configuration: TextField<Self._Label>) -> some View {
		configuration
			.padding(7)
			.background(.ultraThinMaterial.opacity(0.6))
			.clipShape(.rect(cornerRadius: 7))
			.overlay {
				RoundedRectangle(cornerRadius: 7)
					.stroke(lineWidth: 0.4)
					.foregroundStyle(.regularMaterial)
					.allowsHitTesting(false)
			}
	}
	
}

extension TextFieldStyle where Self == UltraThinTextFieldStyle {

	/// A text field style with a semi-defined rounded border and a blured background.
	static var ultraThin: UltraThinTextFieldStyle {
		UltraThinTextFieldStyle()
	}
}
