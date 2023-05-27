//
//  ContentView.swift
//  SwiftUI_Combine_TMDB_API_Example
//
//  Created by cano on 2023/05/27.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            SearchUserBarView().environmentObject(viewModel)
            ErrorView().environmentObject(viewModel)
            List(viewModel.movies) { movie in
                SearchMovieRowView(movie: movie)
            }
            //.padding([.bottom], 20)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
