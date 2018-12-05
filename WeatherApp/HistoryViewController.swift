//
//  HistoryViewController.swift
//  WeatherApp
//
//  Created by Evgenia Galetskaya on 12/4/18.
//  Copyright © 2018 Evgenia Galetskaya. All rights reserved.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak private var tableView: UITableView!
    
    private var requests = [WeatherDataEntity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadRequests()
    }
    
    private func loadRequests() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<WeatherDataEntity>(entityName: "WeatherDataEntity")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            requests = try context.fetch(fetchRequest)
        }
        catch let error as NSError {
            print("Could not fetch. \(error),\(error.userInfo)")
        }
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = requests[indexPath.row].date!.toString() + ", " + requests[indexPath.row].temperature.toString()
        
        cell.detailTextLabel?.text = requests[indexPath.row].address
        return cell
    }

}

extension Double {
    
    func toString() -> String {
        return String(format: "%.f", self) + "℃"
    }
}

extension Date {
    
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter.string(from: self)
    }
}
