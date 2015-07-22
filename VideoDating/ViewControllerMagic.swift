//
//  ViewControllerMagic.swift
//  VideoDating
//
//  Created by Kyle Brooks Robinson on 7/17/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

import UIKit

private let defaults = NSUserDefaults.standardUserDefaults()
private let _singleton = ViewControllerMagic()

class ViewControllerMagic: UIViewController {

    class func session() -> ViewControllerMagic { return _singleton }
    
    func presentNoProfile() {
        
        let yourProfileFlow = UIStoryboard(name: "YourProfileFlow", bundle: nil)
        
        let noProfileVC = yourProfileFlow.instantiateViewControllerWithIdentifier("noProfileVC") as! NoProfileViewController
        
        presentViewController(noProfileVC, animated: true, completion: nil)
        
    }
    
}

