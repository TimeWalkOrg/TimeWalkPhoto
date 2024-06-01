# TimeWalkPhoto


TimeWalk Photo App Specifications

Purpose

	•	The app allows users to capture photos of specific locations (e.g., Times Square) and receive an image of that same location from a historical perspective (e.g., 1609, 1660, 1776).
	•	The app captures and overlays specific metadata on the photos, such as GPS coordinates, camera angle, zoom level, and more.

Key Features

	1.	Photo Capture:
	 •	Uses the device camera to capture photos.
	 •	Supports pinch-to-zoom functionality.
	 •	Plays a shutter sound when a photo is taken.
	2.	Metadata Collection:
	•	Collects and displays the following metadata for each photo:
	•	GPS coordinates (latitude and longitude)
	•	Altitude above ground
	•	Compass angle (direction the camera is facing)
	•	Pitch angle (ascension above/below the horizon)
	•	Zoom factor
	•	Overlays this metadata on the captured photo.
	3.	Image Processing:
	•	Resizes the captured images to a maximum dimension of 2048 pixels to avoid memory issues and ensure manageable file sizes.
	•	Applies a text overlay with the collected metadata to the captured image.
	4.	Photo Storage:
	•	Saves the processed images to the device’s photo library in two forms:
	•	With the metadata overlay
	•	Without any overlay
	5.	Permissions:
	•	Requests necessary permissions from the user for location services, camera access, and photo library access.

Technical Components

	1.	View Controllers:
	•	CameraController: Handles camera setup, photo capturing, pinch-to-zoom functionality, and saving photos.
	•	LocationController: Manages location updates, motion updates, and UI for displaying location and related data.
	2.	Shared Data Model:
	•	SharedDataModel: A singleton class used to store and share metadata between the view controllers.
	3.	UI Elements:
	•	Buttons for capturing photos and closing the app.
	•	Labels for displaying metadata (latitude, longitude, altitude, compass angle, pitch, and zoom factor).
	4.	Permissions Handling:
	•	Requests permissions for camera access and location services.
	•	Handles authorization status for saving photos to the photo library.
	5.	Image Processing:
	•	resizeImage: Function to resize images to a maximum dimension.
	•	overlayTextOnImage: Function to overlay metadata text on the image.
	6.	Notifications:
	•	Custom notification for zoom factor updates.

Code Summary

	1.	AppDelegate.swift:
	•	Sets up and displays the main view controllers (CameraController and LocationController).
	2.	CameraController.swift:
	•	Handles camera functionality, photo capturing, image resizing, and metadata overlay.
	3.	LocationController.swift:
	•	Manages location and motion updates, and displays metadata.
	4.	SharedDataModel.swift:
	•	Singleton class to store and share metadata.

Example Usage Scenario

	1.	User Interface:
	•	User opens the app and grants necessary permissions.
	•	User sees the camera preview with metadata displayed on the screen.
	•	User can pinch to zoom and see the zoom factor update.
	•	User captures a photo by pressing the capture button.
	2.	Behind the Scenes:
	•	The app captures the photo and metadata.
	•	The photo is resized and the metadata is overlaid.
	•	Two versions of the photo (with and without overlay) are saved to the photo library.

By following these specifications, the app provides a robust and efficient way to capture and annotate photos with important metadata, allowing users to see historical perspectives of the captured locations. If there are any additional features or adjustments needed, please let me know!
