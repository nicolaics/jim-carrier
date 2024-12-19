# Jim Carrier Flutter

### Directory Structure
```
.
├── android
|   ├── app
|   |   ├── src
|   |   |   ├── debug
|   |   |   ├── main
|   |   |   |   ├── java
|   |   |   |   ├── kotlin
|   |   |   |   ├── res
|   |   |   |   └── AndroidManifest.xml
|   |   |   └── profile
|   |   └── build.gradle
|   ├── gradle
|   ├── .gitignore
|   ├── buid.gradle
|   ├── gradle.properties
|   └── settings.gradle
├── assets
|   └── images
|       ├── loginpage
|       |   └── google_icon.png
|       └── welcomePage
|           └── welcome_screen.png
├── ios
|   ├── Flutter
|   ├── Runner
|   ├── Runner.xcodeproj
|   ├── Runner.xcworkspace
|   ├── RunnerTests
|   ├── .gitignore
|   └── Podfile
├── lib
|   ├── src
|   |   ├── api
|   |   |   ├── api_service.dart
|   |   |   ├── auth.dart
|   |   |   ├── listing.dart
|   |   |   ├── order.dart
|   |   |   └── review.dart
|   |   ├── auth
|   |   |   ├── encryption.dart
|   |   |   └── secure_storage.dart
|   |   ├── base_class
|   |   |   ├── firebase_notif.dart
|   |   |   └── login_google.dart
|   |   ├── constants
|   |   |   ├── colors.dart
|   |   |   ├── currency.dart
|   |   |   ├── image_strings.dart
|   |   |   ├── sizes.dart
|   |   |   └── text_strings.dart
|   |   ├── screens
|   |   |   ├── auth
|   |   |   |   ├── email_verification.dart
|   |   |   |   ├── forgot_pw.dart
|   |   |   |   ├── login_screen.dart
|   |   |   |   ├── otp_screen_fp.dart
|   |   |   |   ├── otp_screen.dart
|   |   |   |   ├── register_screen.dart
|   |   |   |   └── reset_password.dart
|   |   |   ├── home
|   |   |   |   ├── bottom_bar.dart
|   |   |   |   └── home_page.dart
|   |   |   ├── listing
|   |   |   |   ├── add_listing.dart
|   |   |   |   └── edit_listing.dart
|   |   |   ├── order
|   |   |   |   ├── confirm_order.dart
|   |   |   |   ├── new_order.dart
|   |   |   |   └── previous_order.dart
|   |   |   ├── profile
|   |   |   |   ├── profile_menu.dart
|   |   |   |   ├── profile_screen.dart
|   |   |   |   ├── update_password.dart
|   |   |   |   └── update_profile.dart
|   |   |   ├── received_order
|   |   |   |   └── received_order.dart
|   |   |   ├── review
|   |   |   |   └── review_page.dart
|   |   |   ├── try.dart
|   |   |   └── welcome.dart
|   |   └── utils
|   |       └── formatter.dart
|   ├── firebase_options.dart
|   └── main.dart
├── linux
|   ├── flutter
|   ├── .gitignore
|   ├── main.cc
|   ├── my_application.cc
|   └── my_application.h
├── macos
|   ├── Flutter
|   ├── Runner
|   ├── Runner.xcodeproj
|   ├── Runner.xcworkspace
|   ├── RunnerTests
|   ├── .gitignore
|   └── Podfile
├── test
|   └── widget_test.dart
├── web
|   ├── icons
|   ├── favicon.png
|   ├── index.html
|   └── manifest.json
├── windows
|   ├── runner
|   └── .gitignore
├── .gitignore
├── .metadata
├── analysis_options.yaml
├── LICENSE
├── pubspec.yaml
└── README.md
```

## MOTIVATION
- Living in a foreign country as an international student or immigrant worker can be challenging.  
- Differences in food, culture, and familiar items from home can make adjusting difficult.  
- Missing or needing important documents left in the home country is a common issue.  
- Traditional services like post offices are expensive and slow, making them unsuitable for students or cost-conscious workers.  
- A solution is utilizing travelers with unused baggage space to transport items at a lower cost.  
- This approach provides faster delivery and is more affordable for those in need.

## MAIN FEATURES
# User Features:
•	Create, modify, and delete accounts.
•	Verification of Account via Emai.
•	Reset Password.
•	Add and modify Bank Details.
•	Communicate via Email.
# Core Features:
•	Create, modify, and delete listing.
•	Create, modify, and delete order.
•	Confirm Orders by Carrier.
•	Leave Reviews.
•	Browse Listings.
## Additional Features:
•	Uploading Profile Pictures.
•	Upload Payment Proof.
•	Upload Package Image.
•	Email Notifications for Images: 
  o	Payment proof images are sent to the corresponding user via email.
  o	Package images are shared with the relevant user through email.

## TECHNICAL STACK
•	Frontend
-	Flutter framework
-	Dart programming language
-	Figma for initial designs
•	Backend
-	Golang programming language
-	MySQL for the database
•	Deployment
-	EC2 instance at Amazon Web Service
-	RDS at Amazon Web Service
-	Tailscale for testing and debugging
•	Project Management Software Tool
-	Jira by Atlassian

## FRONTEND FLOWCHART
Below is the visual representation of interaction among different interfaces in our application.
![Flowchart](https://github.com/user-attachments/assets/ea401fcc-8446-45fa-915a-6a383aa20932)






