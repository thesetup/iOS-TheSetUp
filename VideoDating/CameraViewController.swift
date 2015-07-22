//
//  CameraViewController.swift
//  VideoDating
//
//  Created by Kyle Brooks Robinson on 7/15/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let camera = UIImagePickerController()
    
    var resizedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        camera.sourceType = .Camera
        camera.delegate = self
        camera.showsCameraControls = true
        
        self.view.addSubview(camera.view)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let profilePic = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let profilePicEndpoint = "profilepic_TakenBy\(RailsRequest.session().userId!).png"

        resizeImage(profilePic, completion: { () -> Void in
            
            RecordedVideo.session().profilePicture = self.resizedImage!
            RecordedVideo.session().profilePictureLink = profilePicEndpoint
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        })
        
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
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
