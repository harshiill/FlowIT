# 🚀 FlowIt Deployment Guide

Deploying a Flutter application involves compiling the code into release-ready binaries and distributing them. Because Flutter is cross-platform, the deployment process differs depending on your target platform (Android, iOS, or Web).

Below are the step-by-step instructions to build and deploy your app.

---

## 🤖 Android Deployment

For Android, you can build an **APK** (for direct sharing/sideloading) or an **App Bundle (AAB)** (required for the Google Play Store).


### 1. Build an APK (For Direct Sharing/Testing)
If you just want to share the app with friends or install it on devices directly without the Play Store:
```bash
# This creates a 'fat' APK containing all architectures
flutter build apk --release
```
**Where to find it:** `build/app/outputs/flutter-apk/app-release.apk`
You can send this `.apk` file directly to Android devices to install it.

### 2. Build an App Bundle (For Google Play Store)
If you are publishing to the Google Play Store, you must build an AAB. 

**Prerequisites:** You need to digitally "sign" your app.
1. Generate a keystore file using Java's `keytool` (runs in your terminal):
   ```bash
   keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```
2. Create a file named `android/key.properties` and add your keystore details:
   ```properties
   storePassword=<your_password>
   keyPassword=<your_password>
   keyAlias=upload
   storeFile=<path_to_your_keystore_file>
   ```
3. Update `android/app/build.gradle` to use these properties for the release build type (see the [official docs](https://docs.flutter.dev/deployment/android#configure-signing-in-gradle) for the exact code snippet).

**Build the AAB:**
```bash
flutter build appbundle
```
**Where to find it:** `build/app/outputs/bundle/release/app-release.aab`
Upload this `.aab` file to the Google Play Console.

---

## 🍏 iOS Deployment (App Store)

> [!WARNING]
> You must have a Mac with **Xcode** installed and an active **Apple Developer Program** membership ($99/year) to deploy to the App Store.

### 1. Register your App
1. Go to your [Apple Developer Account](https://developer.apple.com/) and create a new **App ID** using your Bundle Identifier (found in Xcode).
2. Go to [App Store Connect](https://appstoreconnect.apple.com/) and create a new App record using that App ID.

### 2. Configure Xcode
1. Open your project in Xcode:
   ```bash
   open ios/Runner.xcworkspace
   ```
2. Select the `Runner` project in the navigator.
3. Go to the **Signing & Capabilities** tab.
4. Check **"Automatically manage signing"** and select your Apple Developer Team.

### 3. Build and Upload
```bash
# Create the release archive
flutter build ipa
```
**Where to find it:** `build/ios/ipa/FlowIt.ipa`
You can then upload this `.ipa` file using the **Transporter** app (available on the Mac App Store) or directly via Xcode to App Store Connect.

---

## 🌐 Web Deployment

If you want to host the dashboard as a website that anyone can access from a browser:

### 1. Build for Web
```bash
flutter build web
```
**Where to find it:** `build/web/`
This folder contains the compiled HTML, CSS, and JavaScript. 

### 2. Hosting Options
You can drag and drop the contents of the `build/web/` folder to any static hosting provider. Here are the easiest ones:
- **Vercel** (Highly Recommended): Run `npm i -g vercel` then `vercel --prod` inside the `build/web` folder.
- **Firebase Hosting**: Run `firebase init` and set the public directory to `build/web`, then run `firebase deploy`.
- **GitHub Pages**: You can commit the `build/web` folder to a `gh-pages` branch on your GitHub repository.

---

## 📈 Managing Versions
Before you deploy an update in the future, you must update the version number in your `pubspec.yaml` file:
```yaml
version: 1.0.1+2
```
* The part before the `+` (`1.0.1`) is the **version name** (what users see).
* The part after the `+` (`2`) is the **build number** (an internal counter that MUST increase with every upload to an app store).
