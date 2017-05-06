//
//  Generated file. Do not edit.
//

#import "PluginRegistry.h"

@implementation PluginRegistry

- (instancetype)initWithController:(FlutterViewController *)controller {
  if (self = [super init]) {
    _firebase_analytics = [[FirebaseAnalyticsPlugin alloc] initWithController:controller];
    _firebase_auth = [[FirebaseAuthPlugin alloc] initWithController:controller];
    _firebase_database = [[FirebaseDatabasePlugin alloc] initWithController:controller];
    _firebase_storage = [[FirebaseStoragePlugin alloc] initWithController:controller];
    _google_sign_in = [[GoogleSignInPlugin alloc] initWithController:controller];
    _image_picker = [[ImagePickerPlugin alloc] initWithController:controller];
  }
  return self;
}

@end
