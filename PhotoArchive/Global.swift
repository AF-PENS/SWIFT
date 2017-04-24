//
//  Global.swift
//  PhotoArchive
//
//  Created by Phillip Gulegin on 4/19/17.
//  Copyright © 2017 Phillip Gulegin. All rights reserved.
//

import Foundation
import Photos

class globalObject {
    // Declare class instance property
    static let sharedInstance = globalObject()
    
    // Declare an initializer
    // Because this class is singleton only one instance of this class can be created
    init() {}
    
    // class variables
    var Attributes = [Context]()
    var GalleryImages = [PHAsset]()
}
