//
//  AppDelegate.swift
//  FlickrClient
//
//  Created by Igor Kolpachkov on 17.03.15.
//  Copyright (c) 2015 com.xstudio.ikolpachkov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow? = UIWindow(frame: UIScreen.mainScreen().bounds)
    var rootViewController: ExposureViewController?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        //initialize root view controller
        self.rootViewController = ExposureViewController()
        window!.rootViewController = rootViewController
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.makeKeyAndVisible()
        return true
    }
}

