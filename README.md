# Acquarium Interface

![Flutter](https://img.shields.io/badge/flutter-3.10-blue.svg)
![Status: Stable](https://img.shields.io/badge/status-stable-success.svg)
![License: MIT](https://img.shields.io/badge/license-MIT-green.svg)

A cross-platform aquarium monitoring app designed for hobbyists to track water parameters, tank inhabitants, and maintenance activities with real-time integration.

## Current Status

- The project is fully functional for major features; IoT sensor integration (Arduino + Raspberry Pi) is in progress.
- All main features are operational and persist data in a dedicated database, except for notifications, which are transient.
- UI is complete with selectable light/dark themes; layout and container structure may require further tuning for optimal viewing across devices.

## Features

- **Real-Time Parameter Monitoring:** Temperature, pH, ORP, and salinity measured via connected sensors (work in progress).
- **Historical Data Visualization:** Interactive charts track parameter trends over time.
- **Aquarium Inventory:** Manage fish and coral records, populated from species databases.
- **User Tasks & Maintenance Logs:** Track cleaning operations and supplement use with persistent history.
- **Threshold Notifications:** Alerts sent to the user when critical water values are detected.
- **Theme Switching:** Light/dark mode support.
- **Data Persistence:** All measurements, livestock records, and tasks are stored in a database.

## Who is it for?

This app is designed for aquarium enthusiasts who want a unified solution for monitoring critical water parameters, eliminating the need for expensive manual tests and messy records.

## Getting Started
1. Clone the repository:
```bash
git clone https://github.com/F3rren/acquarium-interface.git
cd acquarium-interface
```
2. Install Flutter and required dependencies (see `pubspec.yaml`).

3. Configure connection to backend and database if required.

## License

This project is licensed under the MIT License.

