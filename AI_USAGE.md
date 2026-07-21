### Entry 1: Initiating the structure
* **Timestamp:** 2026-07-20 10:28
* **Prompt:** "using feature-first architecture build directory data, domain and presentation and remove boilerplate myHomePage"
* **Model Output:** *Creating feature-first directory structure for currency_exchange feature*
* **Engineering Judgment (Accepted/Edited/Rejected):** **Edited**.
* **Reasoning:** I only changed the app theme manually
* **Associated Commit:** `chore: initial repository setup with feature-first structure and monochrome theme base`

* ### Entry 2: Building currency exchange model
* **Timestamp:** 2026-07-20 10:45
* **Prompt:** "Here is a sample of the latest currency exchange response can you build the model currency_response_model
* 
  {
  "date": "2026-07-20",
  "egp": {
  "1inch": 0.26893796,
  }}"
* Also i need to handle conversion inversion logic to show for example 1 USD = 52 EGP instead of 1 EGP = 0.911 USD).
* 
* **Model Output:** *I have created the CurrencyResponseModel in the lib/features/currency_exchange/data/models directory. I also created a corresponding CurrencyExchange entity in the lib/features/currency_exchange/domain/entities directory to follow the feature-first architecture mentioned in your AI_USAGE.md.*
* **Engineering Judgment (Accepted/Edited/Rejected):** **Accepted**.
* **Reasoning:** I checked the conversion to validate if the AI handled the 1/0 edge case
* **Associated Commit:** `feat(currency_tracker): add CurrencyResponseModel with API conversion inversion logic`

### Entry 3: Network Configuration and Data Sources
* **Timestamp:** 2026-07-20 11:15
* **Prompt:** "We use dio for networking we need to add a base url class in core to use for apis you can find them in @Currency Exchange Tracker (EGP Base).postman_collection.json ... now we need the two api endpoints fetching today and yesterday's rates concurrently using Future.wait, and the SharedPreferences caching methods."
* **Model Output:** *I have updated the ApiConfig class, implemented CurrencyRemoteDataSource with concurrent fetching using Future.wait, and implemented CurrencyLocalDataSource for caching with SharedPreferences.*
* **Engineering Judgment (Accepted/Edited/Rejected):** **Accepted**.
* **Reasoning:** Correctly handled the dynamic subdomains for historical data and ensured concurrent network calls as requested.
* **Associated Commit:** `feat(currency_tracker): add ApiConfig and data sources with concurrent fetching and caching`

### Entry 4: Repository Implementation and Historical Data Caching
* **Timestamp:** 2026-07-21 12:08
* **Prompt:** "Now we need to work on currency_repo_implementation ... well we need to cache also getLastSevenDaysRates"
* **Model Output:** *Implemented the CurrencyRepository interface and its implementation CurrencyRepositoryImpl. Updated CurrencyRemoteDataSource to fetch 7-day historical rates and CurrencyLocalDataSource to cache them, ensuring offline resilience for both the list and chart views.*
* **Engineering Judgment (Accepted/Edited/Rejected):** **Accepted**.
* **Reasoning:** Successfully implemented the repository pattern with robust offline fallback logic for all required data types.
* **Associated Commit:** `feat(currency_tracker): implement CurrencyRepository with offline-first historical data caching`

### Entry 5: Domain Use Cases and Base UseCase Class
* **Timestamp:** 2026-07-21 12:20
* **Prompt:** "We need to work on usecases in domain layer we need a usecase for GetExchangeRatesUseCase"
* **Model Output:** *Created a reusable base UseCase class in the core layer and implemented GetExchangeRatesUseCase and GetHistoricalRatesUseCase in the domain layer to encapsulate repository interactions.*
* **Engineering Judgment (Accepted/Edited/Rejected):** **Accepted**.
* **Reasoning:** Established a standardized way to execute business logic, facilitating easier testing and cleaner presentation logic.
* **Associated Commit:** `feat(currency_tracker): add domain use cases and base UseCase class`

