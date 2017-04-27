//
//  Attribute.swift
//  PhotoArchive
//
//  Created by Phillip Gulegin on 4/19/17.
//  Copyright © 2017 Phillip Gulegin. All rights reserved.
//

import Foundation

class Attribute: NSObject, NSCoding {
    var id = "default"
    var question = "default"
    var value = "default"
    
    init(id: String, question: String, value: String) {
        self.id = id
        self.question = question
        self.value = value
    }
    
    // MARK: - NSCoding
    func encode(with coder: NSCoder) {
        coder.encode(self.id, forKey: "id")
        coder.encode(self.question, forKey: "question")
        coder.encode(self.value, forKey: "value")
    }
    
    required convenience init(coder decoder: NSCoder) {
        let id = decoder.decodeObject(forKey: "id") as? String
        let question = decoder.decodeObject(forKey: "question") as? String
        let value = decoder.decodeObject(forKey: "value") as? String
        self.init(id: id!, question: question!, value: value!)
    }
}
