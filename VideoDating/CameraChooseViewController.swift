//
//  CameraChooseViewController.swift
//  VideoDating
//
//  Created by Kyle Brooks Robinson on 7/19/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

import UIKit

class CameraChooseViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let imagePick = UIImagePickerController()
    
    var timeyNumber = Int(NSDate().timeIntervalSince1970)
    var resizedImage: UIImage?
    var loadingFromId: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        if loadingFromID != nil {
//            
//            RailsRequest.session().
//            
//        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func takePicturePressed(sender: AnyObject) {
        
        imagePick.allowsEditing = false
        imagePick.sourceType = .Camera
        imagePick.delegate = self
        imagePick.showsCameraControls = true
        
        presentViewController(imagePick, animated: true, completion: nil)
        
    }

    @IBAction func choosePressed(sender: AnyObject) {
        
        imagePick.allowsEditing = false
        imagePick.sourceType = .PhotoLibrary
        imagePick.delegate = self
        
        presentViewController(imagePick, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let profilePic = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        if loadingFromId == nil {
            
            let profilePicEndpoint = "profilepic_TakenBy\(RailsRequest.session().userId!).png"
            
            resizeImage(profilePic, completion: { () -> Void in
                
                RecordedVideo.session().profilePicture = self.resizedImage!
                RecordedVideo.session().profilePictureLink = profilePicEndpoint
                
                self.dismissViewControllerAnimated(true, completion: nil)
                
            })
            
        } else {
            
            let profilePicEndpoint = "profilepic_TakenBy\(RailsRequest.session().userId!).png"
            
            resizeImage(profilePic, completion: { () -> Void in
                
                RailsRequest.session().createAvatar(self.loadingFromId!, avatarEndpoint: RecordedVideo.session().profilePictureLink!, completion: { () -> Void in
                    
                    S3Request.session().saveAvatarToS3(self.resizedImage!, avatarEndpoint: profilePicEndpoint, completion: { () -> Void in
                        
                        
                    })
                    
                    self.dismissViewControllerAnimated(true, completion: nil)

                    
                })
                
            })
            
        }
        
    }
    
    func cropToSquare(originalImage: UIImage) -> UIImage {
        
        let contextImage: UIImage = UIImage(CGImage: originalImage.CGImage)!
        let contextSize: CGSize = contextImage.size
        
        let posX: CGFloat
        let posY: CGFloat
        let width: CGFloat
        let height: CGFloat
        
        if contextSize.width > contextSize.height {
            
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            width = contextSize.height
            height = contextSize.height
            
        } else {
            
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            width = contextSize.width
            height = contextSize.width
            
        }
        
        let rect: CGRect = CGRectMake(posX, posY, width, height)
        
        let imageRef: CGImageRef = CGImageCreateWithImageInRect(contextImage.CGImage, rect)
        let image: UIImage = UIImage(CGImage: imageRef, scale: originalImage.scale, orientation: originalImage.imageOrientation)!
        
        return image
        
    }
    
    func resizeImage(imageToResize: UIImage, completion: () -> Void) {
        
        var newImage: UIImage = cropToSquare(imageToResize)
        
        var newSize = CGSize(width: 480,height: 480)
        var scaleImageRect = CGRectMake(0,0, 480, 480)
        
        UIGraphicsBeginImageContext(newSize)
        
        newImage.drawInRect(scaleImageRect)
        resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        completion()
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        self.imagePick.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
    
        dismissViewControllerAnimated(true, completion: nil)
    
    }

}
