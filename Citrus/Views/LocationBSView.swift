//
//  LocationBSView.swift
//  Citrus
//
//  Created by Nathan Chang on 4/21/25.
//

import SwiftUI

struct LocationBSView: View {
    let location: Location
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.spacingTight) {
            Text(location.name)
                .font(
                Font.custom("Instrument Sans", size: 20)
                  .weight(.bold)
                )
                .foregroundColor(Constants.textNeutral)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            Text("{Subheader}")
                .font(
                Font.custom("Instrument Sans", size: 14)
                  .weight(.medium)
                )
                .foregroundColor(Constants.textNeutral)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            
            Divider()
                .frame(width: 360, height: 1)
                .background(Constants.borderNeutral)
            
            HStack(alignment: .center, spacing: Constants.spacingTight) {
                Image(.sampleLocation)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: Constants.spacingRadiusTighter))
                    .clipped()

                Text("{Body text}")
                    .font(Font.custom("Instrument Sans", size: 14))
                    .foregroundColor(Constants.textNeutral)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(0)
            .frame(maxWidth: .infinity, alignment: .leading)

            
            Divider()
                .frame(width: 360, height: 1)
                .background(Constants.borderNeutral)
            
            HStack(alignment: .center, spacing: 16) {
                HStack(alignment: .top, spacing: Constants.spacingTighter) {
                    Button(action: { }) {
                        Text("Button 1")
                    }
                    .buttonStyle(
                        CitrusButtonStyle(
                            size: .medium,
                            fill: .fill
                        )
                    )
                    Button(action: { }) {
                        Text("Button 2")
                    }
                    .buttonStyle(
                        CitrusButtonStyle(
                            size: .medium,
                            fill: .outline
                        )
                    )
                }
                .padding(0)
                .padding(.top, Constants.spacingTightest)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                
                HStack(alignment: .top, spacing: Constants.spacingTighter) {
                    Image(.route)
                        .frame(width: 24, height: 24)
                    Image(.save)
                        .frame(width: 24, height: 24)
                    Image(.share)
                        .frame(width: 24, height: 24)
                }
                .padding(0)
            }
            .padding(0)
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }
        .padding(.horizontal, Constants.spacingLooser)
        .padding(.top, Constants.spacingLooser)
        .padding(.bottom, Constants.spacingLoose)
        .frame(width: 402, alignment: .top)
        .background(Constants.bgNeutral)
        .cornerRadius(Constants.spacingRadiusDefault)
    }
}
