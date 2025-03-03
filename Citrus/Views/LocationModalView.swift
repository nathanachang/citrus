//
//  LocationModalView.swift
//  UIMapExample
//
//  Created by Nathan Chang on 3/3/25.
//

import SwiftUI

struct LocationModalView: View {
    let location: Location
    @Binding var isPresented: Bool
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            VStack(alignment: .leading, spacing: Constants.spacingDefault) {
                Text("Location 1")
                    .font(
                    Font.custom("Inter", size: 32)
                      .weight(.bold)
                    )
                    .foregroundColor(Constants.textNeutral)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                Button(action: {
                    // Add your button action here
                }) {
                    HStack(alignment: .center, spacing: Constants.spacingTighter) {
                        Image(.restaurant) // Replace with your actual image
                        Text("Toggle Button") // Replace with your actual text
                    }
                    .padding(.horizontal, Constants.spacingTight)
                    .padding(.vertical, Constants.spacingTighterEr)
                    .background(Constants.bgActionNeutralDefault)
                    .cornerRadius(Constants.spacingRadiusTighter)
                    .overlay(
                        RoundedRectangle(cornerRadius: Constants.spacingRadiusTighter)
                            .inset(by: 0.5)
                            .stroke(Constants.borderNeutral, lineWidth: Constants.borderDefault)
                    )
                }
                .buttonStyle(PlainButtonStyle()) // Ensures no default button styling interferes
                Text("Body text Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin imperdiet justo neque, pretium varius ante ullamcorper vel.")
                    .font(Font.custom("Inter", size: 16))
                    .foregroundColor(Constants.textNeutral)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(maxWidth: .infinity, minHeight: 206.93481, maxHeight: 206.93481)
                    .background(
                    Image(.sampleLocation)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 313.8800048828125, height: 206.934814453125)
                        .clipped()
                    )
                Text("Caption Lorem ipsum dolor sit amet.")
                    .font(Font.custom("Inter", size: 16))
                    .foregroundColor(Constants.textNeutral)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                Divider()
                    .frame(width: 313, height: 1)
                    .background(Constants.borderNeutral)
                HStack(alignment: .center, spacing: Constants.spacingTight) {
                    Button(action: {
                        // Add your button action here
                    }) {
                        HStack(alignment: .center, spacing: Constants.spacingTighter) {
                            Image(.restaurant) // Replace with your desired image
                            Text("Primary CTA") // Replace with your desired text
                        }
                        .padding(.horizontal, Constants.spacingTight)
                        .padding(.vertical, Constants.spacingTighterEr)
                        .background(Constants.bgActionHeroDefault)
                        .cornerRadius(Constants.spacingRadiusTighter)
                        .overlay(
                            RoundedRectangle(cornerRadius: Constants.spacingRadiusTighter)
                                .inset(by: 0.5)
                                .stroke(Constants.borderNeutral, lineWidth: Constants.borderDefault)
                        )
                    }
                    .buttonStyle(PlainButtonStyle()) // Keeps the custom styling intact
                    Button(action: {
                        // Add your button action here
                    }) {
                        HStack(alignment: .center, spacing: Constants.spacingTighter) {
                            Image(.restaurant) // Replace with your desired image
                            Text("Secondary") // Replace with your desired text
                        }
                        .padding(.horizontal, Constants.spacingTight)
                        .padding(.vertical, Constants.spacingTighterEr)
                        .background(Constants.bgActionNeutralDefault)
                        .cornerRadius(Constants.spacingRadiusTighter)
                        .overlay(
                            RoundedRectangle(cornerRadius: Constants.spacingRadiusTighter)
                                .inset(by: 0.5)
                                .stroke(Constants.borderNeutral, lineWidth: Constants.borderDefault)
                        )
                    }
                    .buttonStyle(PlainButtonStyle()) // Ensures default button styling doesn't override your custom design

                }
                .padding(0)
            }
            .padding(0)
            .frame(width: 313.88, alignment: .topLeading)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, Constants.spacingDefault)
        .background(Constants.bgNeutral)
        .cornerRadius(Constants.spacingRadiusDefault)
        .shadow(color: .black.opacity(0.25), radius: 4.1, x: 0, y: 4)
    }
}
