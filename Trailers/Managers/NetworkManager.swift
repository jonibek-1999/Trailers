//
//  NetworkManager.swift
//  Netflix Clone
//
//  Created by ithink on 02/09/22.
//

import Foundation
import UIKit

struct Constants {
    static let API_KEY = "697d439ac993538da4e3e60b54e762cd"
    static let baseURL = "https://api.themoviedb.org/"
    static let YouTubeAPI_KEY = "AIzaSyADMfrAoZhCMKwlChSJpZE_eB3uvtXKmpw"
    static let YouTubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
}

enum APIError: Error {
    case failedToGetData
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    // Trending Movies
    func getTrendingMovies(completion: @escaping (Result<[Element],Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)3/trending/movie/day?api_key=\(Constants.API_KEY)") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(ElementResponse.self, from: data)
                completion(.success(results.results))
            } catch  {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    // Trending TVs
    func getTrendingTvs(completion: @escaping (Result<[Element],Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)3/trending/tv/day?api_key=\(Constants.API_KEY)") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(ElementResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    // Upcoming Movie
    func getUpcomingMovies(completion: @escaping(Result<[Element], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)3/movie/upcoming?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(ElementResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    // Top Rated Movie
    func getTopRatedMovies(completion: @escaping(Result<[Element], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)3/movie/top_rated?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(ElementResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    // Popular Movie
    func getPopularMovies(completion: @escaping(Result<[Element], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)3/movie/popular?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(ElementResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    // Search Movie
    func getSearchedMovies(completion: @escaping(Result<[Element], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)3/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(ElementResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    // Search Query
    func search(with text: String, completion: @escaping(Result<[Element], Error>) -> Void) {
        guard let query = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(Constants.baseURL)3/search/movie?api_key=\(Constants.API_KEY)&language=en-US&query=\(query)&page=1&include_adult=false") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(ElementResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    // Get Movie Video
    func getMovieVideo(withId id: Int, completion: @escaping (Result<[VideoElement],Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)3/movie/\(id)/videos?api_key=\(Constants.API_KEY)&language=en-US") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let decoder = try JSONDecoder().decode(VideoResponse.self, from: data)
                completion(.success(decoder.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }

    // Get YouTube Trailer
    func getYouTubeTrailer(withQuery query: String, completion: @escaping (Result<VideoItem,Error>) -> Void ) {
        guard let formattedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(Constants.YouTubeBaseURL)q=\(formattedQuery)&key=\(Constants.YouTubeAPI_KEY)") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {return}
            do {
                let result = try JSONDecoder().decode(YouTubeResponse.self, from: data)
                completion(.success(result.items[0]))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    //Get Header Image
    func getTrendingWeeklyMovies(completion: @escaping (Result<[Element],Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)3/trending/movie/week?api_key=\(Constants.API_KEY)") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(ElementResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    //Get Movie Details
    func getElementDetails(byId id: Int, completion: @escaping(Result<Element,Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)3/movie/\(id)?api_key=\(Constants.API_KEY)&language=en-US") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let myData = data, error ==  nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(Element.self, from: myData)
                completion(.success(result))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
}
