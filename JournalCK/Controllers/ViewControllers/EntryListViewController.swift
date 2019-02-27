//
//  EntryListViewController.swift
//  JournalCK
//
//  Created by RYAN GREENBURG on 2/25/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import UIKit

class EntryListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Date Formatter
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        return formatter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
    }
    
    func updateViews() {
        EntryController.shared.fetchEntries { (success) in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailViewSegue" {
            guard let selectedRow = tableView.indexPathForSelectedRow?.row else { return }
            let entry = EntryController.shared.entries[selectedRow]
            let destinationVC = segue.destination as? EntryDetailViewController
            destinationVC?.entry = entry
        }
    }
}

extension EntryListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EntryController.shared.entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)
        
        let entry = EntryController.shared.entries[indexPath.row]
        cell.textLabel?.text = entry.title
        cell.detailTextLabel?.text = dateFormatter.string(from: entry.timestamp)
        return cell
    }
}
