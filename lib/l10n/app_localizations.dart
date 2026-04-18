import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @mirrorOriginal.
  ///
  /// In en, this message translates to:
  /// **'Mirror Original'**
  String get mirrorOriginal;

  /// No description provided for @chooseHowToContinue.
  ///
  /// In en, this message translates to:
  /// **'Choose how you want to continue with CAVO.'**
  String get chooseHowToContinue;

  /// No description provided for @languageSupportSummary.
  ///
  /// In en, this message translates to:
  /// **'English default • Arabic • Russian • German'**
  String get languageSupportSummary;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @continueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get continueAsGuest;

  /// No description provided for @refinedByCavo.
  ///
  /// In en, this message translates to:
  /// **'Refined by CAVO'**
  String get refinedByCavo;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @signInToAccessCart.
  ///
  /// In en, this message translates to:
  /// **'Sign in to access your cart, saved preferences, and future orders.'**
  String get signInToAccessCart;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailAddress;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @newToCavo.
  ///
  /// In en, this message translates to:
  /// **'New to CAVO?'**
  String get newToCavo;

  /// No description provided for @createAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'Create your account to save your style preferences and manage your future orders.'**
  String get createAccountDescription;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @mirrorOriginalPremiumFootwear.
  ///
  /// In en, this message translates to:
  /// **'Mirror Original • Premium Footwear'**
  String get mirrorOriginalPremiumFootwear;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @joinCavoToSave.
  ///
  /// In en, this message translates to:
  /// **'Join CAVO to save your cart, preferences, and future orders.'**
  String get joinCavoToSave;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @signInAndContinue.
  ///
  /// In en, this message translates to:
  /// **'Sign in and continue shopping with your saved preferences.'**
  String get signInAndContinue;

  /// No description provided for @goToLogin.
  ///
  /// In en, this message translates to:
  /// **'Go to Login'**
  String get goToLogin;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @personalizeCavoExperience.
  ///
  /// In en, this message translates to:
  /// **'Personalize the CAVO experience'**
  String get personalizeCavoExperience;

  /// No description provided for @cavoMember.
  ///
  /// In en, this message translates to:
  /// **'CAVO Member'**
  String get cavoMember;

  /// No description provided for @guestModeSignInForFullAccess.
  ///
  /// In en, this message translates to:
  /// **'Guest mode • Sign in for full access'**
  String get guestModeSignInForFullAccess;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @createAccountToSaveCartManageOrders.
  ///
  /// In en, this message translates to:
  /// **'Create an account to save your cart, manage orders, and sync your preferences.'**
  String get createAccountToSaveCartManageOrders;

  /// No description provided for @quickAccess.
  ///
  /// In en, this message translates to:
  /// **'Quick Access'**
  String get quickAccess;

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @links.
  ///
  /// In en, this message translates to:
  /// **'Links'**
  String get links;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @savedAddresses.
  ///
  /// In en, this message translates to:
  /// **'Saved Addresses'**
  String get savedAddresses;

  /// No description provided for @manageDeliveryDetails.
  ///
  /// In en, this message translates to:
  /// **'Manage delivery details'**
  String get manageDeliveryDetails;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @reachCavoSupportQuickly.
  ///
  /// In en, this message translates to:
  /// **'Reach CAVO support quickly'**
  String get reachCavoSupportQuickly;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @comingNextStep.
  ///
  /// In en, this message translates to:
  /// **'{title} will be connected in the next step.'**
  String comingNextStep(String title);

  /// No description provided for @men.
  ///
  /// In en, this message translates to:
  /// **'Men'**
  String get men;

  /// No description provided for @women.
  ///
  /// In en, this message translates to:
  /// **'Women'**
  String get women;

  /// No description provided for @kids.
  ///
  /// In en, this message translates to:
  /// **'Kids'**
  String get kids;

  /// No description provided for @offerSelectedForPremiumShowcase.
  ///
  /// In en, this message translates to:
  /// **'Offer selected for premium showcase'**
  String get offerSelectedForPremiumShowcase;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @browse.
  ///
  /// In en, this message translates to:
  /// **'Browse'**
  String get browse;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose language'**
  String get chooseLanguage;

  /// No description provided for @languageSelectionDescription.
  ///
  /// In en, this message translates to:
  /// **'Your selected language will stay saved the next time you open CAVO.'**
  String get languageSelectionDescription;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @russian.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get russian;

  /// No description provided for @german.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get german;

  /// No description provided for @authInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get authInvalidEmail;

  /// No description provided for @authInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Email or password is not correct.'**
  String get authInvalidCredentials;

  /// No description provided for @authUserDisabled.
  ///
  /// In en, this message translates to:
  /// **'This account has been disabled.'**
  String get authUserDisabled;

  /// No description provided for @authTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please try again later.'**
  String get authTooManyRequests;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get somethingWentWrong;

  /// No description provided for @completeAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please complete all fields.'**
  String get completeAllFields;

  /// No description provided for @forgotPasswordSoon.
  ///
  /// In en, this message translates to:
  /// **'Password reset will be connected in the next step.'**
  String get forgotPasswordSoon;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get passwordsDoNotMatch;

  /// No description provided for @passwordMustBeAtLeastSix.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters.'**
  String get passwordMustBeAtLeastSix;

  /// No description provided for @authEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'This email is already in use.'**
  String get authEmailInUse;

  /// No description provided for @authWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Please choose a stronger password.'**
  String get authWeakPassword;

  /// No description provided for @myAccount.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get myAccount;

  /// No description provided for @accountStatus.
  ///
  /// In en, this message translates to:
  /// **'Account status'**
  String get accountStatus;

  /// No description provided for @signedInSecurely.
  ///
  /// In en, this message translates to:
  /// **'Signed in securely'**
  String get signedInSecurely;

  /// No description provided for @loggedOutSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Logged out successfully.'**
  String get loggedOutSuccessfully;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @linksIntro.
  ///
  /// In en, this message translates to:
  /// **'All CAVO contact points in one place'**
  String get linksIntro;

  /// No description provided for @contactHub.
  ///
  /// In en, this message translates to:
  /// **'CAVO Contact Hub'**
  String get contactHub;

  /// No description provided for @directContact.
  ///
  /// In en, this message translates to:
  /// **'Direct Contact'**
  String get directContact;

  /// No description provided for @whatsAppSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fast orders and direct communication'**
  String get whatsAppSubtitle;

  /// No description provided for @storeLocation.
  ///
  /// In en, this message translates to:
  /// **'Store Location'**
  String get storeLocation;

  /// No description provided for @storeLocationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Open location in Google Maps'**
  String get storeLocationSubtitle;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

  /// No description provided for @websiteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Open store website • English / Arabic'**
  String get websiteSubtitle;

  /// No description provided for @social.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get social;

  /// No description provided for @telegramSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Cavo_store channel'**
  String get telegramSubtitle;

  /// No description provided for @facebookSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Official Facebook page'**
  String get facebookSubtitle;

  /// No description provided for @unableToOpenLink.
  ///
  /// In en, this message translates to:
  /// **'Unable to open this link right now.'**
  String get unableToOpenLink;

  /// No description provided for @item.
  ///
  /// In en, this message translates to:
  /// **'item'**
  String get item;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get items;

  /// No description provided for @readyForCheckout.
  ///
  /// In en, this message translates to:
  /// **'ready for checkout'**
  String get readyForCheckout;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @storePickup.
  ///
  /// In en, this message translates to:
  /// **'Store Pickup'**
  String get storePickup;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @proceedToCheckout.
  ///
  /// In en, this message translates to:
  /// **'Proceed to Checkout'**
  String get proceedToCheckout;

  /// No description provided for @continueShopping.
  ///
  /// In en, this message translates to:
  /// **'Continue Shopping'**
  String get continueShopping;

  /// No description provided for @noSizeSelected.
  ///
  /// In en, this message translates to:
  /// **'No size selected'**
  String get noSizeSelected;

  /// No description provided for @yourCartIsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get yourCartIsEmpty;

  /// No description provided for @startAddingFavorites.
  ///
  /// In en, this message translates to:
  /// **'Start adding your favorite premium pieces to see them here.'**
  String get startAddingFavorites;

  /// No description provided for @exploreCollection.
  ///
  /// In en, this message translates to:
  /// **'Explore Collection'**
  String get exploreCollection;

  /// No description provided for @searchProductsBrands.
  ///
  /// In en, this message translates to:
  /// **'Search products, brands...'**
  String get searchProductsBrands;

  /// No description provided for @shopByCategory.
  ///
  /// In en, this message translates to:
  /// **'Shop by Category'**
  String get shopByCategory;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @topBrands.
  ///
  /// In en, this message translates to:
  /// **'Top Brands'**
  String get topBrands;

  /// No description provided for @curated.
  ///
  /// In en, this message translates to:
  /// **'Curated'**
  String get curated;

  /// No description provided for @featuredCollection.
  ///
  /// In en, this message translates to:
  /// **'Featured Collection'**
  String get featuredCollection;

  /// No description provided for @premium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premium;

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get selected;

  /// No description provided for @shopNow.
  ///
  /// In en, this message translates to:
  /// **'Shop Now'**
  String get shopNow;

  /// No description provided for @newCollection.
  ///
  /// In en, this message translates to:
  /// **'New Collection'**
  String get newCollection;

  /// No description provided for @premiumFootwearDesignedToStandApart.
  ///
  /// In en, this message translates to:
  /// **'Premium Footwear\nDesigned to Stand\nApart'**
  String get premiumFootwearDesignedToStandApart;

  /// No description provided for @mirrorOriginalPiecesRefined.
  ///
  /// In en, this message translates to:
  /// **'Mirror Original pieces with a refined luxury feel.'**
  String get mirrorOriginalPiecesRefined;

  /// No description provided for @browseCollection.
  ///
  /// In en, this message translates to:
  /// **'Browse Collection'**
  String get browseCollection;

  /// No description provided for @itemsCountLabel.
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get itemsCountLabel;

  /// No description provided for @brandsTitle.
  ///
  /// In en, this message translates to:
  /// **'Brands'**
  String get brandsTitle;

  /// No description provided for @newProductsPreparing.
  ///
  /// In en, this message translates to:
  /// **'New products are being prepared for this section.'**
  String get newProductsPreparing;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @availableSizes.
  ///
  /// In en, this message translates to:
  /// **'Available Sizes'**
  String get availableSizes;

  /// No description provided for @selectYourSize.
  ///
  /// In en, this message translates to:
  /// **'Select your size'**
  String get selectYourSize;

  /// No description provided for @selectedSize.
  ///
  /// In en, this message translates to:
  /// **'Selected size'**
  String get selectedSize;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get addToCart;

  /// No description provided for @addedToCart.
  ///
  /// In en, this message translates to:
  /// **'added to cart.'**
  String get addedToCart;

  /// No description provided for @offersTitle.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get offersTitle;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @size.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get size;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'de', 'en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
