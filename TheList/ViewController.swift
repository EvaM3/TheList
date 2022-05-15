//
//  ViewController.swift
//  TheList
//
//  Created by Eva Madarasz on 15/03/2022.
//

import UIKit
import CoreData


struct ListEntityUI {
    var title: String
    var isCompleted: Bool?
    var creationDate: Date?
    var achievedDate: Date?
    
}
extension ListEntityUI {
    init(mapListEntityUI : ListEntity) {
        self.title = mapListEntityUI.title ?? ""
        self.isCompleted = mapListEntityUI.isCompleted
        self.achievedDate = mapListEntityUI.achievedDate
        self.creationDate = mapListEntityUI.creationDate
    }
}

class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    
    
    
    let coreDataManager = CoreDataManager()
    var listEntityArray = [ListEntityUI]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        loadData()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listEntityArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        let item = listEntityArray[indexPath.row]
        cell.textLabel?.text = item.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.present(changeCancelAndEditTasks(indexPath: indexPath), animated: true)
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new task", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add task", style: .default) { (action) in
            let newTask = ListEntityUI(title: textField.text ?? "", isCompleted: false, creationDate: Date(), achievedDate: nil)
            self.coreDataManager.addItem(item: newTask)
            self.loadData()
            
        }
        
        alert.addAction(action)
        alert.addTextField { (alertTextField) in alertTextField.placeholder = "New task here"
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func updateTasks(indexPath: IndexPath) -> UIAlertController {
        let item = listEntityArray[indexPath.row]
        var textField = UITextField()
        let alert = UIAlertController(title: "Update task", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Update your task", style: .default, handler: { _ in
            self.coreDataManager.updateData(at: indexPath.row , title: textField.text ?? "")
            self.loadData()
        }))
        
        
        alert.addTextField { (alertTextField) in alertTextField.placeholder = "New task here"
            textField = alertTextField
        }
        alert.textFields?.first?.text = item.title
        return alert
    }
    
    func changeCancelAndEditTasks(indexPath: IndexPath) -> UIAlertController {
        let sheet = UIAlertController(title: "Change task", message: nil, preferredStyle: .alert)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
            self.present(self.updateTasks(indexPath: indexPath), animated: true)
        } ))
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.coreDataManager.deleteData(at: indexPath.row)
            self.loadData()
        }))
        
        return sheet
    }
    
    
    func map(item: ListEntity) -> ListEntityUI {
        
        let newListEntity = ListEntityUI(mapListEntityUI: item)
        return newListEntity
    }
    
    func loadSortedData() {
        let todaysSortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        let sortDescriptors = [todaysSortDescriptor]
    
    }
    
    
    
    func loadData() {
        let pred =  NSPredicate(format: "title < %@","B")
        let filteredFetchResult = coreDataManager.loadData(predicate: pred)
        
       
        listEntityArray = []
        for item in filteredFetchResult {
            let newMap = map(item: item)
            listEntityArray.append(newMap)
            
        }
        tableView.reloadData()
    }
    
    func fetchForToday() {
        let startDate = Date()
        let pred =  NSPredicate(format: "creationDate >= %@", startDate as CVarArg)
        let filteredFetchResult = coreDataManager.loadData(predicate: pred)
       loadSortedData()
        
        tableView.reloadData()
    }
    
    func fetchForYesterday() {
        let pred =  NSPredicate(format: "creationDate < %@","Date")
        let filteredFetchResult = coreDataManager.loadData(predicate: pred)
        loadSortedData()
        tableView.reloadData()
    }
    
    
    func saveData() {
        coreDataManager.saveData()
        self.loadData()
        
    }
}
