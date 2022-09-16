//
//  DataPersistenceManager.swift
//  Netflix Clone
//
//  Created by ithink on 06/09/22.
//

import Foundation
import CoreData
import UIKit

class DataPersistenceManager {
    
    enum DatabaseError: Error {
        case failedToDownload
        case failedToFetchData
        case failedToDeleteData
    }
    
    static let shared = DataPersistenceManager()
    private init() {}
    
    // --- CREATE model
    func download(model: Element, completion: @escaping (Result<Void,Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let item = ElementModel(context: context)
        
        item.id = Int64(model.id)
        item.overview = model.overview
        item.original_title = model.original_title
        item.poster_path = model.poster_path
        item.release_date = model.release_date
        item.vote_average = model.vote_average
        item.vote_count = Int64(model.vote_count)
        item.original_name = model.original_name
        item.media_type = model.media_type
        let currentTime = "".getCurrentDataAndTime()
        item.downloadedDate = "\u{1F551} \(currentTime)"
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToDownload))
        }
    }
    
    // --- READ model
    func fetchDataFromDatabase(completion: @escaping (Result<[ElementModel],Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<ElementModel>
        request = ElementModel.fetchRequest()
        
        do {
            let elements = try context.fetch(request)
            completion(.success(elements))
            
        } catch {
            completion(.failure(DatabaseError.failedToFetchData))
        }
    }
    
    // --- DELETE model
    func deleteDataFromDatabase(model: ElementModel, completion: @escaping (Result<Void,Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToDeleteData))
        }
    }
    
    // --- Check whether the movie is downloaded or NOT
    func isMovieDownloaded(_ idOfMovie: Int) -> Bool {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return false}
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<ElementModel>
        request = ElementModel.fetchRequest()
        
        do {
            let elements = try context.fetch(request)
            for element in elements {
                if element.id == idOfMovie {
                    return true
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        return false
    }
    
}
