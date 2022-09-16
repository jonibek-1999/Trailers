//
//  UserDefaultsManager.swift
//  Netflix Clone
//
//  Created by ithink on 10/09/22.
//

import Foundation
import UIKit

final class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    let defaults = UserDefaults.standard
    private init() {}
    
    private enum DefaultKeys: String {
        case favorite
        case theme
        case vibration
//        case sound
    }
    
    // MARK: - Vibration Defaults
    
    enum StatusOfVibration {
        case on
        case off
    }
    
    var vibrationStatus: StatusOfVibration {
        get {
            defaults.object(forKey: DefaultKeys.vibration.rawValue) as? StatusOfVibration ?? .on
        } set {
            defaults.set(newValue, forKey: DefaultKeys.vibration.rawValue)
        }
    }
    
    // MARK: - Themes Defaults
    
    enum Theme: Int {
        case auto
        case light
        case dark
            
        func getInterfaceStyle() -> UIUserInterfaceStyle {
            switch self {
            case .auto:
                return .unspecified
            case .light:
                return .light
            case .dark:
                return .dark
            }
        }
    }
    
    var theme: Theme {
        get {
            defaults.object(forKey: DefaultKeys.theme.rawValue) as? Theme ?? .auto
        } set {
            defaults.set(newValue.rawValue, forKey: DefaultKeys.theme.rawValue)
        }
    }
    
    // MARK: - Favorites Defaults
    
    private var favorites: [Int]? {
        get {
            defaults.object(forKey: DefaultKeys.favorite.rawValue) as? [Int] ?? []
        } set {
            guard let value = newValue else {return}
            defaults.set(value, forKey: DefaultKeys.favorite.rawValue)
        }
    }

    func addMovieToFavorites(_ id: Int) {
        guard var array = favorites else {return}
        array.append(id)
        defaults.set(array, forKey: DefaultKeys.favorite.rawValue)
    }
    
    func isFavoriteMovie(_ id: Int) -> Bool {
        guard let favoritesArray = favorites else {return false}
        for favorite in favoritesArray {
            if favorite == id {
                return true
            }
        }
        return false
    }
    
    func removeMovieFromFavorites(_ id: Int) {
        guard var favoriteArray = favorites else {return}
        var index = Int()
        for (i,favorite) in favoriteArray.enumerated() {
            if favorite == id {
                index = i
            }
        }
        favoriteArray.remove(at: index)
        defaults.set(favoriteArray, forKey: DefaultKeys.favorite.rawValue)
    }
    
    func fetchFavoriteMovies() -> [Int] {
        guard let favorites = favorites else {return []}
        return favorites
    }
}
