//
//  CameraViewController.swift
//  PhotoArchive
//
//  Created by Phillip Gulegin on 1/26/17.
//  Copyright © 2017 Phillip Gulegin. All rights reserved.
//

import UIKit
import ImageIO
import CoreLocation

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, FileManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate {
    
    let picker = UIImagePickerController()
    var tagButtonArray = [String]()
    var selectedTagContext = 0

    @IBOutlet weak var collectionView: UICollectionView!
    
    let locationManager = CLLocationManager()
    var startLocation: CLLocation!
    var latestLocation: CLLocation!
    
    // prepares for a segue transition from the Attribute pages
    @IBAction func unwindToCameraViewController(segue:UIStoryboardSegue) { }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false

        // Do any additional setup after loading the view.
        picker.delegate = self
        
        // Collection view for context buttons
        collectionView.delegate = self
        collectionView.dataSource = self
//        self.view.addSubview(collectionView)
        generateContextButtons()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        startLocation = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openCameraButton(_ sender: Any) {
        if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true, completion: nil)
        }
    }
    
    // Hides the navigation controller
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
        super.viewWillDisappear(animated)
    }
    
    // Hides the navigation controller
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        generateContextButtons()
        collectionView.reloadData()
    }
    
    // Generates the buttons which contain the newly added contexts
    func generateContextButtons() {
        
        // Clears out the elements in tagButtonArray in order to not create duplicates
        tagButtonArray.removeAll()
        
        for context in 0..<global.shared.cameraContexts.count {
            tagButtonArray.append(global.shared.cameraContexts[context].id)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        // image saving
        var  image = UIImage()
        image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let jpegimage = UIImageJPEGRepresentation(image, 1)
        
        let d = Date()
        let df = DateFormatter()
        df.dateFormat = "y-MM-dd-H-m-ss-SSSS"
        let name = df.string(from: d)
        
        // Establish FileManager object
        let fileMngr = FileManager.default
        
        // Establish path to 'Documents'
        let docURL = fileMngr.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        // Establish URL for 'CameraImages' in 'Documents'
        let cameraImagesURL = docURL.appendingPathComponent("CameraImages")
        
        // Establish URL for 'FullImage' in 'CameraImages'
        let cameraFullImageDirectoryURL = cameraImagesURL.appendingPathComponent("FullImage")
        
        // Establish URL for the file in 'FullImage'
        let cameraFullImageFileURL = cameraFullImageDirectoryURL.appendingPathComponent("\(name).jpg")
        
        // Establish URL for 'FullImage' in 'CameraImages'
        let cameraThumbnaileDirectoryURL = cameraImagesURL.appendingPathComponent("Thumbnail")
        
        // Establish URL for the file in 'FullImage'
        let cameraThumbnailFileURL = cameraThumbnaileDirectoryURL.appendingPathComponent("\(name).jpg")
        
        let cameraFullImageFilePath = "CameraImages/FullImage/\(name).jpg"
        
        let cameraThumbnailFilePath = "CameraImages/Thumbnail/\(name).jpg"
        

        try! jpegimage?.write(to: cameraFullImageFileURL)
        
        let size = image.size
        
        let thumbnailSize = CGSize(width: 256,height: 256)
        
        let widthRatio  = thumbnailSize.width  / image.size.width
        let heightRatio = thumbnailSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let jpegimagethumbnail = UIImageJPEGRepresentation(newImage!, 1)
        
        try! jpegimagethumbnail?.write(to: cameraThumbnailFileURL)
        
        let latitude = latestLocation.coordinate.latitude
        
        let longitude = latestLocation.coordinate.longitude
        
        var cameraObjects = [CameraObject]()
        
        if (PersistenceManager.loadNSArray(.CameraObjects) as? [CameraObject]) != nil {
            cameraObjects = PersistenceManager.loadNSArray(.CameraObjects) as! [CameraObject]
        }
        
        cameraObjects.append(CameraObject(imageName: name, imageLocation: cameraFullImageFilePath, thumbnailLocation: cameraThumbnailFilePath, latitude: latitude, longitude: longitude))
        
        PersistenceManager.saveNSArray(cameraObjects as NSArray, path: .CameraObjects)


        
        // executes if contexts are selected, then the image is also sent to the dashboard
        if global.shared.cameraContexts.count != 0 {
            var uploadObjects = [UploadObject]()
            
            if (PersistenceManager.loadNSArray(.UploadObjects) as? [UploadObject]) != nil {
                uploadObjects = PersistenceManager.loadNSArray(.UploadObjects) as! [UploadObject]
            }
            
            // Gets the current date
            let date = Date()
            
            // Creates a date format
            let dateFormat = DateFormatter()
            
            // Sets up the date format
            dateFormat.dateFormat = "y-MM-dd-H-m-ss-SSSS"
            
            // Creates a name from the date format
            let name = dateFormat.string(from: date)

            // Establish URL for 'UploadImages' in 'Documents'
            let uploadImagesURL = docURL.appendingPathComponent("UploadImages")
            
            // Establish URL for 'FullImage' in 'UploadImages'
            let uploadFullImageDirectoryURL = uploadImagesURL.appendingPathComponent("FullImage")
            
            // Establish URL for the file in 'FullImage'
            let uploadFullImageFileURL = uploadFullImageDirectoryURL.appendingPathComponent("\(name).jpg")
            
            // Establish URL for 'FullImage' in 'UploadImages'
            let uploadThumbnaileDirectoryURL = uploadImagesURL.appendingPathComponent("Thumbnail")
            
            // Establish URL for the file in 'FullImage'
            let uploadThumbnailFileURL = uploadThumbnaileDirectoryURL.appendingPathComponent("\(name).jpg")
            
            // Establish string path for full resolution image in uploadObject
            let uploadFullImageFilePath = "UploadImages/FullImage/\(name).jpg"
            
            // Establish string path for thumbnail image in uploadObject
            let uploadThumbnailFilePath = "UploadImages/Thumbnail/\(name).jpg"
            
            // Write the full resolution image to file
            try! jpegimage?.write(to: uploadFullImageFileURL)
            
            // Write the thumbnail image to file
            try! jpegimagethumbnail?.write(to: uploadThumbnailFileURL)
            
            // Create the new UploadObject and append it to the array
            uploadObjects.append(UploadObject(
                imageName:          name,
                imageLocation:      uploadFullImageFilePath,
                thumbnailLocation:  uploadThumbnailFilePath,
                latitude:           latitude,
                longitude:          longitude,
                contexts:           global.shared.cameraContexts))
            
            PersistenceManager.saveNSArray(uploadObjects as NSArray, path: .UploadObjects)

        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return tagButtonArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CameraCollectionViewCell", for: indexPath as IndexPath) as! CameraCollectionViewCell
        
        cell.title.text = tagButtonArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // resizes the tag context cell based on the lenght of the name of the context
        let label =  UILabel()
        label.numberOfLines = 0
        label.text = tagButtonArray[indexPath.row]
        label.sizeToFit()
        return CGSize(width: label.frame.width+10, height: label.frame.height)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("There was an error with location services.")
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        latestLocation = locations[locations.count - 1]
    }
    
//    // gets the selected item to pass
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        
//        let currentCell = collectionView.cellForItem(at: indexPath) as! CameraCollectionViewCell
//        selectedTagContext = indexPath.row
//        
//        performSegue(withIdentifier: "TaggingSelectedContextsAttributesSegue", sender: self)
//        
//    }
//    
//    // prepares a segue to send data to the next view controller
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "TaggingSelectedContextsAttributesSegue" {
//            let vc = segue.destination as! TaggingSelectedContextsAttributesTableViewController
//            vc.context = selectedTagContext
//        }
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
