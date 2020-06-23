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
    static var APN_Token : String? = nil

    
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
        
        //카카오톡 사용자 토큰 주기적 갱신
        KOSession.shared()?.isAutomaticPeriodicRefresh = true
        UITabBar.appearance().backgroundColor = UIColor.colorRGBHex(hex: 0xeef0f5)
        UITabBar.appearance().layer.borderWidth = 0.0
        UITabBar.appearance().clipsToBounds = true
        
        return true
    }
    
    // Called when APNs has assigned the device a unique token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        print("Token function")
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        // Print it to console
        print("APNs device token: \(deviceTokenString)")
        AppDelegate.APN_Token = deviceTokenString
        
        // Persist it in your backend in case it's new
    }
    
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
    }
    
    // 앱이 '켜져있는 상태'에서 푸시 받았을 때(위의 didReceiveRemoteNotification보다 최신 버전, 7.0), 혹은 백그라운드에서 푸시를 클릭해서 들어왔을 때(앱이 꺼진 상태 제어 불가)
    @available(iOS 7.0, *)
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Swift.Void){
        print("Push notification received: \(userInfo)")
        
        if application.applicationState == UIApplication.State.active{
            print("켜져있는 상태에서 받음")
        } else if  application.applicationState == .background{
            print("background")
            application.applicationIconBadgeNumber = 1
        } else {
            print("푸시 메시지를 클릭하고 들어옴")
            application.applicationIconBadgeNumber = 2
            
            let info = userInfo["aps"]
            print(info)            
            //            guard let info = userInfo["aps"] as? Dictionary
            //                else {
            //                    return
            //            }
            //            print("info: \(info)")
            //
            guard let custom = userInfo["custom"] as? String else{
                return
            }
            print("custom: \(custom)")
        }
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        KOSession.handleDidEnterBackground()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        KOSession.handleDidBecomeActive()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // Push notification received
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        // Print notification payload data
        print("Push notification received: \(data)")
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        print("url \(url)")
        print("url host :\(url.host!)")
        print("url path :\(url.path)")
        
//        let urlPath : String = url.path
//        let urlHost : String = url.host ?? "X"

        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let items = urlComponents?.queryItems
        
        print(items?.first?.name, items?.first?.value)
        
        if(items?.first?.name == "invite")
        {
            
            if (items?.first?.value) == "1" {
                // 초대된 사람!
                UIAlertController.showMessage("초대 성공")
                switchAlbumInfoView()
                
            }
                
            else {
                //초대 안된사람!
                UIAlertController.showMessage("초대 실패")
                switchEnterView()

            }
        }
         
            
        if KLKTalkLinkCenter.shared().isTalkLinkCallback(url) {
            let params = url.query
            
            print(url)
            //callback from kakaotalk link
            print("kakaoopen2")
            print(params)
            if params == "https://apps.apple.com/kr/app/90s-%EB%B6%88%ED%8E%B8%ED%95%9C-%EC%95%84%EB%82%A0%EB%A1%9C%EA%B7%B8-%EC%82%AC%EC%A7%84%EC%B2%A9/id1512639762" {
            if let url = URL(string: params!) {
                
                UIApplication.shared.open(url, options: [:])
            }
                
            }

            return true
        }
        
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
    
    
    //rootView 변경 메소드
    func switchEnterView() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let mainSB: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let enterVC = mainSB.instantiateViewController(withIdentifier: "EnterViewController") as! EnterViewController
        enterVC.initialEnter = false
        let enterNav = UINavigationController(rootViewController: enterVC)
        enterNav.isNavigationBarHidden = true
        
        self.window?.rootViewController = enterNav
        self.window?.makeKeyAndVisible()
    }
    
    func switchSignUp() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let signUpSB: UIStoryboard = UIStoryboard(name: "SignUp", bundle: nil)
        let termVC = signUpSB.instantiateViewController(withIdentifier: "TermViewController") as! TermViewController
        let termNav = UINavigationController(rootViewController: termVC)
        termNav.isNavigationBarHidden = true
        
        self.window?.rootViewController = termNav
        self.window?.makeKeyAndVisible()
    }
    
    func switchSignIn() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let signInSB: UIStoryboard = UIStoryboard(name: "SignIn", bundle: nil)
        let loginMainVC = signInSB.instantiateViewController(withIdentifier: "LoginMainViewController") as! LoginMainViewController
        let loginNav = UINavigationController(rootViewController: loginMainVC)
        loginNav.isNavigationBarHidden = true
        
        self.window?.rootViewController = loginNav
        self.window?.makeKeyAndVisible()
    }
    
    func switchTab() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let mainSB: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tabVC = mainSB.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        let tabNav = UINavigationController(rootViewController: tabVC)
        tabNav.isNavigationBarHidden = true
        tabVC.selectedIndex = 1
        
        self.window?.rootViewController = tabNav
        self.window?.makeKeyAndVisible()
    }
    
    
    func switchAlbumInfoView() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let mainRoot : UIStoryboard = UIStoryboard(name: "Main", bundle: .main)
        let rootVC = mainRoot.instantiateViewController(withIdentifier: "EnterViewController") as! EnterViewController
        rootVC.initialEnter = false

        let albumSB: UIStoryboard = UIStoryboard(name: "Album", bundle: .main)
        let enterVC = albumSB.instantiateViewController(withIdentifier: "AlbumInvitedVC") as! AlbumInvitedVC
        
        
        let tabVC = mainRoot.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        let tabNav = UINavigationController(rootViewController: tabVC)
        
        tabNav.isNavigationBarHidden = true
        tabNav.viewControllers = [rootVC, enterVC]
        
        self.window?.rootViewController = tabNav
        self.window?.makeKeyAndVisible()
        
    }
    
        
}


