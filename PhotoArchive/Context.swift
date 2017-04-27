//
//  Context.swift
//  PhotoArchive
//
//  Created by Phillip Gulegin on 4/19/17.
//  Copyright © 2017 Phillip Gulegin. All rights reserved.
//

import Foundation

class Context: NSObject, NSCoding {
    var attributes = [Attribute]()
    
    var id: String
    var descriptor = "descriptor"
    
    init(id: String){
        self.id = id
    }
    
    init(id: String, descriptor: String){
        self.id = id
        self.descriptor = descriptor
    }
    
    init(id: String, descriptor: String, attributes: [Attribute]){
        self.id = id
        self.descriptor = descriptor
        self.attributes = attributes
        
    }
    
    // MARK: - NSCoding
    func encode(with coder: NSCoder) {
        coder.encode(self.attributes, forKey: "attributes")
        coder.encode(self.id, forKey: "id")
        coder.encode(self.descriptor, forKey: "descriptor")
    }
    
    required convenience init(coder decoder: NSCoder) {
        var attributes = decoder.decodeObject(forKey: "attributes") as? [Attribute]
        let id = decoder.decodeObject(forKey: "id") as? String
        let descriptor = decoder.decodeObject(forKey: "descriptor") as? String
        
//        if attributes == nil {
//            attributes = [Attribute]()
//        }
        
        self.init(id: id!, descriptor: descriptor!, attributes: attributes!)
    }
}
