# 🌍 Country Explorer - iOS Coding Assessment

Welcome! This is my submission for the iOS Coding Assessment Challenge.

## 📱 Overview

Country Explorer is an iOS application that allows users to:
- Search for any country and view its **capital city** and **currency**.
- Add up to **5 countries** to the main screen for quick access.
- View detailed information for each country.
- Automatically detect and add the user's current country using **GPS**.
- Handle location denial gracefully by adding a default country.
- Work **offline** by saving data locally.
- Remove countries from the main view.

---

## ✅ Features

### 🌐 API Integration
- Uses [REST Countries API](https://restcountries.com/v2/all) to fetch country data.

### 🔍 Search & Add
- Real-time search for any country.
- Add up to **5 countries** to the home list.

### 🗺 Location Detection
- On first launch, uses GPS to determine the user’s country.
- If location access is denied, a **default country** (Egypt 🇪🇬 in my case) is shown.

### 💾 Local Persistence
- Caches country data for **offline access**.

### 🧭 Navigation
- Tap a country to view its **capital city** and **currency** in a detail view.

### 🧪 Unit Tests
- Includes basic unit tests for data fetching and local caching.

---

## 🛠 Technical Details

| Feature              | Implementation                      |
|----------------------|--------------------------------------|
| Language             | Swift 5                              |
| UI Framework         | SwiftUI                              |
| Architecture         | MVVM + Clean Code Principles         |
| Location             | CoreLocation                         |
| Network Layer        | Async/Await + URLSession             |
| Offline Storage      | `UserDefaults` (simple JSON storage) |
| Testing              | `XCTest`                             |
| Version Control      | Git (frequent, descriptive commits)  |

---

## 📸 Screenshots

> _Add screenshots here if desired_

---

## 🚀 Getting Started

### Requirements:
- Xcode 15+
- iOS 16+

### Run the App
1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/country-explorer.git
