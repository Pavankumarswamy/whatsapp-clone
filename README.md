
# WhatsApp Clone

A Flutter-based mobile application that replicates core functionalities of WhatsApp, including user authentication, real-time messaging, status updates, and a dummy call feature. The app uses Firebase Authentication for user management and Firebase Realtime Database for real-time data storage and retrieval.

## Features

- **Splash Screen**: Displays the app logo for 3 seconds before navigating to the authentication flow.
- **User Authentication**:
  - Login and signup with email and password using Firebase Authentication.
  - Email verification to ensure secure account access.
  - Password reset functionality via email.
- **Wrapper**: Dynamically routes users to login, email verification, or home screens based on authentication status.
- **Home Screen**: Tabbed interface for navigating Chats, Status, and Calls sections.
- **Chats**:
  - Lists all registered users for initiating chats.
  - Real-time one-on-one messaging stored in Firebase Realtime Database.
- **Status**:
  - Allows users to post image URLs as statuses.
  - Displays a real-time feed of statuses from all users.
- **Calls**:
  - Lists users for initiating dummy calls.
  - Logs call history (incoming/outgoing) in the Realtime Database.
- **Real-Time Functionality**: Chats, statuses, and call logs update in real-time using Firebase streams.

## Getting Started

This project requires Flutter and Firebase setup. Follow the steps below to set up and run the application.

### Prerequisites

- **Flutter SDK**: Install Flutter (version 3.x recommended) following the [official installation guide](https://docs.flutter.dev/get-started/install).
- **Firebase Account**: Create a Firebase project in the [Firebase Console](https://console.firebase.google.com/).
- **IDE**: Use Visual Studio Code, Android Studio, or another IDE with Flutter support.
- **Emulator/Device**: An Android/iOS emulator or physical device for testing.

### Installation

1. **Clone the Repository**:
   ```bash
   git clone <repository-url>
   cd whatsapp_clone
   ```

2. **Install Dependencies**:
   Update `pubspec.yaml` with the following dependencies and run `flutter pub get`:
   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     firebase_core: ^3.6.0
     firebase_auth: ^5.3.1
     firebase_database: ^11.1.4
     firebase_storage: ^12.3.2
   ```

3. **Set Up Firebase**:
   - Create a Firebase project in the [Firebase Console](https://console.firebase.google.com/).
   - Enable **Email/Password Authentication** in the Authentication section.
   - Enable **Realtime Database** and set the following rules:
     ```json
     {
       "rules": {
         ".read": "auth != null",
         ".write": "auth != null"
       }
     }
     ```
   - Add your Firebase configuration files:
     - For Android: Download `google-services.json` and place it in `android/app/`.
     - For iOS: Download `GoogleService-Info.plist` and place it in `ios/Runner/`.
   - Follow the [FlutterFire setup guide](https://firebase.flutter.dev/docs/overview/) for additional platform-specific configurations.

4. **Project Structure**:
   Ensure the following Dart files are in the `lib/screens` directory:
   - `main.dart`
   - `splash_screen.dart`
   - `wrapper.dart`
   - `login_screen.dart`
   - `signup_screen.dart`
   - `forgot_password_screen.dart`
   - `email_verify_screen.dart`
   - `home_screen.dart`
   - `chats_screen.dart`
   - `chat_screen.dart`
   - `status_screen.dart`
   - `calls_screen.dart`

5. **Run the Application**:
   ```bash
   flutter run
   ```

### Usage

1. **Splash Screen**: On launch, the app displays a logo and navigates to the authentication flow.
2. **Authentication**:
   - **Sign Up**: Enter name, phone number, profile image URL, email, and password. Verify your email via the sent link.
   - **Login**: Use email and password to log in.
   - **Forgot Password**: Request a password reset email if needed.
3. **Main Features**:
   - **Chats**: Select a user to start a real-time chat. Messages are saved and retrieved instantly.
   - **Status**: Post an image URL as a status and view others' statuses in a real-time feed.
   - **Calls**: Initiate a dummy call to log call details or view call history.

### Database Structure

The Firebase Realtime Database stores data as follows:
- **/users/{uid}**: Stores user details (name, number, profileUrl, email).
- **/chats/{chatId}/{messageId}**: Stores messages with senderId, receiverId, text, and timestamp.
- **/statuses/{statusId}**: Stores status updates with userId, imageUrl, and timestamp.
- **/calls/{callId}**: Stores call logs with callerId, receiverId, timestamp, and type.

### Troubleshooting

- **Firebase Errors**: Ensure Firebase is correctly configured and dependencies match the specified versions. Check the Firebase Console for authentication or database issues.
- **Network Issues**: Verify internet connectivity and Firebase service status.
- **Invalid Inputs**: Ensure valid image URLs for statuses and strong passwords (at least 6 characters) for signup.
- **Platform Issues**: Test on both Android and iOS to confirm platform-specific configurations.

### Resources

- [Flutter Documentation](https://docs.flutter.dev/): Tutorials and API reference for Flutter development.
- [FlutterFire Documentation](https://firebase.flutter.dev/): Guide for integrating Firebase with Flutter.
- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab): Beginner-friendly Flutter tutorial.
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook): Practical Flutter examples.

### Contributing

Contributions are welcome! Please submit a pull request or open an issue for bug reports, feature requests, or improvements.

