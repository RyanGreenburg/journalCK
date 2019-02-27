//
//  EntryController.swift
//  JournalCK
//
//  Created by RYAN GREENBURG on 2/25/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import Foundation
import CloudKit

class EntryController {
    
    // Shared instance
    static let shared = EntryController()
    
    // Source of truth
    var entries: [Entry] = []
    
    // Database
    let privateDB = CKContainer.default().privateCloudDatabase
    
    // MARK: - CRUD
    
    // Create
    func createEntry(withTitle title: String, body: String, completion: @escaping (Bool) -> Void) {
        let newEntry = Entry(title: title, body: body)
        let entryAsRecord = CKRecord(entry: newEntry)
        privateDB.save(entryAsRecord) { (record, error) in
            if let error = error {
                print("Error saving entry to private database \(error.localizedDescription)")
                completion(false)
                return
            }
            if let record = record,
                let returnEntry = Entry(record: record) {
                self.entries.append(returnEntry)
            }
            completion(true)
        }
    }
    
    // Read
    func fetchEntries(completion: @escaping (Bool) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: Entry.entryKey, predicate: predicate)
        privateDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error fetching entries from private database \(error.localizedDescription)")
                completion(false)
                return
            }
            guard let records = records else { return }
            let entries = records.compactMap({Entry(record: $0)})
            self.entries = entries
            completion(true)
        }
    }
    
    // Update
    func save(entry: Entry, completion: @escaping (Bool) -> Void) {
        let entryAsRecord = CKRecord(entry: entry)
        privateDB.save(entryAsRecord) { (record, error) in
            if let error = error {
                print("Error updating entry record \(error.localizedDescription)")
                completion(false)
                return
            }
            if let record = record,
                let returnEntry = Entry(record: record) {
                self.entries.append(returnEntry)
            }
        }
    }
    
    // Delete

}
