//
//  AppDelegate.swift
//  Monthly
//
//  Created by Denis Litvin on 10.08.2018.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import UIKit

import Moya
import RealmSwift
import VisualEffectView

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        
        let blurView = VisualEffectView(frame: UIScreen.main.bounds)
        blurView.isHidden = true
        let sliderView = SliderView()
        let statSliderView = StatSliderView()
        let tabBarView = TabBarView()
        
        let frame = tabBarView.convert(tabBarView.plusButton.frame, to: window)
        let x = (UIScreen.main.bounds.width - sliderView.saveButton.frame.width) / 2
        var y = frame.origin.y + 2.5
        if #available(iOS 11.0, *),
            UIApplication.shared.isEdgelessDisplay() {
            y -= (UIApplication.shared.delegate!.window??.safeAreaInsets.top)! - 9 * 2
        }
        sliderView.saveButton.frame.origin = CGPoint(x: x, y: y)
        
        let vc = MainVC(with: tabBarView,
                        sliderView: sliderView,
                        blurView: blurView,
                        statSliderView: statSliderView)
        vc.viewModel.databaseManager = DatabaseManager()
        vc.viewModel.networkManager = MoyaProvider<General>()
        vc.viewModel.didSetDependencies()
        vc.didSetDependencies()
        
        //nav con
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.barStyle = .default
        navController.navigationBar.backgroundColor = UIColor.Elements.background
        navController.navigationBar.isTranslucent = false
        navController.navigationBar.barTintColor = UIColor.Elements.background
        navController.navigationBar.shadowImage = UIImage()
        
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        window?.addSubview(blurView)
        window?.addSubview(sliderView)
        window?.addSubview(statSliderView)
        window?.addSubview(tabBarView)
        window?.addSubview(sliderView.saveButton)
        
//        print("CONFIG: ", Realm.Configuration.defaultConfiguration.fileURL?.path)
//        Bundle(path: "/Applications/InjectionX.app/Contents/Resources/iOSInjection.bundle")!.load() //templocal
        return true
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
}

