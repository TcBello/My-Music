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
    version: "2.1.0",
    details: [
      "Added scroll bar",
    ]
  ),
  Changelog(
    version: "2.0.1",
    details: [
      "Improve performance on miniplayer",
      "Improve performance on font selection",
      "Improve performance of a background when blur is applied",
      "Improve user interface"
    ]
  ),
  Changelog(
    version: "2.0.0",
    details: [
      "Added support in android 11",
      "Fix some bugs"
    ]
  ),
  Changelog(
    version: "1.1.0",
    details: [
      "Added skip next in collapsed miniplayer",
      "Changed color of shuffle and repeat when on",
      "Added indicator when pressing shuffle and repeat"
    ]
  ),
  Changelog(
    version: "1.0.1",
    details: [
      "Fix searching songs that are deleted bug",
      'Change "<unknown>" to "Unknown Artist"',
      "Fix placeholder when data is empty",
      "Improve performance of search songs"
    ]
  ),
  Changelog(
    version: "1.0.0",
    details: [
      "Added support on android 10",
      "Added all songs in artist",
      "Fix search song bug"
    ],
  ),
  Changelog(
    version: "0.9.0",
    details: [
      "Beta"
    ]
  ),
];