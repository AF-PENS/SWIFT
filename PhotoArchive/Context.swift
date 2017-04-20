//
//  Context.swift
//  PhotoArchive
//
//  Created by Phillip Gulegin on 4/19/17.
//  Copyright © 2017 Phillip Gulegin. All rights reserved.
//

import Foundation

class Context: NSObject {
    var id = "default"
    var attributes = [Attribute]()
    
    init(id: String) {
        self.id = id
    }
}
