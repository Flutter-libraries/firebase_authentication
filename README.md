# Firebase authentication

This package is a wrapper for firebase authentication features.
It's used as a module in differents apps to avoid must to update multiple apps when some version or feature changes in flutterFire

## Features

Register / authetication by:
- Phone
- Email
- Google
- Facebook
- Apple

## Getting started

Add the reference in `pubspec.yaml`

```
firebase_authentication: ^0.0.2
```

## Usage

Import the module

```dart
import 'package:firebase_authentication/firebase_authentication.dart';
```

And use the `AuthenticationRepository`


```dart
await _authenticationRepository.logInWithEmailAndPassword(
    email: state.email.value,
    password: state.password.value,
    );
```

## Additional information

- Test publish 

```
dart pub publish --dry-run
```
