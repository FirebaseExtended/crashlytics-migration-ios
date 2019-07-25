This is not an officially supported Google product

# SampleApp for Fabric/Firebase

This iOS app is meant to demo Fabric and Firebase crashlytics / analytics functionalities. It is intended as a showcase of how to integrate basic features into your Fabric/Firebase apps. This sample app also demonstrates the differences between Fabric and Firebase implementation of dependencies, as well as the parity between Answers events and Google Analytics events.

# How to use this App (Fabric)

1. Launch the app in Xcode
2. Navigate to the info.plist file
3. Insert your API Key
4. From your Terminal, cd into your project directory, and run the 'pod install' command
5. Launch Xcode
6. Build the app
7. Run the app

# How to use this App (Firebase)

1. Navigate to your Firebase Console's Project
2. Click add app
3. Download the GoogleService-info.plist file and add it into your root directory
4. From your Terminal, cd into your project directory, and run the 'pod install' command
5. Launch Xcode
6. Run the app

## Get support

If you need support to build the app or to understand any part of the code, let us know. Post your question on [Stack Overflow](http://stackoverflow.com/questions/tagged/google-fabric).

## Contributing

The goal of this project is to be an example for Fabric and Firebase and we strive to keep it simple. We definitely welcome improvements and fixes, but we may not merge every pull request suggested by the community.

The rules for contributing are available at `CONTRIBUTING.md` file.

## License

Copyright 2019 Google LLC

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Cannonball's Journey from Fabric to Firebase
********************************************
.. This raw directive makes all links open in a new tab.
.. raw:: html

    <base target="_blank">

.. figure:: _static/cannonball-overview.png
   :align: center

   *From left to right: Sign In, Poem Creator, Your Poems, and About screens.*

Overview
--------

Cannonball is a magnetic poetry game. Choose your theme, get a bag of words, and start making funny stories right away!

Follow along in this guide to learn how we migrated Cannonball from Fabric to Firebase and how you can migrate your own apps.

.. tip:: We also migrated Cannonball for Android. It’s `open sourced on GitHub <https://github.com/Firebase/cannonball-android>`__. You can also `read the tutorial to build Cannonball for Android <http://docs.fabric.io/android/examples/cannonball/>`__.

.. note:: Sections marked "Bonus" are specific to Cannonball. Although they're not necessary to migrate every app from Fabric, you can use them to learn more about Firebase!

Getting Started
---------------

Prerequisites
~~~~~~~~~~~~~

This guide assumes that you have a Google account and that you're able to access the `Firebase Console <https://console.firebase.google.com/>`__. It also assumes you’re familiar with Git, Xcode, and CocoaPods. Cannonball for iOS uses Swift, unfortunately there is not an Objective-C version right now.

You can follow along in Cannonball's code by downloading its source `from GitHub <https://github.com/FirebasePrivate/cannonball-ios/>`__. If you change branches to :code:`initial`, you'll be able to see how the app looked before the migration.

Creating a Firebase project
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Firebase, Crashlytics' new home, organizes apps in a similar way to Fabric. A `Firebase project <https://support.google.com/firebase/answer/6399760?hl=en&ref_topic=6399725>`__ is similar to a Fabric organization.

When we migrated Cannonball, we created a single Firebase project to contain both the Android and iOS versions of the app. We'd recommend you do the same for your cross-platform apps to take advantage of having shared Firebase features like Realtime Database. However, for apps that are completely different (e.g. ChatApp and CasinoApp), we'd recommend making different projects.

Transitions
-----------

.. note:: The following steps will onboard a new app into Firebase Crashlytics without your existing Fabric crash data. If you'd like to migrate with your historical Crashlytics data, visit the `migration page <https://fabric.io/firebase_migration>`__.

Step 1. Remove the Fabric initialization code.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

We'll first need to remove Fabric from our Xcode project settings.

1. Start by opening your app in Xcode.

2. Remove the Crashlytics Run Script Build Phase from your Xcode project's Build Phases.

3. In your **AppDelegate.swift**, remove your Fabric initialization code by removing the :code:`import Fabric` and :code:`import Crashlytics` statements, as well as any :code:`Fabric.with()` statements.

Step 2: Add Firebase to your app.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To add Firebase to your app, follow along in the `Firebase documentation <https://firebase.google.com/docs/ios/setup>`__ under "Manually add Firebase to your app".

Here are the code changes we've made so far:

.. literalinclude:: _static/diffs/AppDelegate_02.swift
   :diff: _static/diffs/AppDelegate_01.swift

Step 3: Set up Firebase Crashlytics.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To set up Firebase Crashlytics, follow along in the Firebase Documentation on `Getting started with Firebase Crashlytics <https://firebase.google.com/docs/crashlytics/get-started>`__.

If your Podfile already contains pods for Fabric and Crashlytics, replace them with these version-specific pods:

.. code-block:: ruby

    pod 'Fabric', '~> 1.7.7'
    pod 'Crashlytics', '~> 3.10.2'

Once you finish setting up Firebase Crashlytics, you can test your implementation by `forcing a test crash <https://firebase.google.com/docs/crashlytics/force-a-crash>`__ in your app.

Step 4: Convert Fabric Answers to Google Analytics for Firebase.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

`Google Analytics for Firebase <https://firebase.google.com/docs/analytics/>`__ (often just called Analytics) provides the same powerful insights as Answers while integrating closely with the rest of the Firebase suite.

Analytics provides `many predefined events <https://firebase.google.com/docs/reference/swift/firebaseanalytics/api/reference/Constants>`__ that we recommend you use. Here's a table of Answers events and their corresponding Analytics events:

+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **Answers Event**         | **Analytics Event (Objective-C)**                                                                                                                                       | **Analytics Event (Swift)**                                                                                                                                            |
+===========================+=========================================================================================================================================================================+========================================================================================================================================================================+
| logPurchaseWithPrice      | `kFIREventEcommercePurchase <https://firebase.google.com/docs/reference/ios/firebaseanalytics/api/reference/Constants#/c:FIREventNames.h@kFIREventEcommercePurchase>`__ | `AnalyticsEventEcommercePurchase <https://firebase.google.com/docs/crashlytics/get-started>`__                                                                         |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| logAddToCartWithPrice     | `kFIREventAddToCart <https://firebase.google.com/docs/reference/ios/firebaseanalytics/api/reference/Constants#/c:FIREventNames.h@kFIREventAddToCart>`__                 | `AnalyticsEventAddToCart <https://firebase.google.com/docs/reference/swift/firebaseanalytics/api/reference/Constants#/c:FIREventNames.h@kFIREventAddToCart>`__         |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| logStartCheckoutWithPrice | `kFIREventBeginCheckout <https://firebase.google.com/docs/reference/ios/firebaseanalytics/api/reference/Constants#/c:FIREventNames.h@kFIREventBeginCheckout>`__         | `AnalyticsEventBeginCheckout <https://firebase.google.com/docs/reference/swift/firebaseanalytics/api/reference/Constants#/c:FIREventNames.h@kFIREventBeginCheckout>`__ |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| logContentViewWithName    | `kFIREventViewItem <https://firebase.google.com/docs/reference/ios/firebaseanalytics/api/reference/Constants#/c:FIREventNames.h@kFIREventViewItem>`__                   | `AnalyticsEventViewItem <https://firebase.google.com/docs/reference/swift/firebaseanalytics/api/reference/Constants#/c:FIREventNames.h@kFIREventViewItem>`__           |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| logSearchWithQuery        | `kFIREventSearch <https://firebase.google.com/docs/reference/ios/firebaseanalytics/api/reference/Constants#/c:FIREventNames.h@kFIREventSearch>`__                       | `AnalyticsEventSearch <https://firebase.google.com/docs/reference/swift/firebaseanalytics/api/reference/Constants#/c:FIREventNames.h@kFIREventSearch>`__               |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| logShareWithMethod        | `kFIREventShare <https://firebase.google.com/docs/reference/ios/firebaseanalytics/api/reference/Constants#/c:FIREventNames.h@kFIREventShare>`__                         | `AnalyticsEventShare <https://firebase.google.com/docs/reference/swift/firebaseanalytics/api/reference/Constants#/c:FIREventNames.h@kFIREventShare>`__                 |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| logRating                 | (No direct corollary)                                                                                                                                                   | (No direct corollary)                                                                                                                                                  |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| logSignUpWithMethod       | `kFIREventSignUp <https://firebase.google.com/docs/reference/ios/firebaseanalytics/api/reference/Constants#/c:FIREventNames.h@kFIREventSignUp>`__                       | `AnalyticsEventSignUp <https://firebase.google.com/docs/reference/swift/firebaseanalytics/api/reference/Constants#/c:FIREventNames.h@kFIREventSignUp>`__               |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| logLoginWithMethod        | `kFIREventLogin <https://firebase.google.com/docs/reference/ios/firebaseanalytics/api/reference/Constants#/c:FIREventNames.h@kFIREventLogin>`__                         | `AnalyticsEventLogin <https://firebase.google.com/docs/reference/swift/firebaseanalytics/api/reference/Constants#/c:FIREventNames.h@kFIREventLogin>`__                 |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| logInviteWithMethod       | (No direct corollary)                                                                                                                                                   | (No direct corollary)                                                                                                                                                  |
|                           | Maybe: `kFIREventShare <https://firebase.google.com/docs/reference/ios/firebaseanalytics/api/reference/Constants#/c:FIREventNames.h@kFIREventShare>`__                  | Maybe: `AnalyticsEventShare <https://firebase.google.com/docs/reference/swift/firebaseanalytics/api/reference/Constants#/c:FIREventNames.h@kFIREventShare>`__          |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| logLevelStart             | `kFIREventLevelStart <https://firebase.google.com/docs/reference/ios/firebaseanalytics/api/reference/Constants#/c:FIREventNames.h@kFIREventLevelStart>`__               | `AnalyticsEventLevelStart <https://firebase.google.com/docs/reference/swift/firebaseanalytics/api/reference/Constants#/c:FIREventNames.h@kFIREventLevelStart>`__       |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| logLevelEnd               | `kFIREventLevelEnd <https://firebase.google.com/docs/reference/ios/firebaseanalytics/api/reference/Constants#/c:FIREventNames.h@kFIREventLevelEnd>`__                   | `AnalyticsEventLevelEnd <https://firebase.google.com/docs/reference/swift/firebaseanalytics/api/reference/Constants#/c:FIREventNames.h@kFIREventLevelEnd>`__           |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

To migrate your Answers code to Analytics, check the `getting started guide <https://firebase.google.com/docs/analytics/ios/start>`__ to make sure you’ve included the necessary dependencies and startup code. If you've already initialized Firebase in your app, you can skip ahead to the section titled "Log Events".

Then, change your Answers :code:`logFoo` statements (where Foo is an Answers Event in the table above) to `Analytics.logEvent <https://firebase.google.com/docs/analytics/ios/events>`__ using the appropriate event listed in the above table or your own custom event (use your own string instead of one of the constants available in the Firebase library).

The Analytics documentation shows parameters relevant to each predefined event, but you can always add customer parameters too. Instead of using one of the available constants, you can use any string you’d like. Then, `register that parameter in the Firebase Console <https://support.google.com/firebase/answer/7397304?hl=en&ref_topic=6317489>`__.

If an Analytics event is especially important to your business (such as a user spending money, or completing a critical flow in the app), you can `configure it as a conversion <https://support.google.com/firebase/answer/6317522?hl=en&ref_topic=6317489>`__.

Read more about how to log events (including how to attach relevant parameters) `here <https://firebase.google.com/docs/analytics/ios/events#log_events>`__.

Example Answers to Analytics Code
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: _static/diffs/PoemHistoryViewController_02.swift
   :diff: _static/diffs/PoemHistoryViewController_01.swift

Next Steps
~~~~~~~~~~

Use Firebase Authentication
^^^^^^^^^^^^^^^^^^^^^^^^^^^

In order to provide a seamless experience on mobile and a way to carry data from one device to another, we needed to provide a way for users to log in. Originally, Cannonball used Twitter and Digits to sign in. Now, Firebase Authentication handles these login methods and can easily be extended to handle more.

In Cannonball, we decided to use Phone Number Authentication and Anonymous Authentication.

To use Firebase Authentication in your app with a custom UI, follow the guide `here <https://firebase.google.com/docs/auth/ios/start>`__. If you’d like to try a pre-built UI that already handles all of Firebase Authentication’s supported login flows (including phone number authentication), check out `FirebaseUI <https://firebase.google.com/docs/auth/ios/firebaseui>`__.

Convert local storage of poems to use Firebase Realtime Database 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Users can keep a history of the poems they created and share their favorites. In the old version of Cannonball, the poems were stored locally, but in the updated version, Cannonball uses the `Firebase Realtime Database (RTDB) <https://firebase.google.com/docs/database/>`__ to persist poems across different devices. You can even log in on an iOS device, create a poem, and have that same poem appear on an Android device!

In the process of integrating the Realtime Database, we were able to get rid of a lot of code around local persistence. If we were concerned about offline capability in our app, it only takes a `single line of code <https://firebase.google.com/docs/database/ios/offline-capabilities#section-disk-persistence>`__ to turn that on in the RTDB SDK.

Here’s what we had to do in Cannonball to use the Realtime Database:

-  Enable the database in the Firebase Console

-  Remove PoemPersistence.swift module.

-  Change definition of a Poem so that it can serialize and deserialize to RTDB.

-  Set up `basic RTDB security rules <https://firebase.google.com/docs/database/security/quickstart>`__

Try other Firebase features
^^^^^^^^^^^^^^^^^^^^^^^^^^^

-  The open source `FirebaseUI <https://github.com/firebase/FirebaseUI-iOS/blob/master/FirebaseDatabaseUI/README.md>`__ library contains helpful UI Bindings for the Firebase Realtime Database, as well as other Firebase services.

-  Try Firebase APIs by building projects with `quickstart samples <https://github.com/firebase/quickstart-ios>`__.
