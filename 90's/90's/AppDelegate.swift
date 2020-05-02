//
//  AppDelegate.swift
//  AlbumExample
//
//  Created by 홍정민 on 2020/03/17.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window:UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
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
}

