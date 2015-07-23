//
//  S3Request.swift
//  VideoDating
//
//  Created by Kyle Brooks Robinson on 7/3/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

import UIKit
import AmazonS3RequestManager
import AFNetworking
import AFAmazonS3Manager

private let defaults = NSUserDefaults.standardUserDefaults()
private let _singleton = S3Request()

let S3_URL = "https://s3.amazonaws.com/videodatingbucket/"

let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String

class S3Request: NSObject {
    
    class func session() -> S3Request { return _singleton }
    
    let s3Manager = AFAmazonS3Manager(accessKeyID: accessKey, secret: secret)
    
    var newURL: String?
    var videoURL: String?
    var thumbnail: UIImage?
    
    var timeyNumber = Int(NSDate().timeIntervalSince1970)
    
    func saveAvatarToS3(avatarImage: UIImage, avatarEndpoint: String, completion: () -> Void) {
        
        s3Manager.requestSerializer.bucket = bucket
        s3Manager.requestSerializer.region = AFAmazonS3USStandardRegion
        
        if let documentPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first as? String {
            
            // This is where my avatar will be located.
            let avatarPath = documentPath.stringByAppendingPathComponent(avatarEndpoint)
            
            // This writes the avatar to the avatarPath.
            let imageData = UIImagePNGRepresentation(avatarImage)
            imageData.writeToFile(avatarPath, atomically: false)
            let imageURL = NSURL(fileURLWithPath: avatarPath)
            
            // Avatar
            s3Manager.putObjectWithFile(avatarPath, destinationPath: avatarEndpoint, parameters: nil, progress: { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) -> Void in
                
                let percentageWritten = (CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite) * 100.0)
                
                println("Avatar Uploaded \(percentageWritten)%")
                
                }, success: { (responseObject) -> Void in
                    
                    let avatarInfo = responseObject as! AFAmazonS3ResponseObject
                    
                    self.newURL = avatarInfo.URL.absoluteString
                    print(self.newURL)
                    
                    
                }, failure: { (error) -> Void in
                    
                    println("\(error)")
                    
                completion()
                    
            })
            
        }
        
    }
    
    func saveVideoToS3(thumbnailImage: UIImage, thumbnailEndpoint: String, videoData: NSURL, videoEndpoint: String) {
        
        s3Manager.requestSerializer.bucket = bucket
        s3Manager.requestSerializer.region = AFAmazonS3USStandardRegion
        
        if let documentPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first as? String {
            
            // This is where my thumbnail will be located.
            let thumbnailPath = documentPath.stringByAppendingPathComponent(thumbnailEndpoint)
            // This is where my resized video has already been written - converted to a string.
            let videoPath = videoData.path
            
            // This writes the thumbnail to the thumbnailPath.
            let imageData = UIImagePNGRepresentation(thumbnailImage)
            imageData.writeToFile(thumbnailPath, atomically: false)
            let imageURL = NSURL(fileURLWithPath: thumbnailPath)
            
            // Thumbnail
            s3Manager.putObjectWithFile(thumbnailPath, destinationPath: thumbnailEndpoint, parameters: nil, progress: { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) -> Void in
                
                let percentageWritten = (CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite) * 100.0)
                
                println("Thumbnail Uploaded \(percentageWritten)%")
                
                }, success: { (responseObject) -> Void in
                    
                    let thumbnailInfo = responseObject as! AFAmazonS3ResponseObject
                    
                    self.newURL = thumbnailInfo.URL.absoluteString
                    print(self.newURL)
                    
                }, failure: { (error) -> Void in
                    
                    println("\(error)")
                    
            })
            
            // Video
            s3Manager.putObjectWithFile(videoPath, destinationPath: videoEndpoint, parameters: nil, progress: { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) -> Void in
                
                let percentageWritten = (CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite) * 100.0)
                
                println("Video Uploaded \(percentageWritten)%")
                
                }, success: { (responseObject) -> Void in
                    
                    let videoInfo = responseObject as! AFAmazonS3ResponseObject
                    
                    self.newURL = videoInfo.URL.absoluteString
                    
                    println("Our response object: \(responseObject)")
                    
                }, failure: { (error) -> Void in
                    
                    println("Our error: \(error)")
                    
            })
            
        }
        
    }
    
    
}
