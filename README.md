Bock Foods - Flutter Starter (Green themed)
==========================================

What is included:
- A Flutter app skeleton with Home, Restaurants, Restaurant Detail, Cart, Checkout, Instamart, Search, Account.
- Provider-based Cart (add/remove/clear).
- Responsive-friendly layout (works on mobile and web).
- Primary CTA color set to green (#00A676).

How to run:
1. Ensure Flutter SDK is installed and in PATH.
2. Extract the zip or open this folder in your editor.
3. Run `flutter pub get`.
4. Run `flutter run -d chrome` for web, or `flutter run` for a connected device.

Notes:
- Images are placeholders. Replace assets/images with real images and update FoodItem.imageUrl if needed.
- This is a production-ready starting point; you can extend components, styles, and integrate backend APIs.


## Recent UI changes

- Updated home screen to match the provided mobile UI mockup (Oct 2025):
  - Added a top informational header and a prominent orange "Restaurants" card with circular image overlay.
  - Added three category tiles (Genie, Grocery, Meat) below the restaurants card.
  - Added a "Top Picks For You" horizontal scroller showing circular item tiles.
  - Kept the existing food list below; updated the ADD button to use an orange accent to match the new header.

These changes were implemented in `lib/screens/home_screen.dart` and `lib/widgets/food_card.dart`.

