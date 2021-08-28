class Changelog{
  final String version;
  final List<String> details;

  Changelog({
    required this.version,
    required this.details
  });
}

List<Changelog> changelogs = [
  // Changelog(
  //   version: "Version: 1.0.0",
  //   details: [
  //     "Initial Release",
  //   ],
  // ),
  Changelog(
    version: "Version: 0.9.0",
    details: [
      "Beta"
    ]
  ),
];