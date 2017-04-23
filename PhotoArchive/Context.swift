//
//  Context.swift
//  PhotoArchive
//
//  Created by Phillip Gulegin on 4/19/17.
//  Copyright © 2017 Phillip Gulegin. All rights reserved.
//

import Foundation

class Context: NSObject {
    var attributes = [Attribute]()
    
    var id: String;
    var descriptor = "descriptor";
    
    init(id: String){
        self.id = id;
    }
    
    init(id: String, descriptor: String){
        self.id = id;
        self.descriptor = descriptor;
    }
}
