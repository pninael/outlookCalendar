//
//  AppDelegate.swift
//  OutlookCalendar
//
//  Created by Pnina Eliyahu on 1/3/18.
//  Copyright © 2018 Pnina Eliyahu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationVC = UINavigationController()
        let masterVC = MasterViewController()
        navigationVC.viewControllers = [masterVC]
        window!.rootViewController = navigationVC
        window!.makeKeyAndVisible()
        
        return true
    }
}

