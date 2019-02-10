//
//  AppDelegate.swift
//  Febrewary
//
//  Created by Matt Dias on 1/24/19.
//  Copyright © 2019 Matt Dias. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        // TODO: cleanup stringy things
        guard let token = UserDefaults.standard.string(forKey: "token"),
              let expirationString = UserDefaults.standard.object(forKey: "tokenExpiration") as? String,
              let expirationDate = dateFormatter.date(from: expirationString),
              today < expirationDate else {
                presentTokenScreen(from: storyboard)
                return true
        }

        if token.hasPrefix("P-") || token.hasPrefix("D-") {
            let enterBeerScreen = storyboard.instantiateViewController(withIdentifier: "EnterBeerScreen")

            window?.rootViewController = enterBeerScreen
            window?.makeKeyAndVisible()
        } else {
            presentTokenScreen(from: storyboard)
        }

        return true
    }

    func presentTokenScreen(from storyboard: UIStoryboard) {
        let tokenViewController = storyboard.instantiateViewController(withIdentifier: "TokenScreen")

        window?.rootViewController = tokenViewController
        window?.makeKeyAndVisible()
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

