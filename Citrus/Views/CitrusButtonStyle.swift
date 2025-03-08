//
//  CitrusButtonStyle.swift
//  Citrus
//
//  Created by Nathan Chang on 3/7/25.
//

import SwiftUI

struct CitrusButtonStyle: ButtonStyle {
    var size: ButtonSize
    var fill: ButtonFill
    var hug: Bool = true
    
    func makeBody(configuration: Configuration) -> some View {
        switch size {
        case .small:
            configuration.label
                .padding(.horizontal, Constants.spacingTighter)
                .padding(.vertical, Constants.spacingTightest)
                .background(fill == ButtonFill.fill ? Constants.bgCitrusPurpleDefault : Constants.bgActionNeutralAltDefault)
                .cornerRadius(Constants.spacingRadiusTight)
                .overlay(
                    RoundedRectangle(cornerRadius: Constants.spacingRadiusTight)
                    .inset(by: 0.5)
                    .stroke(fill == ButtonFill.outline ? Constants.borderNeutral : Constants.borderClear, lineWidth: Constants.borderDefault)
                )
        case .medium:
            configuration.label
                .padding(.horizontal, Constants.spacingTight)
                .padding(.vertical, Constants.spacingTighterEr)
                .background(fill == ButtonFill.fill ? Constants.bgCitrusPurpleDefault : Constants.bgActionNeutralAltDefault)
                .cornerRadius(Constants.spacingRadiusTight)
                .overlay(
                    RoundedRectangle(cornerRadius: Constants.spacingRadiusTight)
                    .inset(by: 0.5)
                    .stroke(fill == ButtonFill.outline ? Constants.borderNeutral : Constants.borderClear, lineWidth: Constants.borderDefault)
                )
        case .large:
            configuration.label
                .padding(.horizontal, Constants.spacingDefault)
                .padding(.vertical, Constants.spacingTighter)
                .background(fill == ButtonFill.fill ? Constants.bgCitrusPurpleDefault : Constants.bgActionNeutralAltDefault)
                .cornerRadius(Constants.spacingRadiusTight)
                .overlay(
                    RoundedRectangle(cornerRadius: Constants.spacingRadiusTight)
                    .inset(by: 0.5)
                    .stroke(fill == ButtonFill.outline ? Constants.borderNeutral : Constants.borderClear, lineWidth: Constants.borderDefault)
                )
        }
    }
}


enum ButtonSize {
    case small
    case medium
    case large
}

enum ButtonFill {
    case fill
    case outline
    case bare
}
