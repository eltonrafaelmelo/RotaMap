//
//  AppDelegate.swift
//  RotaMap
//
//  Created by Elton Melo on 4/1/16.
//  Copyright © 2016 Elton Melo. All rights reserved.
//

import UIKit
import GoogleMaps
import JLToast

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        GMSServices.provideAPIKey("AIzaSyC_A562M2DVBHrE7XdJHlcutAHm3BwHjek")
        setsBackgroundOfColorNavigationBar()
        setsBackgroundOfColorButtonNavigationBar()
        setsStyleTitleNavigationBar()
        configureToast()
        return true
    }
    
    //MARK: - BackgroundOfColorNavigationBar
    func setsBackgroundOfColorNavigationBar() {
        UINavigationBar.appearance().barTintColor = UIColor(red:0.28, green:0.74, blue:0.78, alpha:1.00)
    }
    
    func setsBackgroundOfColorButtonNavigationBar() {
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
    }
    
    func setsStyleTitleNavigationBar(){
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor(), NSFontAttributeName:UIFont(name: "HelveticaNeue-Light", size: 17)!]
    }
    
    func configureToast(){
        JLToastView.setDefaultValue(
            120,
            forAttributeName: JLToastViewPortraitOffsetYAttributeName,
            userInterfaceIdiom: .Phone
        )
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

