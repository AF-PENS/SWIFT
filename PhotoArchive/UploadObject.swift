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
//class UploadObject: NSObject {
    var context = [Context]()
    var imageLocalIdentifier: String
    var isAppImage: Bool
    var isGalleryImage: Bool
    
    init(context: [Context], imageLocalIdentifier: String, isAppImage: Bool, isGalleryImage: Bool) {
        for i in 0..<context.count {
            self.context.append(context[i])
        }
        self.imageLocalIdentifier = imageLocalIdentifier
        self.isAppImage = isAppImage
        self.isGalleryImage = isGalleryImage
    }
    
    func info() {
        print("identifier:     ", imageLocalIdentifier)
        print("isAppImage:     ", isAppImage)
        print("isGalleryImage: ", isGalleryImage)
    }
    
    // MARK: - NSCoding
    func encode(with coder: NSCoder) {
        coder.encode(self.context, forKey: "context")
        coder.encode(self.imageLocalIdentifier, forKey: "imageLocalIdentifier")
        coder.encode(self.isAppImage, forKey: "isAppImage")
        coder.encode(self.isGalleryImage, forKey: "isGalleryImage")
    }
    
    required convenience init(coder decoder: NSCoder) {
        let context                 = decoder.decodeObject(forKey: "context") as! [Context]
        let imageLocalIdentifier    = decoder.decodeObject(forKey: "imageLocalIdentifier") as? String
        let isAppImage              = decoder.decodeBool(forKey: "isAppImage")
        let isGalleryImage          = decoder.decodeBool(forKey: "isGalleryImage")

//        let isAppImage              = decoder.decodeObject(forKey: "isAppImage") as! Bool
//        let isGalleryImage          = decoder.decodeObject(forKey: "isGalleryImage") as! Bool
        
        self.init(context: context, imageLocalIdentifier: imageLocalIdentifier!, isAppImage: isAppImage, isGalleryImage: isGalleryImage)
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
