class OnboardingItem {
  final String title;
  final String description;
  final String imagePath;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

class OnboardingData {
  static List<OnboardingItem> get items => [
    OnboardingItem(
      title: "Sync with Nature's Rhythm",
      description: "Align your daily routine with natural cycles for better health and productivity.",
      imagePath: "assets/images/onboarding1.png",
    ),
    OnboardingItem(
      title: "Effortless Automatic Syncing",
      description: "Set it once and let the app handle the rest. No manual adjustments needed.",
      imagePath: "assets/images/onboarding2.png",
    ),
    OnboardingItem(
      title: "Relax and Unwind",
      description: "Find your inner peace by connecting with nature's calming patterns.",
      imagePath: "assets/images/onboarding3.png",
    ),
  ];
}