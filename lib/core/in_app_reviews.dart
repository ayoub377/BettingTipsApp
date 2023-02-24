import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_review/in_app_review.dart';


final InAppReview inAppReview = InAppReview.instance;

Future<void> showReviewPrompt() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  DateTime installationDate = DateTime.fromMillisecondsSinceEpoch(
    prefs.getInt('installationDate') ?? DateTime.now().millisecondsSinceEpoch,
  );
  int daysSinceInstallation = DateTime.now().difference(installationDate).inDays;

  if (daysSinceInstallation >= 7 && await inAppReview.isAvailable()) {
    // Show the in-app review prompt.
    inAppReview.requestReview();
  }
}

void storeInstallationDate() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('installationDate', DateTime.now().millisecondsSinceEpoch);
}
