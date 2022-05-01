//
//  DataController.swift
//  TheList
//
//  Created by Eva Madarasz on 18/03/2022.
//


import CoreData


class CoreDataManager {
    
    
    
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
    
    func loadData(predicate: NSPredicate? = nil) -> [ListEntity] {
        let request : NSFetchRequest<ListEntity> = ListEntity.fetchRequest()
        request.predicate = predicate
        do {
            return try persistentContainer.viewContext.fetch(request)
        } catch {
            print("Error loading data \(error)")
            return []
        }
    }
//
//    func loadDataForToday(predicate: NSPredicate?) -> [ListEntity] {
//        var now: Date { Date() }
//        let request : NSFetchRequest<ListEntity> = ListEntity.fetchRequest()
////        let predicate: NSPredicate? = NSPredicate(format: "now > %@")
//        request.predicate = predicate
//        if predicate == nil {
//
//        }
//        do {
//            return try persistentContainer.viewContext.fetch(request)
//        } catch {
//            print("Error loading data \(error)")
//            return []
//        }
//    }
//
    
    func addItem(item: ListEntityUI) {
        let newItem = ListEntity(context: persistentContainer.viewContext)
        newItem.title = item.title
        saveData()
    }
    
    func deleteData(at index: Int) {
        let loadedData = loadData()
        let selectedTask = loadedData[index]
        persistentContainer.viewContext.delete(selectedTask)
        self.saveData()
    }
    
    func updateData(at index: Int, title: String) {
        let loadedData = loadData()
        let selectedTask = loadedData[index]
        selectedTask.title = title
        
        self.saveData()
        
    }
    
}







