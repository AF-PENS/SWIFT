//
//  CameraViewController.swift
//  PhotoArchive
//
//  Created by Phillip Gulegin on 1/26/17.
//  Copyright © 2017 Phillip Gulegin. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, FileManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let picker = UIImagePickerController()
    var tagButtonArray = [String]()
    var selectedTagContext = 0

    @IBOutlet weak var collectionView: UICollectionView!
    
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
        
        for context in 0..<globalObject.sharedInstance.cameraContexts.count {
            tagButtonArray.append(globalObject.sharedInstance.cameraContexts[context].id)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        // image saving
        var  image = UIImage()
        image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let jpegimage = UIImageJPEGRepresentation(image, 1)
        
        // saving image to 'Images' Directory
        let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        let date :NSDate = NSDate()
        
        let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "yyyy-MM-dd'_'HH:mm:ss"
        dateFormatter.dateFormat = "yyyy-MM-dd'_'HH_mm_ss"
        
        dateFormatter.timeZone = NSTimeZone(name: "GMT")! as TimeZone
        
        let imageURL = docDir.appendingPathComponent("\(dateFormatter.string(from: date as Date)).jpg")
        try! jpegimage?.write(to: imageURL)
        
        // executes if contexts are selected, then the image is also sent to the dashboard
        if globalObject.sharedInstance.cameraContexts.count != 0 {
            var uploadObjects = [UploadObject]()
            
            let temp = UploadObject(context: globalObject.sharedInstance.cameraContexts, imageLocalIdentifier: "\(dateFormatter.string(from: date as Date)).jpg", isAppImage: true, isGalleryImage: false)
            uploadObjects.append(temp)
            
            var values = [UploadObject]()
            
            if (PersistenceManager.loadNSArray(.UploadObjects) as? [UploadObject]) != nil {
                values = PersistenceManager.loadNSArray(.UploadObjects) as! [UploadObject]
            }
            
            for object in uploadObjects {
                values.append(object)
            }
            
            PersistenceManager.saveNSArray(values as NSArray, path: .UploadObjects)

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
