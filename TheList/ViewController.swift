//
//  ViewController.swift
//  TheList
//
//  Created by Eva Madarasz on 15/03/2022.
//

import UIKit




class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
   
    
    let context = CoreDataManager.sharedManager.persistentContainer.viewContext
    
    var listEntityArray = [ListEntity]()
    @IBOutlet weak var tableView: UITableView!
       
    override func viewDidLoad() {
        loadData()
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
        var textField = UITextField()
        let alert = UIAlertController(title: "Change task", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Update task", style: .default) { (action) in
            self.listEntityArray[indexPath.row].setValue(textField.text, forKey: "title")
            self.saveData()
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in alertTextField.placeholder = "New task here"
            textField = alertTextField
        }
        
      present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new task", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add task", style: .default) { (action) in
            let newTask = ListEntity(context: self.context)
            newTask.title = textField.text
            
            self.listEntityArray.append(newTask)
            self.saveData()
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in alertTextField.placeholder = "New task here"
            textField = alertTextField
        }
        
      present(alert, animated: true, completion: nil)
        
    }
    
    
}
