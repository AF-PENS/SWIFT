//
//  Global.swift
//  PhotoArchive
//
//  Created by Phillip Gulegin on 4/19/17.
//  Copyright © 2017 Phillip Gulegin. All rights reserved.
//

import Foundation
import Photos

class global {
    // Declare class instance property
    static let shared = global()
    
    // Declare an initializer
    // Because this class is singleton only one instance of this class can be created
    init() {
        
    }
    
    // class variables
    var tagContexts = [Context]()
    var galleryImages = [PHAsset]()
    var appImages = [CameraObject]()
    var cameraContexts = [Context]()
    
    
    //global vars
    var dbContexts = [Context]();
    var dbAttributes = [Attribute]();
}
