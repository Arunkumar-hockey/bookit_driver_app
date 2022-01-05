class onboardinginfo {
  final String imageUrl;
  final String title;
  final String description;
  onboardinginfo({
    required this.imageUrl,
    required this.title,
    required this.description,
  });
}
final slideList = [
  onboardinginfo(
    imageUrl: 'assets/introimg1.png',
    title: 'Accept a Ride',
    description: 'Accept the ride as soon as you receive request from customer',
  ),
  onboardinginfo(
    imageUrl: 'assets/introimg2.png',
    title: 'Choose your Place',
    description: 'Choose the short distance to reach your destination faster',
  ),
  onboardinginfo(
    imageUrl: 'assets/introimg3.png',
    title: '24/7 Service',
    description: 'Anywhere Anytime at your service',
  ),
];