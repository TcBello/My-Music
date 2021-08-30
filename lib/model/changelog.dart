class Changelog{
  final String version;
  final List<String> details;

  Changelog({
    required this.version,
    required this.details
  });
}

List<Changelog> changelogs = [
  Changelog(
    version: "Version: 1.0.1",
    details: [
      "Fix searching songs that are deleted bug",
      'Change "<unknown>" to "Unknown Artist"',
      "Fix placeholder when data is empty"
    ]
  ),
  Changelog(
    version: "Version: 1.0.0",
    details: [
      "Added support on android 10",
      "Added all songs in artist",
      "Fix search song bug"
    ],
  ),
  Changelog(
    version: "Version: 0.9.0",
    details: [
      "Beta"
    ]
  ),
];