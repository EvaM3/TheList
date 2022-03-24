//
//  ViewController.swift
//  TheList
//
//  Created by Eva Madarasz on 15/03/2022.
//

import UIKit
import CoreData



struct Task {
    
    var task: String
    var creationDate: Date
    var achievedDate: Date?
    var completed: Bool
    
    
}

class ViewController: UIViewController , UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        func viewWillAppear(_animated: Bool) {
            super.viewWillAppear(_animated)
            
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PersonEntity")
            
            do {
                people = try managedContext.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
        
        title = "The List"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    
    var people:[NSManagedObject] = []
    
    let managedContext = persistentContainer.viewContext
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let person = people[indexPath.row]
        let cell =
            tableView.dequeueReusableCell(withIdentifier: "Cell",
                                          for: indexPath)
        cell.textLabel?.text = person.value(forKey: "name") as? String
        return cell
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func addName(_ sender: Any) {
        
        
        let alert = UIAlertController(title: "New Name", message: "Add a new name", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            [unowned self] action in
            
            guard let textField = alert.textFields?.first,
                  let nameToSave = textField.text else {
                return
            }
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
        
        
        
        func getTheFullList() {
            do {
                let list = try managedContext.fetch(ListEntity.fetchRequest())
            } catch {
                print("Could not fetch. \(error)")
            }
        }
        
        
        func createList() {
            let newList = ListEntity(context: managedContext)
            newList.title = title
            newList.creationDate = Date()
            
            do {
                try managedContext.save()
            } catch {
                print("Could not save. \(error)")
            }
        }
        
        
        func saveList(title: ListEntity) {
            
            let entity = NSEntityDescription.entity(forEntityName: "PersonEntity", in: managedContext)!
            
            let person = NSManagedObject(entity: entity, insertInto: managedContext)
            
            person.setValue(title, forKey: "name")
            
            do {
                try managedContext.save()
                people.append(person)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        
        
        func deleteList(title: ListEntity) {
            managedContext.delete(title)
            
            do {
                try managedContext.save()
            } catch {
                print("Could not save. \(error)")
            }
        }
        
        
        func updateList(title: ListEntity, newName: String) {
            title.title = newName
            
            do {
                try managedContext.save()
            } catch {
                print("Could not save. \(error)")
            }
        }
    }
}
