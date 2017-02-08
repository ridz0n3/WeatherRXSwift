//
//  AppDelegate.swift
//  Weather Forecast
//
//  Created by MacBook 1 on 10/01/2017.
//  Copyright © 2017 MacBook 1. All rights reserved.
//

import UIKit
import Firebase
import Fabric
import Crashlytics

extension UILabel{
    var substituteFontName : String {
        get { return self.font.fontName }
        set {
            if self.font.fontName.range(of: "Medium") == nil {
                self.font = UIFont(name: newValue, size: self.font.pointSize)
            }
        }
    }
    
    var substituteFontNameBold : String {
        get { return self.font.fontName }
        set {
            if self.font.fontName.range(of: "Medium") != nil {
                self.font = UIFont(name: newValue, size: self.font.pointSize)
            }
        }
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Use Firebase library to configure APIs
        FIRApp.configure()
        
        Fabric.with([Crashlytics.self])
        
        if launchOptions != nil{
            
            var ref: FIRDatabaseReference!
            
            ref = FIRDatabase.database().reference()
            ref.child("app").setValue(["appKey": launchOptions?[UIApplicationLaunchOptionsKey.url]])
            ref.child("launch").setValue(["launchOption": launchOptions])
            
        }
        
        // Configure tracker from GoogleService-Info.plist.
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        // Optional: configure GAI options.
        let gai = GAI.sharedInstance()
        gai?.trackUncaughtExceptions = true  // report uncaught exceptions
        gai?.logger.logLevel = GAILogLevel.verbose  // remove before app release
        
        let navigationBarAppearace = UINavigationBar.appearance()
        let font = UIFont(name: "Play", size: 17)
        if let font = font {
            navigationBarAppearace.titleTextAttributes = [NSFontAttributeName : font, NSForegroundColorAttributeName : UIColor.white];
        }
        
        UIApplication.shared.statusBarStyle = .lightContent
        UIApplication.shared.isStatusBarHidden = true
        
        navigationBarAppearace.barTintColor = UIColor(colorLiteralRed: 148/255, green: 55/255, blue: 255/255, alpha: 1.0)
        
        navigationBarAppearace.isTranslucent = false
        navigationBarAppearace.setBackgroundImage(UIImage(), for: .default)
        navigationBarAppearace.shadowImage = UIImage()
        
        UILabel.appearance().substituteFontName = "Play"
        
        
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let urlString = url.absoluteString
        let tracker = GAI.sharedInstance().defaultTracker
        let hitParams = GAIDictionaryBuilder()
        hitParams.setCampaignParametersFromUrl(urlString)
        
        if !(hitParams.get(kGAICampaignSource) != nil) && url.host?.characters.count != 0 {
            
            hitParams.set("referrer", forKey: kGAICampaignMedium)
            hitParams.set(url.host, forKey: kGAICampaignSource)
            
        }
        
        let hitParamsdict = hitParams.build()
        
        var ref: FIRDatabaseReference!
        
        ref = FIRDatabase.database().reference()
        ref.child("dict").setValue(["paramDict": hitParamsdict])
        ref.child("absoluteString").setValue(["url": urlString])
        
        tracker?.set(kGAIScreenName, value: "Screen Name")
        tracker?.send(GAIDictionaryBuilder.createScreenView().setAll(hitParamsdict as [NSObject : AnyObject]!).build() as [NSObject : AnyObject]!)
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let urlString = url.absoluteString
        let tracker = GAI.sharedInstance().defaultTracker
        let hitParams = GAIDictionaryBuilder()
        hitParams.setCampaignParametersFromUrl(urlString)
        
        if !(hitParams.get(kGAICampaignSource) != nil) && url.host?.characters.count != 0 {
            
            hitParams.set("referrer", forKey: kGAICampaignMedium)
            hitParams.set(url.host, forKey: kGAICampaignSource)
            
        }
        
        let hitParamsdict = hitParams.build()
        
        var ref: FIRDatabaseReference!
        
        ref = FIRDatabase.database().reference()
        ref.child("param").setValue(["paramDict": hitParamsdict])
        ref.child("string").setValue(["url": urlString])
        
        tracker?.set(kGAIScreenName, value: "Screen Name")
        tracker?.send(GAIDictionaryBuilder.createScreenView().setAll(hitParamsdict as [NSObject : AnyObject]!).build() as [NSObject : AnyObject]!)
        
        
        /*
        NSString *urlString = [url absoluteString];
        
        id<GAITracker> tracker = [[GAI sharedInstance] trackerWithName:@"tracker"
        trackingId:@"UA-XXXX-Y"];
        
        // setCampaignParametersFromUrl: parses Google Analytics campaign ("UTM")
        // parameters from a string url into a Map that can be set on a Tracker.
        GAIDictionaryBuilder *hitParams = [[GAIDictionaryBuilder alloc] init];
        
        // Set campaign data on the map, not the tracker directly because it only
        // needs to be sent once.
        [hitParams setCampaignParametersFromUrl:urlString];
        
        // Campaign source is the only required campaign field. If previous call
        // did not set a campaign source, use the hostname as a referrer instead.
        if(![hitParams get:kGAICampaignSource] && [url host].length !=0) {
            // Set campaign data on the map, not the tracker.
            [hitParams set:@"referrer" forKey:kGAICampaignMedium];
            [hitParams set:[url host] forKey:kGAICampaignSource];
        }
        
        NSDictionary *hitParamsDict = [hitParams build];
        
        // A screen name is required for a screen view.
        [tracker set:kGAIScreenName value:@"screen name"];
        
        // Previous V3 SDK versions.
        // [tracker send:[[[GAIDictionaryBuilder createAppView] setAll:hitParamsDict] build]];
        
        // SDK Version 3.08 and up.
        [tracker send:[[[GAIDictionaryBuilder createScreenView] setAll:hitParamsDict] build]];
        */
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

