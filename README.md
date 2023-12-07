# Fueler: Fuel Tracker
![](https://i.imgur.com/avslxz8.png)

This is a cross-platform app that is made with Flutter. With this app, you can track your fuel expenses for your vehicles.
You can; 
add multiple vehicles, 
add fuel expense for selected vehicle and date,
search fuels with vhicle name,
add a receipt photo while adding fuel expense and view it on the fuel detail page,
view expense statistics for all vehicles,
export all data(as csv file) with receipt photos to your email address.

You can download from app markets: [Apple AppStore](https://apps.apple.com/us/app/fueler-fuel-tracker/id1517581377 "Apple AppStore") or[ Google PlayStore](https://play.google.com/store/apps/details?id=com.foytingo.fueler_new "Google PlayStore").


#### Features
- Made with Flutter
- Firebase Auth for user operations
- Firebase Cloud Firestore for data persistence
- Firebase Storage for keeping receipt photos.
- Apple Sign In with [sign_in_with_apple](https://pub.dev/packages/sign_in_with_apple "sign_in_with_apple") package for Apple devices
- Google Sign In with [google_sign_in](https://pub.dev/packages/google_sign_in "google_sign_in") for android devices.
- [image_picker](https://pub.dev/packages/image_picker "image_picker")  for select receipt photo and [flutter_image_compress](https://pub.dev/packages/flutter_image_compress "flutter_image_compress") for compress this selected receipt photo.
- [csv](https://pub.dev/packages/csv "csv") for formatting data as csv file and  [flutter_archive](https://pub.dev/packages/flutter_archive "flutter_archive") for compress all receipt photo as zip file and [mailer](https://pub.dev/packages/mailer "mailer") package for sending mail with csv and zip file.
- [connectivity_plus](https://pub.dev/packages/connectivity_plus "connectivity_plus") for checking internet connection.
- Proper error handling with adaptive alert dialog and ScaffoldMessages.
- Asynchronous programming (Future, async/await)
- Loading screen while saving/getting data from Firebase with [loading_animation_widget](https://pub.dev/packages/loading_animation_widget "loading_animation_widget") package.
- Localization for currency symbol/name, date format and language(English and Turkish).


#### Screenshots

![](https://i.imgur.com/KNAFcCg.png)
![](https://i.imgur.com/97gxMG7.png)


### License

This project is licensed under the GNU GPLv3 - see the LICENSE.md file for details
