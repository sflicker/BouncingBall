//
//  ORAppDelegate.h
//  BouncingBall
//
//  Created by scott on 9/16/14.
//  Copyright (c) 2014 Wolfpack Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ORAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
