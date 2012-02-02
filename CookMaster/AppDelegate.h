//
//  AppDelegate.h
//  CookMaster
//
//  Created by lim byeong cheol on 11. 11. 14..
//  Copyright (c) 2011년 SK M&S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioSessionManager.h" // Importing OpenEars' AudioSessionManager class header.

#import "Event.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <sys/socket.h>
#import <netinet/in.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    	AudioSessionManager *audioSessionManager; // This is OpenEars' AudioSessionManager class. 

}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
@property (nonatomic, retain) AudioSessionManager *audioSessionManager; // This is OpenEars' AudioSessionManager class.

@property (strong, nonatomic) UINavigationController *navigationController;

@property (strong, nonatomic) UISplitViewController *splitViewController;


@end
