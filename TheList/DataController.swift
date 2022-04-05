//
//  DataController.swift
//  TheList
//
//  Created by Eva Madarasz on 18/03/2022.
//

import UIKit
import CoreData



class CoreDataManager {

  let context = CoreDataManager.sharedManager.persistentContainer.viewContext
    var listEntityArray = [ListEntity]()
  static let sharedManager =  CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ListEntity")
        
        container.loadPersistentStores(completionHandler: { (NSPersistentStoreDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error)")
            }
        })
        return container
    }()
    
    
func saveData() {
    do {
        try context.save()
    } catch {
        print("Error saving context \(error)")
    }
    loadData()
}

func loadData() {
    let request : NSFetchRequest<ListEntity> = ListEntity.fetchRequest()
    
    do {
        listEntityArray = try context.fetch(request)
    } catch {
        print("Error loading data \(error)")
    }
    tableView.reloadData()
}

func deleteData(item: ListEntity) {
    context.delete(item)
    
    do {
        try context.save()
        self.saveData()
    }
    catch {
        // Something went wrong, its an error :-(
    }
}

}

// MARK: - Core Data stack

 var persistentContainer: NSPersistentContainer = {
    /*
     The persistent container for the application. This implementation
     creates and returns a container, having loaded the store for the
     application to it. This property is optional since there are legitimate
     error conditions that could cause the creation of the store to fail.
    */
    let container = NSPersistentContainer(name: "ListModel")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error as NSError? {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             
            /*
             Typical reasons for an error here include:
             * The parent directory does not exist, cannot be created, or disallows writing.
             * The persistent store is not accessible, due to permissions or data protection when the device is locked.
             * The device is out of space.
             * The store could not be migrated to the current model version.
             Check the error message to determine what the actual problem was.
             */
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    })
    return container
}()


// MARK: - Core Data Saving support

func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}

    
   


