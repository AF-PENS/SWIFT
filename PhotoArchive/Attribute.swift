//
//  Attribute.swift
//  PhotoArchive
//
//  Created by Phillip Gulegin on 4/19/17.
//  Copyright © 2017 Phillip Gulegin. All rights reserved.
//

import Foundation

class Attribute: NSObject {
    var id = "default"
    var question = "default"
    var value = "default"
    
    init(id: String, question: String, value: String) {
        self.id = id
        self.question = question
        self.value = value
    }
}
