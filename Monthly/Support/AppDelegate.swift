//
//  AppDelegate.swift
//  Monthly
//
//  Created by Denis Litvin on 10.08.2018.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = AppDelegate.makeRootVC()
        window?.makeKeyAndVisible()
        
        
        print("CONFIG: ", Realm.Configuration.defaultConfiguration.fileURL?.path)
//        Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle")!.load() //templocal
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

    static func makeRootVC() -> UIViewController {
        let vc = MainVC()
        vc.view.backgroundColor = UIColor.Elements.background
        vc.view.addSubview(FPSCounter())
        vc.viewModel.databaseManager = DatabaseManager.init()
        vc.viewModel.didSetDependencies()
        vc.didSetDependencies()
        //title
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        titleLabel.font = UIFont.fixed(13, family: .proximaNova).bolded
        titleLabel.textColor = .white
        let str = "MONTHLY".localized()
        titleLabel.attributedText = NSAttributedString(string: str, attributes: [.kern: 3.15])
        vc.navigationItem.titleView = titleLabel
        
        //nav con
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.barStyle = .blackTranslucent
        navController.navigationBar.backgroundColor = UIColor.Elements.background
        navController.navigationBar.isTranslucent = false
        navController.navigationBar.barTintColor = UIColor.Elements.background
        navController.navigationBar.shadowImage = UIImage()
        return navController
    }
}

