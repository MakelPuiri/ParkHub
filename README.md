# ParkHub

ParkHub is a Flutter parking application created for a software development sprint project. The app helps users find parking around Auckland, view parking details, check mock availability, save favourites, and move through a booking-style flow.

The project is an MVP/prototype. Some parts of the app use mock data or in-memory storage rather than a live backend.

---

## Repository Structure

The Flutter app is inside the nested `parkhub` folder:

```bash
ParkHub/
├── README.md
└── parkhub/
    ├── lib/
    ├── test/
    ├── pubspec.yaml
    └── ...
```

When running the app, make sure your terminal is inside the inner `parkhub` folder, because that is where `pubspec.yaml` is located.

---

## Main App Features

### 1. Login and Registration

ParkHub includes a basic login and account registration flow.

Current functionality includes:

- Login screen
- Register screen
- Email input
- Phone number input
- Password input
- Password visibility toggle
- Basic validation
- Mock/in-memory authentication service

The current authentication is designed for the MVP and is not yet connected to a full production backend.

---

### 2. Home Screen

The home screen displays parking options from sample parking data.

Users can:

- View nearby parking locations
- See parking name and address
- See price per hour
- See available spaces
- View distance and time limit
- Tap a parking card to open more details

---

### 3. Search Parking

The search screen allows users to search for parking by location or address.

Current functionality includes:

- Search bar
- Search button
- Results list
- Max price filter slider
- Availability filtering
- EV charging only filter
- Result count display
- Parking cards connected to the parking detail screen

Example searches:

```text
Queen
Victoria
Beach
Britomart
SkyCity
Downtown
Wynyard
```

---

### 4. Auckland Map View

The map screen is one of the main Sprint 2 features. It uses mock parking data around Auckland and displays parking locations on a map.

Current functionality includes:

- Auckland-focused map view
- Parking markers
- Mock real-time availability data
- Bottom information card for selected parking spots
- Parking name, address, price, and spaces
- Covered parking filter
- Cheapest filter
- Closest filter
- Available parking filter
- EV charging filter
- Walking-distance/search-related filter option
- Refresh-style mock availability updates
- Book Now navigation to the booking screen

The map uses mock parking spots instead of live parking provider data.

---

### 5. Parking Details

The parking detail screen shows deeper information about a selected parking location.

Details can include:

- Parking name
- Address
- Price per hour
- Availability
- Total spaces
- Available spaces
- Distance
- Time limit
- Peak times
- Off-peak times
- Predicted busy hours
- EV charging information where available
- Reviews and ratings

---

### 6. Reviews and Ratings

ParkHub includes a simple review system for parking locations.

Users can:

- View reviews
- See ratings
- Add a review
- Choose a star rating
- Write a comment
- Submit feedback for a parking location

The review system currently uses local/mock data.

---

### 7. Favourites

Users can save parking locations as favourites.

Current functionality includes:

- Favourite/bookmark button
- Save a parking location
- Remove a saved parking location
- View saved favourites on the favourites screen
- Empty message when no favourites are saved

Favourites are currently stored locally/in-memory for the MVP.

---

### 8. Booking Flow

ParkHub includes a booking screen for the parking flow.

Current functionality includes:

- Booking screen route
- Booking details layout
- Selected parking information
- Confirm booking button
- Navigation from the map screen into booking

This is currently a mock/prototype booking flow and does not process real payments.

---

### 9. Vehicle Plate Numbers

ParkHub includes a vehicle screen route for storing vehicle plate numbers.

The feature supports the Sprint 2 user story:

> As a user with more than one vehicle, I want to store multiple vehicle plate numbers in the app, so that I can easily select the correct vehicle when parking.

Expected functionality includes:

- Add vehicle plate number
- Add vehicle label/name
- Edit saved vehicle information
- Delete a saved vehicle
- Select the correct vehicle for parking

---

### 10. Notifications

The app includes a notifications route for future notification-related functionality.

This can be used later for:

- Booking reminders
- Parking expiry alerts
- Availability updates
- Payment reminders

---

### 11. Profile Screen

The profile screen provides a simple user account area.

Current/profile-related functionality includes:

- Profile layout
- User details placeholder
- Booking history option
- Settings option
- Logout option

---

### 12. Bottom Navigation

ParkHub uses a custom bottom navigation bar to move between the main screens.

Navigation includes:

1. Home
2. Favourites
3. Search
4. Map
5. Profile

---

## Tech Stack

ParkHub is built with:

- Flutter
- Dart
- Material Design

Main dependencies include:

- `flutter_map`
- `latlong2`
- `geolocator`
- `url_launcher`
- `firebase_core`
- `firebase_auth`
- `cloud_firestore`
- `geocoding`
- `http`
- `timezone`
- `flutter_local_notifications`

Some packages are included for future/live functionality, even though the current MVP still uses mock/local data in several areas.

---

## Important Project Files

