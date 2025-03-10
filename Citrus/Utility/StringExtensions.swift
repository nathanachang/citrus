//
//  StringExtensions.swift
//  Citis
//
//  Created by Paul Minyoo Kim on 2/6/25.
//


import Foundation
extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    func localized(arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }
}
