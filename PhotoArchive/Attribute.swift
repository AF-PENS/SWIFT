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
    var answer = "default"
    
    init(id: String, answer: String) {
        self.id = id
        self.answer = answer
    }
}
