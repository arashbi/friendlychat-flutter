//
//  Generated file. Do not edit.
//

#ifndef PluginRegistry_h
#define PluginRegistry_h

#import <Flutter/Flutter.h>

#import "FirebaseAnalyticsPlugin.h"
#import "FirebaseAuthPlugin.h"
#import "FirebaseDatabasePlugin.h"
#import "FirebaseStoragePlugin.h"
#import "GoogleSignInPlugin.h"
#import "ImagePickerPlugin.h"

@interface PluginRegistry : NSObject

@property (readonly, nonatomic) FirebaseAnalyticsPlugin *firebase_analytics;
@property (readonly, nonatomic) FirebaseAuthPlugin *firebase_auth;
@property (readonly, nonatomic) FirebaseDatabasePlugin *firebase_database;
@property (readonly, nonatomic) FirebaseStoragePlugin *firebase_storage;
@property (readonly, nonatomic) GoogleSignInPlugin *google_sign_in;
@property (readonly, nonatomic) ImagePickerPlugin *image_picker;

- (instancetype)initWithController:(FlutterViewController *)controller;

@end

#endif /* PluginRegistry_h */
