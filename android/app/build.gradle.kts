plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.sarjan_construction"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.sarjan_construction"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    flavorDimensions += "environment"
    productFlavors {
        create("dev") {
            dimension = "environment"
            applicationIdSuffix = ".dev"
            resValue("string", "app_name", "Sarjan Dev")
        }
        create("staging") {
            dimension = "environment"
            applicationIdSuffix = ".staging"
            resValue("string", "app_name", "Sarjan Staging")
        }
        create("prod") {
            dimension = "environment"
            resValue("string", "app_name", "Sarjan Construction")
        }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

afterEvaluate {
    tasks.findByName("assembleDebug")?.doLast {
        val flutterApkDir = file("${project.rootDir}/../build/app/outputs/flutter-apk")
        val devDebugApk = file("$flutterApkDir/app-dev-debug.apk")
        val defaultDebugApk = file("$flutterApkDir/app-debug.apk")
        if (devDebugApk.exists()) {
            devDebugApk.copyTo(defaultDebugApk, overwrite = true)
        }
    }
    tasks.findByName("assembleRelease")?.doLast {
        val flutterApkDir = file("${project.rootDir}/../build/app/outputs/flutter-apk")
        val prodReleaseApk = file("$flutterApkDir/app-prod-release.apk")
        val defaultReleaseApk = file("$flutterApkDir/app-release.apk")
        if (prodReleaseApk.exists()) {
            prodReleaseApk.copyTo(defaultReleaseApk, overwrite = true)
        }
    }
}
