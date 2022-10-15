//
//  DatabaseManager.swift
//  CurrencyExchange
//
//  Created by Herman - Herman on 12/10/2022.
//

import Foundation
import CoreData

class DatabaseManager: NSObject {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ExchangeRateDB")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                debugPrint("Error when loading core data \(error), \(error.userInfo)")
            }
        })
        return container
    }()
        
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
               try context.save()
            } catch {
                let nserror = error as NSError
                debugPrint("Error when saving \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func insert(data: Data) {
        do {
            let decoder = JSONDecoder()
            decoder.userInfo[CodingUserInfoKey.context!] = persistentContainer.viewContext
            try decoder.decode([Currency].self, from: data)
            saveContext()
        } catch {
            debugPrint("Error when inserting")
        }
    }
    
    func updateRate(code:String, rate:Double){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Currency.entityName())
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "code = %@", code)
        do {
            let fetchResult = try persistentContainer.viewContext.fetch(request)
            if fetchResult.count > 0 {
                if let model:Currency = fetchResult.first as? Currency {
                    model.rate = rate
                    saveContext()
                }
            }
        } catch {
            debugPrint("Error when fetching")
        }
        
 
    }
    
    func fetch<T: Entity>(ofType: T.Type,
                          withPredicate predicate: NSPredicate? = nil) -> [T] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName())
        request.returnsObjectsAsFaults = false
        request.predicate = predicate

        var entities = [T]()
        do {
            let fetchResult = try persistentContainer.viewContext.fetch(request)
            
            for data in fetchResult {
                if let entity = data as? T {
                    entities.append(entity)
                }
            }
        } catch {
            debugPrint("Error when fetching")
        }
        
        return entities
    }
}


