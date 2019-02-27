//
//  Entry.swift
//  JournalCK
//
//  Created by RYAN GREENBURG on 2/25/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import Foundation
import CloudKit

class Entry {
    
    static let entryKey = "Entry"
    fileprivate static let titleKey = "title"
    fileprivate static let bodyKey = "body"
    fileprivate static let timestampKey = "timestamp"
    fileprivate static let recordKey = "recordID"
    
    let title: String
    let body: String
    let timestamp: Date
    let recordID: CKRecord.ID
    
    init(title: String, body: String, timestamp: Date = Date(), recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.title = title
        self.body = body
        self.timestamp = timestamp
        self.recordID = recordID
    }
    
    init?(record: CKRecord) {
        guard let title = record[Entry.titleKey] as? String,
            let body = record[Entry.bodyKey] as? String,
            let timestamp = record[Entry.timestampKey] as? Date else { return nil }
        
        self.title = title
        self.body = body
        self.timestamp = timestamp
        self.recordID = record.recordID
    }
}

extension CKRecord {
    convenience init(entry: Entry) {
        self.init(recordType: Entry.entryKey)
        self.setValue(entry.title, forKey: Entry.titleKey)
        self.setValue(entry.body, forKey: Entry.bodyKey)
        self.setValue(entry.timestamp, forKey: Entry.timestampKey)
    }
}
