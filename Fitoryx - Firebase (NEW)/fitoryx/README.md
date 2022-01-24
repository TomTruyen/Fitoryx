# Fitoryx

Workout & Nutrition Tracker with Firebase

# Setup

## Generate `firebase_options.dart`

<br/>

### Install FlutterFire CLI

`dart pub global activate flutterfire_cli`

<br/>

### Install Firebase CLI

`npm i -g firebase-tools`

<br/>

### Generate

`flutterfire configure`

NOTE: Just follow the steps in the wizard (Select: **Fitoryx** as project)

<br/>

---

## Google Auth setup

### Generate SHA1 (DEBUG) -- Release must be generated later

`cd android && ./gradlew signingReport` <br />

Use the `SHA1` from `debug` for Firebase

<br />

### Download google-service.json and place into `android/app`

<br />

### Modify Android Configuration in `android/`

#### `android/build.gradle`

Add `classpath 'com.google.gms:google-services:4.3.8'` to buildscript dependencies

<br />

#### `android/app/build.gradle`

Add `apply plugin: 'com.google.gms.google-services'` underneath `apply plugin 'com.android.application'`

<br />

### `Error while merging dex archives: The number of method references in a .dex file cannot exceed 64K`

Add `multiDexEnabled true` to `defaultConfig` in `/android/app/build.gradle`
