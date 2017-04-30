//
//  UploadObject.swift
//  PhotoArchive
//
//  Created by Phillip Gulegin on 4/24/17.
//  Copyright © 2017 Phillip Gulegin. All rights reserved.
//

import Foundation
import Photos

class UploadObject: NSObject, NSCoding {
    
    var imageName: String
    var latitude: Double
    var longitude: Double
    var contexts = [Context]()
    
    init(imageName: String, latitude: Double, longitude: Double, contexts: [Context]) {
        self.imageName = imageName
        self.latitude = latitude
        self.longitude = longitude
        self.contexts = contexts
    }
    
    func info() {
        print("imageName: ", imageName)
        print("latitude:  ", latitude)
        print("longitude: ", longitude)
        print("contexts:  ", contexts)
    }
    
    // MARK: - NSCoding
    func encode(with coder: NSCoder) {
        coder.encode(self.imageName, forKey: "imageName")
        coder.encode(self.latitude, forKey: "latitude")
        coder.encode(self.longitude, forKey: "longitude")
        coder.encode(self.contexts, forKey: "contexts")
    }
    
    required convenience init(coder decoder: NSCoder) {
        let imageName = decoder.decodeObject(forKey: "imageName") as! String
        let latitude = decoder.decodeDouble(forKey: "latitude")
        let longitude = decoder.decodeDouble(forKey: "longitude")
        let contexts = decoder.decodeObject(forKey: "contexts") as! [Context]
        self.init(imageName: imageName, latitude: latitude, longitude: longitude, contexts: contexts)
    }
}



//func encodeWithCoder(aCoder: NSCoder) {
//    aCoder.encodeObject(self.symbol, forKey: "symbol")
//    aCoder.encodeObject(self.ask, forKey: "ask")
//    aCoder.encodeObject(self.yearHigh, forKey: "yearHigh")
//    aCoder.encodeObject(self.yearLow, forKey: "yearLow")
//    aCoder.encodeObject(self.timeSaved, forKey: "timeSaved")
//}
//Then to decode the object we can use decodeObjectForKey::
//
//required convenience init?(coder aDecoder: NSCoder) {
//    let symbol = aDecoder.decodeObjectForKey("symbol") as? String
//    let ask = aDecoder.decodeObjectForKey("ask") as? String
//    let yearHigh = aDecoder.decodeObjectForKey("yearHigh") as? String
//    let yearLow = aDecoder.decodeObjectForKey("yearLow") as? String
//    let timeSaved = aDecoder.decodeObjectForKey("timeSaved") as? NSDate
//    // TODO: create object from decode values
//}
