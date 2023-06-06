//
//  ErrorView.swift
//  SwiftUI_Combine_TMDB_API_Example
//
//  Created by cano on 2023/05/27.
//

import SwiftUI

struct ErrorView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            if let error = viewModel.error {
                Text(error.localizedDescription)
                    .bold()
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, maxHeight: 40)
                    .padding(8)
                    .foregroundColor(.white)
                    .background(Color.red
                        .edgesIgnoringSafeArea(.top))
                    .animation(.easeInOut, value: 0.25)
                //Spacer()
            }else {
                EmptyView()
            }
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView()
    }
}
