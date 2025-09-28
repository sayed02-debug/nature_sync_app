class OnboardingItem {
  final String title;
  final String description;

  const OnboardingItem({
    required this.title,
    required this.description,
  });
}

class OnboardingData {
  static List<OnboardingItem> get items => [
    const OnboardingItem(
      title: "Sync with Nature's Rhythm",
      description: "Align your daily routine with natural cycles",
    ),
    const OnboardingItem(
      title: "Effortless Automatic Syncing",
      description: "Set it once and let the app handle the rest",
    ),
    const OnboardingItem(
      title: "Relax and Unwind",
      description: "Find peace through nature-connected living",
    ),
  ];
}