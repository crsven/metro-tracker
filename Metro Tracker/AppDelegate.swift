//
//  AppDelegate.swift
//  Metro Tracker
//
//  Created by Chris Svenningsen on 2/17/15.
//  Copyright (c) 2015 Chris Svenningsen. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let interval = NSTimeInterval(60.0)
        application.setMinimumBackgroundFetchInterval(interval)
        setupNotificationSettings()

        return true
    }

    func setupNotificationSettings() {
        let notificationSettings: UIUserNotificationSettings! = UIApplication.sharedApplication().currentUserNotificationSettings()

        if (notificationSettings.types == UIUserNotificationType.None){
            var caughtBusAction = UIMutableUserNotificationAction()
            caughtBusAction.identifier = "caughtBus"
            caughtBusAction.title = "Got A Bus"
            caughtBusAction.activationMode = UIUserNotificationActivationMode.Background
            caughtBusAction.destructive = false
            caughtBusAction.authenticationRequired = false

            let comingActionsArray = NSArray(objects: caughtBusAction)
            var busComingCategory = UIMutableUserNotificationCategory()
            busComingCategory.identifier = "busComingCategory"
            busComingCategory.setActions(comingActionsArray, forContext: UIUserNotificationActionContext.Default)

            var refreshWatcherAction = UIMutableUserNotificationAction()
            refreshWatcherAction.identifier = "refreshWatcher"
            refreshWatcherAction.title = "Keep Watching"
            refreshWatcherAction.activationMode = UIUserNotificationActivationMode.Foreground
            refreshWatcherAction.destructive = false
            refreshWatcherAction.authenticationRequired = false

            let finalActionsArray = NSArray(objects: caughtBusAction, refreshWatcherAction)
            var finalBusComingCategory = UIMutableUserNotificationCategory()
            finalBusComingCategory.identifier = "finalBusComingCategory"
            finalBusComingCategory.setActions(finalActionsArray, forContext: UIUserNotificationActionContext.Default)

            let categoriesForSettings = NSSet(objects: busComingCategory, finalBusComingCategory)
            var notificationTypes: UIUserNotificationType = UIUserNotificationType.Alert
            let newNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: categoriesForSettings)
            UIApplication.sharedApplication().registerUserNotificationSettings(newNotificationSettings)
        }
    }

    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {

        if(identifier == "caughtBus") {
            NSNotificationCenter.defaultCenter().postNotificationName("caughtBusNotification", object: nil)
        } else if(identifier == "refreshWatcher") {
            NSNotificationCenter.defaultCenter().postNotificationName("refreshWatcherNotification", object: nil)
        }

        completionHandler()
    }

    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        let fetchRequest = NSFetchRequest(entityName: "NotificationRequest")
        if let fetchResults = managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as? [NotificationRequest] {
            let notificationRequest = fetchResults.first!
            let busWatcher = BusWatcher(notificationRequest: notificationRequest)
            busWatcher.start()
            completionHandler(UIBackgroundFetchResult.NewData)
        } else {
            completionHandler(UIBackgroundFetchResult.NoData)
        }
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
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.carbonfive.Metro_Tracker" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as NSURL
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Metro_Tracker", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Metro_Tracker.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }

}
