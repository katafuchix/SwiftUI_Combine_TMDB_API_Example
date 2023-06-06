//
//  ViewModel.swift
//  SwiftUI_Combine_TMDB_API_Example
//
//  Created by cano on 2023/05/27.
//

import Foundation
import Combine

class ViewModel: ObservableObject {

    // MARK: - Input
    // 検索キーワード
    @Published var searchWord: String = ""
    // 検索トリガ
    @Published var searchTrigger: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
    
    
    // MARK: - Output
    // 検索結果
    @Published var movies: [Movie] = []
    // 検索ボタンの押下可否
    @Published var isSearchButtonEnabled: Bool = false
    // 検索中か
    @Published var isLoading: Bool = false
    // エラー
    @Published var error: Error? = nil
    
    // MARK: - Private
    // searchWordの値を受ける
    private let searchSubject = PassthroughSubject<String, Never>()
    
    // searchSubjectに値がくると処理が走る
    private var searchPublisher: AnyPublisher<String, Never> {
        return searchSubject.eraseToAnyPublisher()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    var cancellationToken: AnyCancellable?

    init() {
        //getMovies()
        
        // 検索トリガ起動
        self.searchTrigger
            .sink { [weak self] _ in
                guard let searchText = self?.searchWord else { return }
                self?.error = nil
                self?.searchSubject.send(searchText)
            }
            .store(in: &cancellables)
        
        // searchSubjectから呼ばれる検索処理
        self.searchPublisher
            // flatMapの後にはAnyPublisher<T, Never>の型を返す必要があります。
            //これにより、エラーハンドリングなどでエラーをキャッチして処理することができ、ストリームが正常に継続して流れるようになります。
            // Result型で返す
            .flatMap { [unowned self] text -> AnyPublisher<Result<[Movie], Error>, Never> in
                                self.isLoading = true
                                // ネットワークリクエストなどの非同期処理を行うPublisherを返す
                                return self.searchAction(query: text)
                                    .map { Result<[Movie], Error>.success($0) }
                                    .catch { Just(Result<[Movie], Error>.failure($0)) }
                                    .eraseToAnyPublisher()
                
            }
            .sink(receiveValue: { [unowned self] result in
                    switch result {
                    case .success(let response):
                        // 成功時の処理
                        self.isLoading = false
                        self.movies = response
                        //print("Received search response: \(response)")
                    case .failure(let error):
                        // エラー時の処理
                        //print("Search failed with error: \(error)")
                        self.isLoading = false
                        self.error = error
                    }
                })
                .store(in: &cancellables)
        
        self.$searchWord.sink(receiveValue: { [weak self] text in
             self?.isSearchButtonEnabled = text.count >= 1
         })
         .store(in: &cancellables)
    }
}

extension ViewModel {

    // Subscriber implementation
    func getMovies() {
        cancellationToken = MovieDB.request(.trendingMoviesWeekly)
            .mapError({ (error) -> Error in
                print(error)
                return error
            })
            .sink(receiveCompletion: { _ in },
                  receiveValue: {
                    self.movies = $0.movies
            })
    }
    
    func searchAction(query: String) -> AnyPublisher<[Movie], Error> {
        return MovieDB.searchRequest(.searchPath, query)
            .map(\.movies)
            .map { $0 }
            .receive(on: DispatchQueue.main)
            .mapError { error -> Error in
                      return error
                  }
            .eraseToAnyPublisher()
    }

}
