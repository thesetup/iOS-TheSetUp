//
//  RecordedVideo.swift
//  VideoDating
//
//  Created by Kyle Brooks Robinson on 7/13/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

import UIKit

private let defaults = NSUserDefaults.standardUserDefaults()
private let _singleton = RecordedVideo()

class RecordedVideo: NSObject {
    
    // This singleton is where I store information for a currently-creating profile and its videos.
    
    class func session() -> RecordedVideo { return _singleton }
    
    var name: String?
    var email: String?
    var password: String?
    var birthyear: String?
    var gender: String?
    var orientation: String?
    var occupation: String?
    var location: String?
    
    var profilePicture: UIImage?
    var profilePictureLink: String?
    
    var mainVideoURL: NSURL?
    var mainVideoLink: String?
    var mainVideoThumbnail: UIImage?
    var mainVideoThumbnailLink: String?

    var optionalVideo1URL: NSURL?
    var optionalVideo1Link: String?
    var optionalVideo1Thumbnail: UIImage?
    var optionalVideo1ThumbnailLink: String?
    var optionalVideo1Label: String?

    var optionalVideo2URL: NSURL?
    var optionalVideo2Link: String?
    var optionalVideo2Thumbnail: UIImage?
    var optionalVideo2ThumbnailLink: String?
    var optionalVideo2Label: String?

    var optionalVideo3URL: NSURL?
    var optionalVideo3Link: String?
    var optionalVideo3Thumbnail: UIImage?
    var optionalVideo3ThumbnailLink: String?
    var optionalVideo3Label: String?
    
    var messageVideoURL: NSURL?
    var messageVideoLink: String?
    var messageVideoThumbnail: UIImage?
    var messageVideoThumbnailLink: String?
    
    var profileToLoad: [String:AnyObject]?
    
    var videoEndpoint = S3_URL + ""
    
    func loadRailsInfoToSingleton(profileId: Int) {
        
        name = profileToLoad?["name"] as? String
        email = profileToLoad?["email"] as? String
        password = profileToLoad?["password"] as? String
        birthyear = profileToLoad?["birthyear"] as? String
        gender = profileToLoad?["gender"] as? String
        orientation = profileToLoad?["orientation"] as? String
        occupation = profileToLoad?["occupation"] as? String
        location = profileToLoad?["location"] as? String

        if let mediaInfo = profileToLoad?["media"] as? [String:AnyObject] {
            
            convertThumbnail((mediaInfo["profile_pic"] as! String), thumbnailDestination: profilePicture)
            
            if let mainVideoDirectory = mediaInfo["main_video"] as? [String: AnyObject] {
                
                mainVideoURL = mainVideoDirectory["video_url"] as? NSURL
                convertThumbnail((mainVideoDirectory["thumbnail"] as! String), thumbnailDestination: mainVideoThumbnail)
                
            }
            
            if let lookingForVideoDirectory = mediaInfo["video1"] as? [String: AnyObject] {
                
                optionalVideo1URL = lookingForVideoDirectory["video_url"] as? NSURL
                convertThumbnail((lookingForVideoDirectory["thumbnail"] as! String), thumbnailDestination: optionalVideo1Thumbnail)
                
            }
            
            if let likesVideoDirectory = mediaInfo["video2"] as? [String:AnyObject] {
                
                optionalVideo2URL = likesVideoDirectory["video_url"] as? NSURL
                convertThumbnail((likesVideoDirectory["thumbnail"] as! String), thumbnailDestination: optionalVideo2Thumbnail)
                
            }
            
            if let dislikesVideoDirectory = mediaInfo["video3"] as? [String:AnyObject] {
                
                optionalVideo3URL = dislikesVideoDirectory["video_url"] as? NSURL
                convertThumbnail((dislikesVideoDirectory["thumbnail"] as! String), thumbnailDestination: optionalVideo3Thumbnail)
                
            }
            
        }
    
    }

    func convertThumbnail(thumbnailToConvert: String!, thumbnailDestination: UIImage!) {
        
        var thumbnailDestination: UIImage?
        
        if let newThumbnailURL = NSURL(string: thumbnailToConvert) {
            
            let newUIImage = UIImage(data: NSData(contentsOfURL: newThumbnailURL)!)
            thumbnailDestination = newUIImage
            
        }
        
    }
    
    func resetSingleton() {
        
        name = nil
        email = nil
        password = nil
        birthyear = nil
        gender = nil
        orientation = nil
        occupation = nil
        location = nil
        
        profilePicture = nil
        profilePictureLink = nil
        
        mainVideoURL = nil
        mainVideoThumbnail = nil
        mainVideoLink = nil
        mainVideoThumbnailLink = nil
        
        optionalVideo1URL = nil
        optionalVideo1Thumbnail = nil
        optionalVideo1Link = nil
        optionalVideo1ThumbnailLink = nil
        
        optionalVideo2URL = nil
        optionalVideo2Thumbnail = nil
        optionalVideo2Link = nil
        optionalVideo2ThumbnailLink = nil
        
        optionalVideo3URL = nil
        optionalVideo3Thumbnail = nil
        optionalVideo3Link = nil
        optionalVideo3ThumbnailLink = nil
        
        profileToLoad = nil
        
        messageVideoLink = nil
        messageVideoThumbnail = nil
        messageVideoThumbnailLink = nil
        messageVideoURL = nil
        
    }
    
}






