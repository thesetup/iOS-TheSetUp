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

class S3Request: NSObject {
    
    let s3Manager = AFAmazonS3Manager(accessKeyID: accessKey, secret: secret)
    
    var userID = RailsRequest.session().email
    var newURL: String?
    
    func saveImageToS3(image: UIImage) {
        
        s3Manager.requestSerializer.bucket = bucket
        s3Manager.requestSerializer.region = AFAmazonS3USStandardRegion
        //                s3Manager.requestSerializer.setValue("public-read", forHTTPHeaderField: "x-amz-acl")
        
//        let username = RailsRequest.session().username
        
        let timestamp = Int(NSDate().timeIntervalSince1970)
        
        let imageName = "\(userID)_\(timestamp)"
        
        let imageData = UIImagePNGRepresentation(image)
        
        if let documentPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first as? String {
            
            println(imageName)
            
            let filePath = documentPath.stringByAppendingPathComponent(imageName + ".png")
            
            println(filePath)
            
            imageData.writeToFile(filePath, atomically: false)
            
            let fileURL = NSURL(fileURLWithPath: filePath)
            
            s3Manager.putObjectWithFile(filePath, destinationPath: imageName + ".png", parameters: nil, progress: { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) -> Void in
                
                let percentageWritten = (CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite) * 100.0)
                
                println("Uploaded \(percentageWritten)%")
                
                }, success: { (responseObject) -> Void in
                    
                    let info = responseObject as! AFAmazonS3ResponseObject
                    
                    self.newURL = info.URL.absoluteString
                    
//                    RailsRequest.session().postImage(self.newURL, completion: { () -> Void in
//                        
//                        
//                    })
                    
                    println("\(responseObject)")
                    
                }, failure: { (error) -> Void in
                    
                    println("\(error)")
                    
            })
            
        }
        
    }
    
    
}
