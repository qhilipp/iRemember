//
//  ColorExtension.swift
//  iRemember
//
//  Created by Privat on 07.02.24.
//

import Foundation
import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

extension Color {
	
	public static var systemGroupedBackground: Self {
		#if os(iOS)
		Color(.systemGroupedBackground)
		#else
		Color(nsColor: .windowBackgroundColor)
		#endif
	}
	
	public static var label: Self {
		#if os(iOS)
		Color(.label)
		#else
		Color(nsColor: .labelColor)
		#endif
	}
	
}
