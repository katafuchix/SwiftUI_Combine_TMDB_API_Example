//
//  SearchUserBarView.swift
//  SwiftUI_Combine_TMDB_API_Example
//
//  Created by cano on 2023/05/27.
//

import SwiftUI

struct SearchUserBarView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.5)
            HStack {
                TextField("Search User", text: $viewModel.searchWord)
                    .padding([.leading, .trailing], 8)
                    .frame(height: 32)
                    .background(Color.white.opacity(0.4))
                    .cornerRadius(8)
                
                Button(
                        action: {
                            viewModel.searchTrigger.send(())
                            UIApplication.shared.endEditing()
                        },
                        label: { Text("Search") }
                    )
                    .disabled(!viewModel.isSearchButtonEnabled)
                    .foregroundColor(self.buttonColor)
                }
                .padding([.leading, .trailing], 16)
            }
            .frame(height: 64)
    }
    
    var buttonColor: Color {
        return viewModel.isSearchButtonEnabled ? .white : .gray
    }
}


struct SearchUserBarView_Previews: PreviewProvider {
    static var previews: some View {
        @EnvironmentObject var viewModel: ViewModel
        SearchUserBarView(viewModel: _viewModel)
    }
}

