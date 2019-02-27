//
//  EntryDetailViewController.swift
//  JournalCK
//
//  Created by RYAN GREENBURG on 2/25/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController, UITextFieldDelegate {
    
    var entry: Entry?
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        return formatter
    }

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        updateViews()
    }
    
    func updateViews() {
        guard let entry = entry else { return }
        titleTextField.text = entry.title
        bodyTextView.text = entry.body
        self.title = dateFormatter.string(from: entry.timestamp)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        bodyTextView.text = ""
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty,
            let body = bodyTextView.text, !body.isEmpty else { return }
        
        EntryController.shared.createEntry(withTitle: title, body: body) { (success) in
            if success {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
