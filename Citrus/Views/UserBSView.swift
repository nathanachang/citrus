//
//  UserBSView.swift
//  Citrus
//
//  Created by Nathan Chang on 5/12/25.
//

import SwiftUI

struct UserBSView: View {
    @ObservedObject var userViewModel: UserViewModel
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.spacingTight) {
            Text(userViewModel.user.pref_name)
                .font(
                Font.custom("Instrument Sans", size: 20)
                  .weight(.bold)
                )
                .foregroundColor(Constants.textNeutral)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            Text(userViewModel.address)
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
                Image(systemName: "person.circle.fill")
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
        }
        .padding(.horizontal, Constants.spacingLooser)
        .padding(.top, Constants.spacingLooser)
        .padding(.bottom, Constants.spacingLoose)
        .frame(width: 402, alignment: .top)
        .background(Constants.bgNeutral)
        .cornerRadius(Constants.spacingRadiusDefault)
    }
}
