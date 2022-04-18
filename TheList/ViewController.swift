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
        let item = listEntityArray[indexPath.row]
        var textField = UITextField()
        let sheet = UIAlertController(title: "Change task", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
        } ))
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
          //  self.coreDataManager.deleteData(item: )
        }))
        let action = UIAlertAction(title: "Update task", style: .default) { (action) in
            let newTask = ListEntityUI(title: textField.text ?? "", isCompleted: false, creationDate: Date(), achievedDate: Date())
            self.coreDataManager.addItem(item: newTask)
            self.loadData()
//            let changedTask = ListEntityUI(title: textField.text ?? "", isCompleted: false, creationDate: Date(), achievedDate: Date())
//            self.listEntityArray[indexPath.row].title = textField.text ?? ""
//            self.loadData()
        }
        
        sheet.addAction(action)
        sheet.addTextField { (alertTextField) in alertTextField.placeholder = "New task here"
            textField = alertTextField
        }
        
        present(sheet, animated: true, completion: nil)
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new task", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add task", style: .default) { (action) in
            let newTask = ListEntityUI(title: textField.text ?? "", isCompleted: false, creationDate: Date(), achievedDate: Date())
            self.coreDataManager.addItem(item: newTask)
            self.loadData()
            
        }
        
        alert.addAction(action)
        alert.addTextField { (alertTextField) in alertTextField.placeholder = "New task here"
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    func map(item: ListEntity) -> ListEntityUI {
        
        let newListEntity = ListEntityUI(mapListEntityUI: item)
        return newListEntity
        
    }
    
    
    func loadData(){
        listEntityArray = []
        for item in coreDataManager.loadData() {
            let newMap = map(item: item)
            listEntityArray.append(newMap)
            
        }
        tableView.reloadData()
    }
    
    
    func saveData() {
        coreDataManager.saveData()
        self.loadData()
        
    }
    
}
