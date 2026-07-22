# Currency Exchange Tracker

A production-ready Flutter application that displays live exchange rates for 5 major currencies against the Egyptian Pound (EGP), featuring detailed historical charts and robust offline capabilities.

## Core Features

### 1. Exchange Rates List
* **Currencies Tracked:** USD, EUR, GBP, SAR, and JPY against the Egyptian Pound (EGP).
* **Live Analytics:** Calculates daily fluctuations by comparing current and previous day rates.
* **Visual Indicators:** Uses strict financial color-coding (Green for EGP strengthening, Red for EGP weakening).
* **Interactive UI:** Supports pull-to-refresh and handles all states (loading, error, and empty).

### 2. Currency Detail & Historical Insights
* **Detailed View:** Displays current rates, absolute change, and percentage change.
* **Historical Charts:** Renders a 7-day historical line chart using `fl_chart`.
* **Smart Loading:** Implements custom shimmer effects for a premium feel during data fetching.
* **Formatted Data:** Dates are universally formatted as `dd MMM yyyy`.

### 3. Offline Resilience
* **Local Caching:** Uses `shared_preferences` to cache the most recently fetched rates.
* **Seamless Transition:** Serves cached data during offline scenarios with a "last updated" indicator.
* **Auto-Sync:** Automatically refreshes data when internet connectivity is restored.

---

## Tech Stack & Packages

### Architecture
* **Clean Architecture:** Feature-first approach separating Domain, Data, and Presentation layers.
* **State Management:** `flutter_bloc` (Cubit) for predictable state transitions.
* **Dependency Injection:** `get_it` for service location.

### Key Packages
* **Networking:** `dio` for API requests and interceptions.
* **Functional Programming:** `dartz` for handling successes and failures (Either).
* **Charts:** `fl_chart` for historical data visualization.
* **UI Effects:** `shimmer` for loading states.
* **Connectivity:** `internet_connection_checker_plus` for real-time network monitoring.
* **Utilities:** `equatable`, `intl`, `shared_preferences`.

---

## Development Environment

To ensure consistency, the project was developed using the following environment:

* **IDE:** Android Studio Panda 3 | 2025.3.3 Patch 1
* **Flutter SDK:** `v3.41.9`
* **Dart SDK:** `v3.11.5`
* **Gradle:** `8.14`
* **Android Gradle Plugin (AGP):** `8.11.1`
* **Kotlin:** `2.2.20`

---

## Getting Started

### Prerequisites
1. Install [Flutter SDK](https://docs.flutter.dev/get-started/install).
2. Ensure you have a valid Android/iOS development environment.

### Installation & Setup
1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/currency_exchange_tracker.git
   cd currency_exchange_tracker
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

---

## API Reference

This project integrates a free, open-source currency exchange API:
* **Base Currency:** Strictly configured to `egp.json`.
* **Latest Rates:** `https://latest.currency-api.pages.dev/v1/currencies/egp.json`
* **Historical Rates:** `https://{YYYY-MM-DD}.currency-api.pages.dev/v1/currencies/egp.json`
* **Documentation:** A Postman collection is available in `documents/`.

## Deliverables
* **AI Usage Log:** See `AI_USAGE.md` for details on the development process.