```bash
lib/
├── app/
│   ├── app.dart
│   └── routes.dart
├── models/
│   ├── app_user.dart
│   ├── auth_result.dart
│   ├── favourite_area.dart
│   ├── parking_spot.dart
│   ├── parking_spot_model.dart
│   └── review_model.dart
├── screens/
│   ├── booking_screen.dart
│   ├── favourites_screen.dart
│   ├── home_screen.dart
│   ├── login_screen.dart
│   ├── map_screen.dart
│   ├── notifications_screen.dart
│   ├── parking_detail_screen.dart
│   ├── profile_screen.dart
│   ├── register_screen.dart
│   ├── search_screen.dart
│   └── vehicles_screen.dart
├── services/
│   ├── auth_service.dart
│   ├── favourites_service.dart
│   ├── parking_service.dart
│   ├── predicted_availability.dart
│   └── review_service.dart
├── themes/
├── widgets/
│   ├── custom_bottom_nav_bar.dart
│   ├── favourite_area_card.dart
│   ├── favourite_button.dart
│   ├── parking_card.dart
│   └── primary_button.dart
└── main.dart
```

---

## How to Run ParkHub

### 1. Clone the Repository

```bash
git clone https://github.com/MakelPuiri/ParkHub.git
```

### 2. Go Into the Flutter Project Folder

```bash
cd ParkHub/parkhub
```

You should now be inside the folder that contains `pubspec.yaml`.

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Check Flutter Setup

```bash
flutter doctor
```

Fix any major Flutter setup issues before running the app.

### 5. Run the App

Run on Chrome:

```bash
flutter run -d chrome
```

Run on Windows desktop:

```bash
flutter run -d windows
```

Run on a connected Android emulator/device:

```bash
flutter run
```

---

## How to Use the App

### Register a User

1. Open the app.
2. Go to the register screen.
3. Enter a phone number, email, and password.
4. Create the account.
5. Return to the login screen.

Because this is an MVP, user data may reset depending on how the mock authentication service is running.

---

### Log In

1. Open the login screen.
2. Enter the registered email and password.
3. Tap the login button.
4. The app should navigate to the home screen.

---

### Search for Parking

1. Tap the Search tab.
2. Enter a location, street, or parking name.
3. Tap Search.
4. Use the max price slider to filter results.
5. Use the EV charging filter if needed.
6. Tap a parking card to view more details.

---

### Use the Map

1. Tap the Map tab.
2. View Auckland parking locations on the map.
3. Tap a parking marker.
4. Read the selected parking information card.
5. Use filters to narrow down parking options.
6. Use Book Now to continue to the booking screen.

---

### View Parking Details

1. Open a parking result from Home, Search, or Map.
2. Review availability, price, distance, and time limits.
3. Check peak/off-peak times and predicted busy hours.
4. Check EV charging details if available.
5. Read or add reviews.

---

### Save a Favourite

1. Find a parking location.
2. Tap the favourite/bookmark icon.
3. Open the Favourites tab.
4. View saved parking locations.
5. Remove favourites when needed.

---

### Book Parking

1. Select a parking location.
2. Open the booking flow.
3. Review the booking details.
4. Confirm the booking.

This is a prototype booking flow. It does not make a real payment or reserve a real parking space.

---

## Testing

Run all tests:

```bash
flutter test
```

Run a specific test file:

```bash
flutter test test/search_parking_test.dart
```

Sprint 2 TDD work focused on the search parking feature.

Example tested user story:

> As a user, I want to search for available parking spaces near my destination, so that I can quickly find a convenient place to park.

---

## Sprint 2 Summary

Sprint 2 focused on improving the ParkHub MVP and adding features that make the app closer to a complete parking solution.

Main Sprint 2 work included:

- Auckland parking map
- Mock real-time availability
- Book Now navigation
- Parking search improvements
- Price and availability filtering
- EV charging filter
- Parking details screen updates
- Favourites/bookmark feature
- Reviews and ratings
- Vehicle plate number feature
- Notification route
- TDD evidence for search parking
- Code review evidence

---

## Current Limitations

ParkHub is still an MVP/prototype. Current limitations include:

- Parking data is mock data
- Availability is mock real-time data
- Booking is not connected to a live booking provider
- Payments are not real
- Authentication is not production-ready
- Reviews and favourites are not fully persistent in a live database
- Notifications are planned/future functionality
- Some Firebase packages are included but not all app features are fully connected to Firebase yet

---

## Future Improvements

Future development could include:

- Live parking provider API
- Real-time parking availability
- Persistent user accounts
- Firestore database integration
- Real booking system
- Secure payment integration
- Push notifications
- Parking expiry reminders
- Vehicle selection during booking
- More unit tests and widget tests
- Improved UI and accessibility

---

## Useful Git Commands

Check your current branch and changes:

```bash
git status
```

Add the README file:

```bash
git add README.md
```

Commit the README update:

```bash
git commit -m "Update README with ParkHub app features and run guide"
```

Push to main:

```bash
git push origin main
```

Create a Release branch if needed:

```bash
git checkout -b Release
git push origin Release
```

If the Release branch already exists:

```bash
git checkout Release
git merge main
git push origin Release
```

---

## Project Status

ParkHub is a sprint-based Flutter MVP for a parking aggregation app. It demonstrates the main user flows for finding parking, checking details, saving favourites, using a map, viewing mock availability, managing vehicle information, and starting a booking flow.
