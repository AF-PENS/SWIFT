//
//  CameraObject.swift
//  PhotoArchive
//
//  Created by Phillip Gulegin on 4/24/17.
//  Copyright © 2017 Phillip Gulegin. All rights reserved.
//

import Foundation
import Photos

class CameraObject: NSObject, NSCoding {
    
    // Object variable
    var imageName: String           // name of the image
    var imageLocation: String       // location of full resolution image
    var thumbnailLocation: String   // location of thumbnail image
    var latitude: Double            // latitude of where image was taken
    var longitude: Double           // longitude of where image was taken
    
    init(imageName: String, imageLocation: String, thumbnailLocation: String, latitude: Double, longitude: Double) {
        self.imageName = imageName
        self.imageLocation = imageLocation
        self.thumbnailLocation = thumbnailLocation
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func info() {
        print("imageName:         ", imageName)
        print("imageLocation:     ", imageLocation)
        print("thumbnailLocation: ", thumbnailLocation)
        print("latitude:          ", latitude)
        print("longitude:         ", longitude)
    }
    
    // MARK: - NSCoding
    func encode(with coder: NSCoder) {
        coder.encode(self.imageName, forKey: "imageName")
        coder.encode(self.imageLocation, forKey: "imageLocation")
        coder.encode(self.thumbnailLocation, forKey: "thumbnailLocation")
        coder.encode(self.latitude, forKey: "latitude")
        coder.encode(self.longitude, forKey: "longitude")
    }
    
    required convenience init(coder decoder: NSCoder) {
        let imageName = decoder.decodeObject(forKey: "imageName") as! String
        let imageLocation = decoder.decodeObject(forKey: "imageLocation") as! String
        let thumbnailLocation = decoder.decodeObject(forKey: "thumbnailLocation") as! String
        let latitude = decoder.decodeDouble(forKey: "latitude")
        let longitude = decoder.decodeDouble(forKey: "longitude")
        self.init(imageName: imageName, imageLocation: imageLocation, thumbnailLocation: thumbnailLocation, latitude: latitude, longitude: longitude)
    }
}
