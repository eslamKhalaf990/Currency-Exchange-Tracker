# Currency Exchange Tracker

A production-ready Flutter application that displays live exchange rates for 5 major currencies against the Egyptian Pound (EGP), featuring detailed historical charts and robust offline capabilities[cite: 1].

## Core Features

### Module 1: Exchange Rates List
* Tracks 5 key currency pairs: USD/EGP, EUR/EGP, GBP/EGP, SAR/EGP, JPY/EGP.
* Calculates daily fluctuations by fetching current and previous day rates.
* Displays the exchange rate (Foreign Currency to EGP) and the absolute/percentage daily change.
* Uses strict color-coding: Green for EGP strengthening, Red for EGP weakening.
* Includes pull-to-refresh functionality alongside comprehensive loading, error, and empty states.

### Module 2: Currency Detail & Historical Chart
* Dedicated view for each currency displaying current rates and absolute/percentage changes.
* Displays the date of the last update universally formatted as `dd mm yyyy`.
* Renders a 7-day historical line chart using extracted data points from the API.
* Implements a custom shimmer effect (no spinners) during chart data fetching.
* Graceful error handling with user-friendly fallback messaging.

### Module 3: Offline Cache & Resilience
* Persistent local caching layer for the most recently fetched rates.
* Serves cached data seamlessly during offline scenarios with a clear "last updated" indicator.
* Automatically refreshes and hydrates data when internet connectivity is restored.

### Architecture & Technical Stack

* **Structure:** Feature-First Clean Architecture to ensure absolute separation of concerns between Domain, Data, and Presentation layers.
* **State Management:** Domain-driven BLoC / Cubit patterns for predictable UI state transitions.
* **Dependency Injection:** Centralized service locator utilizing GetIt.
* **API Logic:** Performs inline mathematical inversion ($1 \div \text{rate}$) to convert the API's base EGP rates into the required UI display format.

### UI/UX Design System

* **Aesthetic:** An ultra-minimalist, high-contrast monochrome layout utilizing solid black, pure white, and targeted grey tones. No colored accents are used outside of the required green/red financial indicators.
* **Motion:** Incorporates continuous, looping scale transitions managed by explicit animation controllers to provide a fluid, premium feel to interactive components.

### API Reference

This project integrates a free, open-source currency exchange API:
* **Base Currency:** Strictly configured to `egp.json`.
* **Postman Collection:** Postman collection exported to `documents/Currency Exchange Tracker (EGP Base).postman_collection.json`.
* **Latest Rates:** `https://latest.currency-api.pages.dev/v1/currencies/egp.json`.
* **Historical Rates:** `https://{YYYY-MM-DD}.currency-api.pages.dev/v1/currencies/egp.json`.

### Deliverables

1. **Source Code:** Full repository with incremental, descriptive commit history.
2. **AI Usage Log:** An `AI_USAGE.md` file located at the repository root detailing end-to-end AI prompt usage, model outputs, and engineering judgments.