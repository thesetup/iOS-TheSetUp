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
    
    var userID: String = "KyleTest"
    var newURL: String?
    var videoURL: String?
    var thumbnail: UIImage?
    
    var timeyNumber = Int(NSDate().timeIntervalSince1970 * 0.01)
    
    var videoName: String {
        return "/\(userID)_\(timeyNumber).mp4"
    }
    
    var videoFile: String {
        return documentsDirectory + videoName
    }
    
    var resizedVideoURL: NSURL? {
        return NSURL(fileURLWithPath: videoFile)
    }
    
    
    func saveVideoToS3() {
        
        s3Manager.requestSerializer.bucket = bucket
        s3Manager.requestSerializer.region = AFAmazonS3USStandardRegion
        //        s3Manager.requestSerializer.setValue("public-read", forHTTPHeaderField: "x-amz-acl")
        
        if let documentPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first as? String {
            
            let imagePath = documentPath.stringByAppendingPathComponent("\(userID)_\(timeyNumber)img.png")
            
            let imageData = UIImagePNGRepresentation(thumbnail)
            
            imageData.writeToFile(imagePath, atomically: false)
            
            let imageURL = NSURL(fileURLWithPath: imagePath)
            
            // Thumbnail
            s3Manager.postObjectWithFile(imagePath, destinationPath: "", parameters: nil, progress: { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) -> Void in
                
                let percentageWritten = (CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite) * 100.0)
                
                println("Thumbnail Uploaded \(percentageWritten)%")
                
                }, success: { (responseObject) -> Void in
                    
                    let thumbnailInfo = responseObject as! AFAmazonS3ResponseObject
                    
                    self.newURL = thumbnailInfo.URL.absoluteString
                    
                    // Send Rails the thumbnail URL here.
                    
                }, failure: { (error) -> Void in
                    
                    println("\(error)")
                    
            })
            
            // Video
            s3Manager.postObjectWithFile(videoFile, destinationPath: "", parameters: nil, progress: { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) -> Void in
                
                let percentageWritten = (CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite) * 100.0)
                
                println("Video Uploaded \(percentageWritten)%")
                
                }, success: { (responseObject) -> Void in
                    
                    let videoInfo = responseObject as! AFAmazonS3ResponseObject
                    
                    self.newURL = videoInfo.URL.absoluteString
                    
                    println("Our response object: \(responseObject)")
                    
                    // Send Rails the video URL here.
                    
                    
                }, failure: { (error) -> Void in
                    
                    println("Our error: \(error)")
                    
            })
            
        }
        
    }
    
    
}
