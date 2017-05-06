package io.flutter.plugins;

import io.flutter.app.FlutterActivity;

import io.flutter.firebase_analytics.FirebaseAnalyticsPlugin;
import io.flutter.firebase_auth.FirebaseAuthPlugin;
import io.flutter.plugins.firebase.database.FirebaseDatabasePlugin;
import io.flutter.plugins.firebase.storage.FirebaseStoragePlugin;
import io.flutter.plugins.googlesignin.GoogleSignInPlugin;
import io.flutter.plugins.imagepicker.ImagePickerPlugin;

/**
 * Generated file. Do not edit.
 */

public class PluginRegistry {
    public FirebaseAnalyticsPlugin firebase_analytics;
    public FirebaseAuthPlugin firebase_auth;
    public FirebaseDatabasePlugin firebase_database;
    public FirebaseStoragePlugin firebase_storage;
    public GoogleSignInPlugin google_sign_in;
    public ImagePickerPlugin image_picker;

    public void registerAll(FlutterActivity activity) {
        firebase_analytics = FirebaseAnalyticsPlugin.register(activity);
        firebase_auth = FirebaseAuthPlugin.register(activity);
        firebase_database = FirebaseDatabasePlugin.register(activity);
        firebase_storage = FirebaseStoragePlugin.register(activity);
        google_sign_in = GoogleSignInPlugin.register(activity);
        image_picker = ImagePickerPlugin.register(activity);
    }
}
