//
//  StorageManager.swift
//  Sunny
//
//  Created by Руслан Битюков on 27.12.2022.
//

import Foundation
import CoreData

class StorageManager {
    static let shared = StorageManager()
    
    // MARK: - Core Data stack
    
    private  var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Sunny")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private let viewContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    
    func fetchData(completion:(Result<[City], Error>) -> Void ){
        
        let fetchRequest = City.fetchRequest()
        
        do {
            let city = try viewContext.fetch(fetchRequest)
            completion(.success(city))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func save(_ cityName: String, completion: (City) -> Void) {
        let city = City(context: viewContext)
        city.cityName = cityName
        completion(city)
        saveContext()
    }
    
    func delete(_ city: City) {
        viewContext.delete(city)
        saveContext()
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

