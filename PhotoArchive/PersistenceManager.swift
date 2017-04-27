//
//  PersistenceManager.swift
//  PhotoArchive
//
//  Created by Phillip Gulegin on 4/24/17.
//  Copyright © 2017 Phillip Gulegin. All rights reserved.
//

import Foundation

enum Path: String {
    case UploadObjects = "UploadObjects"
}

class PersistenceManager {
    class fileprivate func documentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectory = paths[0] as String
        return documentDirectory as NSString
    }
    
    class func saveNSArray(_ arrayToSave: NSArray, path: Path) {
        let file = documentsDirectory().appendingPathComponent(path.rawValue)
        NSKeyedArchiver.archiveRootObject(arrayToSave, toFile: file)
    }
    
    class func loadNSArray(_ path: Path) -> NSArray? {
        let file = documentsDirectory().appendingPathComponent(path.rawValue)
        let result = NSKeyedUnarchiver.unarchiveObject(withFile: file)
        return result as? NSArray
    }
}
