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
                .frame(width: hug ? nil : UIScreen.main.bounds.width * 0.8)
                .background(fill == ButtonFill.fill ? Constants.bgCitrusPurpleDefault : Constants.bgActionNeutralAltDefault)
                .foregroundColor(fill == ButtonFill.fill ? Constants.textInverse : Constants.textNeutral)
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
                .frame(width: hug ? nil : UIScreen.main.bounds.width * 0.8)
                .background(fill == ButtonFill.fill ? Constants.bgCitrusPurpleDefault : Constants.bgActionNeutralAltDefault)
                .foregroundColor(fill == ButtonFill.fill ? Constants.textInverse : Constants.textNeutral)
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
                .frame(width: hug ? nil : UIScreen.main.bounds.width * 0.8)
                .background(fill == ButtonFill.fill ? Constants.bgCitrusPurpleDefault : Constants.bgActionNeutralAltDefault)
                .foregroundColor(fill == ButtonFill.fill ? Constants.textInverse : Constants.textNeutral)
                .cornerRadius(Constants.spacingRadiusTight)
                .overlay(
                    RoundedRectangle(cornerRadius: Constants.spacingRadiusTight)
                    .inset(by: 0.5)
                    .stroke(fill == ButtonFill.outline ? Constants.borderNeutral : Constants.borderClear, lineWidth: Constants.borderDefault)
                )
        }
    }
}

struct CitrusToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, Constants.spacingTight)
            .padding(.vertical, Constants.spacingTighterEr)
            .frame(height: 34, alignment: .center)
            .background(configuration.isOn ? Constants.bgCitrusToggleOn : Constants.bgActionNeutralDefault)
            .cornerRadius(Constants.spacingRadiusTighter)
            .overlay(
            RoundedRectangle(cornerRadius: Constants.spacingRadiusTighter)
                .inset(by: 0.5)
                .stroke(Constants.borderNeutral, lineWidth: Constants.borderDefault)
            )
            .onTapGesture {
                configuration.isOn.toggle()
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
