//
//  DataExtension.swift
//  iRemember
//
//  Created by Privat on 01.08.23.
//

import Foundation
import SwiftUI
import UIKit

extension Data: Identifiable {
	
	public var id: Int {
		hashValue
	}

	public var image: Image? {
		if let uiImage = UIImage(data: self) {
			return Image(uiImage: uiImage)
		}
		return nil
	}
	
}

extension Optional where Wrapped == Data {
	
	public var image: Image? {
		return self?.image ?? nil
	}
	
}
