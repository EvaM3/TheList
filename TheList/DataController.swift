//
//  DataController.swift
//  TheList
//
//  Created by Eva Madarasz on 18/03/2022.
//


import CoreData

class CoreDataManager {
    
    var entityArray = ViewController.ListEntityUI.self

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ListModel")
        
        container.loadPersistentStores(completionHandler: { (NSPersistentStoreDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error)")
            }
        })
        return container
    }()
    
    
    func saveData() {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func loadData() -> [ListEntity] {
        let request : NSFetchRequest<ListEntity> = ListEntity.fetchRequest()
        
        do {
             return try persistentContainer.viewContext.fetch(request)
        } catch {
            print("Error loading data \(error)")
            return []
        }
    }
    
    func deleteData(item: ListEntity) {
        persistentContainer.viewContext.delete(item)
        
        do {
            try persistentContainer.viewContext.save()
            self.saveData()
        }
        catch {
            // Something went wrong, its an error :-(
        }
    }
    
}







