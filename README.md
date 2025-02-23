# paw_catcher_admin

A new Flutter project.

## Getting Started

Dog Catcher Mobile App
Overview
The Dog Catcher Mobile App is a Flutter-based mobile application designed to help users report stray dogs in public areas. This project is intended for learning purposes and focuses on implementing core features like user authentication, GPS tracking, reporting incidents, and notifications. The app uses Google Maps for location services and Riverpod for state management.


Table of Contents
Features
Technologies Used
App Structure
Learning Goals
Future Enhancements


Features
Core Features
User Registration and Authentication
Users can create accounts using email/password.
Firebase Authentication ensures secure login.
Stray Dog Reporting
Users can report stray dogs by providing details such as location, description, and images.
GPS integration allows users to mark the exact location of the stray dog.
GPS Tracking and Location Services
Built-in GPS functionality helps track the user's location and display nearby stray dog reports on a map.
Communication Platform
A simple chat system allows users to communicate with local animal control services.
Image Capture
Users can capture and upload images of stray dogs directly from the app.


Technologies Used
Flutter : Cross-platform framework for building the mobile app.
Dart : Programming language used for app development.
Google Maps API : For location tracking and displaying maps.
Riverpod : State management solution for managing app state efficiently.
Firebase :
Firebase Authentication for user registration and login.
Firebase Cloud Messaging (FCM) for push notifications.
Firebase Firestore for storing user data and stray dog reports.
Camera Plugin : For capturing images of stray dogs.
Geolocator Plugin : For GPS tracking and location services.


Learning Goals
This project was created to help you learn and practice the following skills:

Flutter Basics : Building UIs, navigation, and handling user input.
State Management : Using Riverpod to manage app state efficiently.
Firebase Integration :
Authentication: Implementing secure user login and registration.
Firestore: Storing and retrieving data in real-time.
Cloud Messaging: Sending push notifications.
Google Maps API : Integrating maps and location services into a Flutter app.
Image Handling : Capturing and uploading images using the camera plugin.