### Entry 6: Bloc Implementation for Rates List
* **Timestamp:** 2026-07-21 03:17
* **Prompt:** "we need to work on currency exchange bloc we need RatesListBloc with explicit states: RatesListLoading, RatesListLoaded, and RatesListError"
* **Model Output:** *Implemented RatesListBloc, RatesListEvent, and RatesListState using flutter_bloc and equatable. Added necessary dependencies to pubspec.yaml and integrated GetExchangeRatesUseCase for data fetching.*
* **Engineering Judgment (Accepted/Edited/Rejected):** **Edited**.
* **Reasoning:** Updated flutter_bloc & equatable versions in .yaml Correctly implemented the Bloc pattern with requested explicit states, providing a clean interface for the UI to handle loading, success, and error scenarios.
* **Associated Commit:** `feat(currency_tracker): implement RatesListBloc with explicit states for currency exchange list`

### Entry 7: Dependency Injection Setup
* **Timestamp:** 2026-07-21 03:17
* **Prompt:** "we need a di.dart for dependency injection in core"
* **Model Output:** *Added get_it to pubspec.yaml, implemented lib/core/di/di.dart for centralizing dependency management, and updated main.dart to initialize the service locator before running the app.*
* **Engineering Judgment (Accepted/Edited/Rejected):** **Accepted**.
* **Reasoning:** Established a clean service locator pattern using GetIt, decoupling component creation from usage and facilitating better testability.
* **Associated Commit:** `feat(currency_tracker): add dependency injection using get_it`

### Entry 8: DevLog Utility and Networking Enhancement
* **Timestamp:** 2026-07-21 03:17
* **Prompt:** "we need a DevLog file to only log API requests, responses and local fetches ... we need a little enhancement for networking so we don't repeat ourselves in any get and the timeout should be 30 seconds"
* **Model Output:** *Created DevLog utility for structured logging of API and local storage operations. Enhanced the networking layer by introducing DioClient and LoggingInterceptor, centralizing the 30-second timeout configuration and automating network logs. Refactored data sources to utilize the new DioClient and DevLog.*
* **Engineering Judgment (Accepted/Edited/Rejected):** **Accepted**.
* **Reasoning:** Centralizing logging through interceptors and networking config in a DioClient significantly reduced boilerplate in data sources and improved debugging capabilities.
* **Associated Commit:** `feat(core): add DevLog and enhance networking with DioClient and interceptors`

### Entry 9: UI Implementation and Integration
* **Timestamp:** 2026-07-21 03:17
* **Prompt:** "now i need a simple view for @currency_exchange_page.dart to test it all"
* **Model Output:** *Implemented CurrencyExchangePage using BlocBuilder and ExpansionTile to display exchange rates for today and yesterday. Integrated the Bloc with the UI using BlocProvider in main.dart.*
* **Engineering Judgment (Accepted/Edited/Rejected):** **Accepted**.
* **Reasoning:** Successfully integrated all layers of the architecture (Data, Domain, Presentation) into a functional UI, providing a clear way to verify the end-to-end flow.
* **Associated Commit:** `feat(presentation): implement CurrencyExchangePage and integrate with Bloc`

### Entry 10: UI Refinement and Rate Change Logic
* **Timestamp:** 2026-07-21 03:32
* **Prompt:** "Refactor currency_exchange_page.dart to finalize the UI. Filter the data to only display USD, EUR, GBP, SAR, and JPY. Calculate the daily absolute and percentage change between today and yesterday. Color the change text Green if the rate decreased, and Red if the rate increased. Format all dates in the UI strictly as dd mm yyyy."
* **Model Output:** *Refactored CurrencyExchangePage to include specific currency filtering (USD, EUR, GBP, SAR, JPY), daily change calculations (absolute and percentage), conditional color coding (Green for decrease, Red for increase), and strict date formatting (dd mm yyyy).*
* **Engineering Judgment (Accepted/Edited/Rejected):** **Accepted**.
* **Reasoning:** Correctly implemented the requested UI enhancements, filtering, and business logic for rate change visualization while maintaining strict date formatting.
* **Associated Commit:** `feat(presentation): finalize UI with filtering, rate change calculations, and strict formatting`
