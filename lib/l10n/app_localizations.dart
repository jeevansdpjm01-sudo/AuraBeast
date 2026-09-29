import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'AuraBeast',
      'home': 'Home',
      'search': 'Search',
      'favorites': 'Favorites',
      'profile': 'Profile',
      'songs': 'Songs',
      'artist': 'Artist',
      'duration': 'Duration',
      'play': 'Play',
      'welcomeTitle': 'Welcome to AuraBeast',
      'welcomeSubtitle': 'Discover and explore amazing creatures',
      'explore': 'Explore',
      'learnMore': 'Learn More',
      'explorePressed': 'Explore button pressed!',
      'learnMorePressed': 'Learn more pressed!',
      'searchBeasts': 'Search Beasts',
      'filters': 'Filters',
      'type': 'Type',
      'rarity': 'Rarity',
      'all': 'All',
      'beastsFound': 'Beasts Found',
      'noBeastsFound': 'No Beasts Found',
      'adjustFilters': 'Try adjusting your filters or search term',
      'sortBy': 'Sort By',
      'levelHighToLow': 'Level (High to Low)',
      'nameAToZ': 'Name (A to Z)',
      'recentlyAdded': 'Recently Added',
      'filterByRarity': 'Filter By Rarity',
      'common': 'Common',
      'rare': 'Rare',
      'epic': 'Epic',
      'legendary': 'Legendary',
      'showAll': 'Show All',
      'profileTitle': 'Profile',
      'editProfile': 'Edit profile',
      'settings': 'Settings',
      'recentBeasts': 'Recent Beasts',
      'favoriteBeasts': 'Favorite Beasts',
      'viewYourFavorites': 'View your favorites',
      'achievements': 'Achievements',
      'yourBadges': 'Your badges & milestones',
      'statistics': 'Statistics',
      'viewDetailedStats': 'View detailed stats',
      'logout': 'Logout',
      'signOut': 'Sign out of your account',
      'noFavoritesYet': 'No Favorites Yet',
      'addFavoritesHint': 'Add beasts to your favorites to see them here',
      'viewDetails': 'View Details',
      'removeFromFavorites': 'Remove from Favorites',
      'viewing': 'Viewing',
      'removedFromFavorites': 'removed from favorites',
      'splashSlogan': 'Catch • Collect • Battle',
      'loadingAdventure': 'Loading your adventure...',
    },
    'ta': {
      'appTitle': 'ஆறா பீஸ்ட்',
      'home': 'முகப்பு',
      'search': 'தேடு',
      'favorites': 'பிடித்தவை',
      'profile': 'சுயவிவு',
      'songs': 'பாடல்கள்',
      'artist': 'கலைஞர்',
      'duration': 'கால அளவு',
      'play': 'இயக்கு',
      'welcomeTitle': 'ஆறா பீஸ்டிற்கு வரவேற்கிறோம்',
      'welcomeSubtitle': 'அற்புதமான உயிரினங்களை கண்டறிந்து ஆராயுங்கள்',
      'explore': 'ஆராயு',
      'learnMore': 'மேலும் கற்று கொள்ள',
      'explorePressed': 'ஆராயு பொத்தான் அழுத்தப்பட்டது!',
      'learnMorePressed': 'மேலும் கற்று கொள்ள அழுத்தப்பட்டது!',
      'searchBeasts': 'உயிரினங்களைத் தேடு',
      'filters': 'வடிகொள்ளைகள்',
      'type': 'வகை',
      'rarity': 'பிரமாணம்',
      'all': 'அனைத்தும்',
      'beastsFound': 'உயிரினங்கள் கண்டது',
      'noBeastsFound': 'உயிரினங்கள் கிடைக்கவில்லை',
      'adjustFilters': 'உங்கள் வடிகொள்ளைகளை அல்லது தேடல் சொற்றொடரை மாற்றிப் பார்க்கவும்',
      'sortBy': 'முறைப்படுத்து',
      'levelHighToLow': 'மிகை அளவிலிருந்து குறைவுக்கு',
      'nameAToZ': 'பெயர் (A முதல் Z வரை)',
      'recentlyAdded': 'சமீபத்தில் சேர்க்கப்பட்டது',
      'filterByRarity': 'பிரமாணத்தால் வடிகட்டி',
      'common': 'தொடர்புடைய',
      'rare': 'ஒன்று',
      'epic': 'ஆற்பாட்டான',
      'legendary': 'புனிதமான',
      'showAll': 'அனைத்தையும் காட்டு',
      'profileTitle': 'சுயவிவு',
      'editProfile': 'சுயவிவைத் தொகுக்கவும்',
      'settings': 'அமைப்புகள்',
      'recentBeasts': 'சமீபத்திய உயிரினங்கள்',
      'favoriteBeasts': 'பிடித்த உயிரினங்கள்',
      'viewYourFavorites': 'உங்கள் பிடித்தவை பார்க்கவும்',
      'achievements': 'பெற்றவை',
      'yourBadges': 'உங்கள்ப் பட்டங்கள் மற்றும் அட்டைகள்',
      'statistics': 'புள்ளிவிவரங்கள்',
      'viewDetailedStats': 'பருமையான புள்ளிவிவரங்களைப் பார்க்கவும்',
      'logout': 'வெளியேறு',
      'signOut': 'உங்கள் கணக்கிலிருந்து வெளியேறு',
      'noFavoritesYet': 'இனிமேலும் பிடித்தவை இல்லை',
      'addFavoritesHint': 'உங்கள் பிடித்த உயிரினங்களை இங்கே சேர்',
      'viewDetails': 'விவரங்களைப் பார்க்கவும்',
      'removeFromFavorites': 'பிடித்தவற்றில் இருந்து நீக்கு',
      'viewing': 'பார்க்கப்படுகிறது',
      'removedFromFavorites': 'பிடித்தவர்களில் இருந்து நீக்கப்பட்டது',
      'splashSlogan': 'பிடி • சேகரி • போர்',
      'loadingAdventure': 'உங்கள் சாகசத்தை ஏற்றுகிறது...',
    },
    'te': {
      'appTitle': 'ఆరాబీస్ట్',
      'home': 'హోం',
      'search': 'శోధన',
      'favorites': 'ప్రియమైనవి',
      'profile': 'ప్రొఫైల్',
      'songs': 'పాటలు',
      'artist': 'కళాకారుడు',
      'duration': 'వ్యవధి',
      'play': 'ప్లే చేయి',
      'welcomeTitle': 'ఆరాబీస్ట్‌కి స్వాగతం',
      'welcomeSubtitle': 'అద్భుతమైన సృజనలను కనుగొనండి మరియు అన్వేషించండి',
      'explore': 'గ్యాంగ్ చెయ్యి',
      'learnMore': 'ఇంకా తెలుసుకోండి',
      'explorePressed': 'గ్యాంగ్ బటన్ నొక్కబడింది!',
      'learnMorePressed': 'ఇంకా తెలుసుకోండి బటన్ నొక్కబడింది!',
      'searchBeasts': 'సృష్టులను శోధించండి',
      'filters': 'ఫిల్టర్లు',
      'type': 'రకం',
      'rarity': 'దొరకడం',
      'all': 'అందరు',
      'beastsFound': 'సృష్టులు కనబడినవి',
      'noBeastsFound': 'ఏమీ కనబడలేదు',
      'adjustFilters': 'మీ ఫిల్టర్లు లేదా శోధన పదం సవరించండి',
      'sortBy': 'వర్ణన చేయండి',
      'levelHighToLow': 'లెవల్ (పెద్దది నుండి చిన్నది)',
      'nameAToZ': 'పేరు (A నుండి Z)',
      'recentlyAdded': 'ఇప్పుడు జోడించబడింది',
      'filterByRarity': 'దొరకడం ఆధారంగా ఫిల్టర్ చేయండి',
      'common': 'సాధారణ',
      'rare': 'దుర్లభమైన',
      'epic': 'అద్భుతమైన',
      'legendary': 'పౌరాణిక',
      'showAll': 'అన్నింటిని చూపించు',
      'profileTitle': 'ప్రొఫైల్',
      'editProfile': 'ప్రొఫైల్ సవరించు',
      'settings': 'సెట్టింగ్స్',
      'recentBeasts': 'సమీపంలో జోడించినవి',
      'favoriteBeasts': 'ఇష్టమైన సృష్టులు',
      'viewYourFavorites': 'మీ ఇష్టాలను చూడండి',
      'achievements': 'సాధనాలు',
      'yourBadges': 'మీ బ్యాడ్జ్‌లు & మైలురాయిలు',
      'statistics': 'ప్రమాణాలు',
      'viewDetailedStats': 'వివరమైన ప్రమాణాలను చూడండి',
      'logout': 'లాగ్ అవుట్',
      'signOut': 'మీ ఖాతా నుండి బయటకు రండి',
      'noFavoritesYet': 'ఇంకా ఇష్టమైనవి లేవు',
      'addFavoritesHint': 'ఇక్కడ మీ ఇష్టమైన సృష్టులను జోడించండి',
      'viewDetails': 'వివరాలు చూడండి',
      'removeFromFavorites': 'ఇష్టమైనవుల నుండి తొలగించు',
      'viewing': 'చూస్తోంది',
      'removedFromFavorites': 'ఇష్టమైనవుల నుండి తొలగించబడింది',
      'splashSlogan': 'పట్టుకోండి • సేకరించండి • పోరాటం చెయ్యండి',
      'loadingAdventure': 'మీ సాహసాన్ని లోడ్ చేస్తోంది...',
    },
  };

  String _translate(String key) {
    final code = locale.languageCode;
    return _localizedValues[code]?[key] ?? _localizedValues['en']![key] ?? key;
  }

  String get appTitle => _translate('appTitle');
  String get home => _translate('home');
  String get search => _translate('search');
  String get favorites => _translate('favorites');
  String get profile => _translate('profile');
  String get songs => _translate('songs');
  String get artist => _translate('artist');
  String get duration => _translate('duration');
  String get play => _translate('play');
  String get welcomeTitle => _translate('welcomeTitle');
  String get welcomeSubtitle => _translate('welcomeSubtitle');
  String get explore => _translate('explore');
  String get learnMore => _translate('learnMore');
  String get explorePressed => _translate('explorePressed');
  String get learnMorePressed => _translate('learnMorePressed');
  String get splashSlogan => _translate('splashSlogan');
  String get loadingAdventure => _translate('loadingAdventure');
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ta', 'te'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
