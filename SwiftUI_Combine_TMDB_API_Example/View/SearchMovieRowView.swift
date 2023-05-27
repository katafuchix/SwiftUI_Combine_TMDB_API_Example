//
//  SearchMovieRowView.swift
//  SwiftUI_Combine_TMDB_API_Example
//
//  Created by cano on 2023/05/27.
//

import SwiftUI

struct SearchMovieRowView: View {
    var movie: Movie
    var body: some View {
        HStack {
            AsyncImage(url: movie.thumbImageUrl) { image in
                       image.resizable()
                      .scaledToFit()
                      .frame(width: 120, height: 120)
                   } placeholder: {
                       ProgressView()
                   }
            VStack(alignment: .leading) {
                Text(movie.title)
                    .font(.headline)
                Text(movie.originalTitle)
                    .font(.subheadline)
            }
        }
    }
}

struct SearchMovieRowView_Previews: PreviewProvider {
    static var previews: some View {
        SearchMovieRowView(movie: Movie(
            id: UUID(),
            movieId: 1,
            originalTitle: "泣きたい私は猫をかぶる",
            title: "A Whisker Away",
            poster_path: "6inkRM1XGBG5vRhclCPWfMenp7N.jpg"))
    }
}
