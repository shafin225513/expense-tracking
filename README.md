# Flutter Expense Tracker App

A clean and practical **Expense Tracking application** built with **Flutter**, focused on simplicity, accuracy, and a polished user experience. The app demonstrates local data persistence, thoughtful UX decisions, and real-world financial tracking logic.

This project was built as a portfolio-quality app to showcase Flutter fundamentals, state handling, and cross-platform storage strategies.


##  Features

*  **Add Expenses Quickly** – Record expenses with amount and reason
*  **Built‑in Calculator** – Enter amounts using a calculator directly inside the app
*  **Edit Expenses** – Modify amount or reason anytime
*  **Automatic Total Calculation** – Expense totals update instantly as entries are added
*  **Polished UI** – Clean, minimal, and user‑friendly design
*  **Offline Storage** – No internet required
*  **Cross‑Platform Support** – Works on mobile and web


##  Tech Stack

* **Flutter** (UI & logic)
* **SQLite** (Initial local database for mobile)
* **Shared Preferences** (Web-compatible storage)



##  Data Persistence Strategy

The app uses a **platform-aware storage approach**:

* **SQLite** tried  for Android/iOS to provide structured and reliable local database storage and then implemented with
* **Shared Preferences** for Web compatibility where SQLite is not available

This demonstrates an understanding of:

* Platform limitations
* Conditional logic for storage selection
* Offline-first application design


##  Built‑in Calculator Logic

A custom calculator interface allows users to:

* Input expense amounts using arithmetic operations
* Avoid switching between apps
* Ensure accurate financial entries

The calculator integrates directly with the expense input flow, improving usability and reducing friction.



The structure emphasizes separation of concerns and easy maintainability.


##  Limitations & Future Improvements

* Category-based expense grouping
* Monthly / yearly reports
* Charts & analytics
* Cloud sync support
* Export to CSV / PDF


##  Purpose

This project was built to demonstrate:

* Flutter UI design principles
* Local data persistence
* Calculator and business logic implementation
* Cross-platform compatibility



##  Author

**Shafin**

Flutter Developer | Focused on clean UI and practical applications


##  Acknowledgements

* Flutter documentation
* SQLite
* Shared Preferences


> This app highlights strong Flutter fundamentals and thoughtful UX design for real-world use cases.

