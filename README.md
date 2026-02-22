# Farm Visit App

## Overview

The **Farm Visit App** is a Flutter application designed for field agents or farmers to record and manage farm visits efficiently. The app allows users to store farm and crop details, including images and GPS location, with offline-first functionality. Visits are automatically synced to Firebase Firestore when internet connectivity is available.

---

## Features

- Add farm visit details:
  - Farmer Name
  - Village Name
  - Crop Type
  - Notes
  - Visit Date & Time
  - Captured Image
  - GPS Location (Latitude & Longitude)
  - Sync Status (Online/Offline)
- Offline-first: store visits locally using **Hive** when no internet is available.
- Automatic syncing: pending visits are uploaded to **Firebase Firestore** when the device is online.
- Cloud image storage via **Cloudinary**.
- Clean and responsive UI for easy viewing of visit details.
- View visit details with full information, including location and image.

---

## Tech Stack

- **Flutter** – Cross-platform mobile development
- **Hive** – Local database for offline storage
- **Firebase Firestore** – Cloud database for synced data
- **Cloudinary** – Cloud image storage
- **Connectivity Plus** – Detects internet availability
- **Geolocator** – Fetches device GPS location

---

## Release APK

You can download the signed release APK of the **Farm Visit App** here:

[Download Farm Visit App APK](./apk/farm-visit-app-release.apk)
