//
//  AppDelegate.swift
//  VoiceNote
//
//  Created by 赵新 on 14-8-26.
//  Copyright (c) 2014年 souche. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?


    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        addInitFileIfNeeded()
        self.window?.backgroundColor = UIColor.whiteColor()
        var listController = NoteListController()
        var navigationController = UINavigationController(rootViewController: listController)
        UINavigationBar.appearance().barTintColor = UIColor.skyBlueColor()
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        
        var navbarTitleTextAttr = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        UINavigationBar.appearance().titleTextAttributes = navbarTitleTextAttr
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(application: UIApplication!) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication!) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication!) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication!) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication!) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func addInitFileIfNeeded(){
        var userDefaults = NSUserDefaults.standardUserDefaults()
        
        if (!(userDefaults.objectForKey("hasInitFile") as Bool)){
            var aboutTitle  = NSLocalizedString("关于语音笔记",  comment: "")
            var aboutText = NSLocalizedString("懒人笔记是一款为懒人设计的笔记本，你只需要通过语音输入，即可完成笔记的书写。\n同时支持发邮件，分享到朋友圈等附加功能。\n大部分情况下你无需动笔，只需要靠说，就可以轻松发邮件，是提高效率的好工具。\n开发者：https://github.com/zhaoxin1943/voicenote",  comment: "")
            var note = VNNote(title: aboutTitle, content: aboutText, createdDate:NSDate.date(), updateDate:NSDate.date())
            VNNoteManager.sharedManager()?.storeNote(note)
            userDefaults.setBool(true, forKey: "hasInitFile")
            userDefaults.synchronize()
        }
    }

    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow) -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.toRaw())
        
    }
    
}

