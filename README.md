# TimeWalk Photo App Specifications

# Purpose
 - The app allows users to capture photos of specific locations (e.g., Times Square) and receive an image of that same location from a historical perspective (e.g., 1609, 1660, 1776).
 - The app captures and overlays specific metadata on the photos, such as GPS coordinates, camera angle, zoom level, and more.

# Example Usage Scenario
- User Interface:
  - User opens the app and grants necessary permissions.
  - User sees the camera preview with metadata displayed on the screen.
  - User can pinch to zoom and see the zoom factor update.
  - User captures a photo by pressing the capture button.
- Behind the Scenes:
  • The app captures the photo and metadata.
  • The photo is resized and the metadata is overlaid.
  • Two versions of the photo (with and without overlay) are saved to the photo library.


# Key Features

Photo Capture:
- Uses the device camera to capture photos.
- Supports pinch-to-zoom functionality.
- Plays a shutter sound when a photo is taken.

Metadata Collection:
- Collects and displays the following metadata for each photo:
- GPS coordinates (latitude and longitude)
- Altitude above ground
- Compass angle (direction the camera is facing)
- Pitch angle (ascension above/below the horizon)
- Zoom factor
- Overlays this metadata on the captured photo.

Image Processing:
- Resizes the captured images to a maximum dimension of 2048 pixels to avoid memory issues and ensure manageable file sizes.
- Applies a text overlay with the collected metadata to the captured image.

Photo Storage:
- Saves the processed images to the device’s photo library in two forms:
- With the metadata overlay
- Without any overlay

Permissions:
- Requests necessary permissions from the user for location services, camera access, and photo library access.

# Technical Components
View Controllers:
- CameraController: Handles camera setup, photo capturing, pinch-to-zoom functionality, and saving photos.
- LocationController: Manages location updates, motion updates, and UI for displaying location and related data.

 Shared Data Model:
- SharedDataModel: A singleton class used to store and share metadata between the view controllers.

 UI Elements:
- Buttons for capturing photos and closing the app.
- Labels for displaying metadata (latitude, longitude, altitude, compass angle, pitch, and zoom factor).

 Permissions Handling:
- Requests permissions for camera access and location services.
- Handles authorization status for saving photos to the photo library.

 Image Processing:
- resizeImage: Function to resize images to a maximum dimension.
- overlayTextOnImage: Function to overlay metadata text on the image.

 Notifications:
- Custom notification for zoom factor updates.

# Code Summary

AppDelegate.swift:
- Sets up and displays the main view controllers (CameraController and LocationController).
CameraController.swift:
- Handles camera functionality, photo capturing, image resizing, and metadata overlay.
LocationController.swift:
- Manages location and motion updates, and displays metadata.
SharedDataModel.swift:
- Singleton class to store and share metadata.
