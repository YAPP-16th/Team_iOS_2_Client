//
//  AppDelegate.swift
//  AlbumExample
//
//  Created by 홍정민 on 2020/03/17.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UserNotifications
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window:UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        /**************************** Push service start *****************************/
        // iOS 10 support
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
        }
            // iOS 9 support
        else if #available(iOS 9, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 8 support
        else if #available(iOS 8, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 7 support
        else {
            application.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
        }
        /***************************** Push service end ******************************/
        return true
        //카카오톡 사용자 토큰 주기적 갱신
        KOSession.shared()?.isAutomaticPeriodicRefresh = true
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
         let initial:Bool = UserDefaults.standard.bool(forKey: "initial")
        
        if(initial){
            let mainSB: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let enterVC = mainSB.instantiateViewController(withIdentifier: "InitialNavi") as! UINavigationController
            self.window?.rootViewController = enterVC
            self.window?.makeKeyAndVisible()
        }else {
            let signInSB: UIStoryboard = UIStoryboard(name: "SignIn", bundle: nil)
            let loginMainVC = signInSB.instantiateViewController(identifier: "LoginMainViewController") as! LoginMainViewController
            self.window?.rootViewController = loginMainVC
            self.window?.makeKeyAndVisible()
        }
        
        
        return true
    }
    
        // Called when APNs has assigned the device a unique token
        func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            // Convert token to string
            let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
            
            // Print it to console
            print("APNs device token: \(deviceTokenString)")
            
            // Persist it in your backend in case it's new
        }
        
        // Called when APNs failed to register the device for push notifications
        func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
            // Print the error to console (you should alert the user that registration failed)
            print("APNs registration failed: \(error)")
        }

        func applicationWillResignActive(_ application: UIApplication) {
            // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
            // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        }

        func applicationDidEnterBackground(_ application: UIApplication) {
            // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
            // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        }

        func applicationWillEnterForeground(_ application: UIApplication) {
            // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        }

        func applicationDidBecomeActive(_ application: UIApplication) {
            // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        }

        func applicationWillTerminate(_ application: UIApplication) {
            // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        }
        
        // Push notification received
        func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
            // Print notification payload data
            print("Push notification received: \(data)")
        }


    }
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if KOSession.isKakaoAccountLoginCallback(url.absoluteURL) {
            return KOSession.handleOpen(url)
        }
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if KOSession.isKakaoAccountLoginCallback(url.absoluteURL) {
            return KOSession.handleOpen(url)
        }
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        KOSession.handleDidEnterBackground()
    }


