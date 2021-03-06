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
    var imageLocation: String
    var thumbnailLocation: String
    var latitude: Double
    var longitude: Double
    var contexts = [Context]()
    
    init(imageName: String, imageLocation: String, thumbnailLocation: String, latitude: Double, longitude: Double, contexts: [Context]) {
        self.imageName = imageName
        self.imageLocation = imageLocation
        self.thumbnailLocation = thumbnailLocation
        self.latitude = latitude
        self.longitude = longitude
        self.contexts = contexts
    }
    
    func info() {
        print("imageName: ", imageName)
        print("imageLocation: ", imageLocation)
        print("thumbnailLocation: ", thumbnailLocation)
        print("latitude:  ", latitude)
        print("longitude: ", longitude)
        print("contexts:  ", contexts)
    }
    
    // MARK: - NSCoding
    func encode(with coder: NSCoder) {
        coder.encode(self.imageName, forKey: "imageName")
        coder.encode(self.imageLocation, forKey: "imageLocation")
        coder.encode(self.thumbnailLocation, forKey: "thumbnailLocation")
        coder.encode(self.latitude, forKey: "latitude")
        coder.encode(self.longitude, forKey: "longitude")
        coder.encode(self.contexts, forKey: "contexts")
    }
    
    required convenience init(coder decoder: NSCoder) {
        let imageName = decoder.decodeObject(forKey: "imageName") as! String
        let imageLocation = decoder.decodeObject(forKey: "imageLocation") as! String
        let thumbnailLocation = decoder.decodeObject(forKey: "thumbnailLocation") as! String
        let latitude = decoder.decodeDouble(forKey: "latitude")
        let longitude = decoder.decodeDouble(forKey: "longitude")
        let contexts = decoder.decodeObject(forKey: "contexts") as! [Context]
        self.init(imageName: imageName, imageLocation: imageLocation, thumbnailLocation: thumbnailLocation, latitude: latitude, longitude: longitude, contexts: contexts)
    }
}
