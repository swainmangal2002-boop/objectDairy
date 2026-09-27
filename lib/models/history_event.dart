class HistoryEvent {
  final String id;
  final String type;
  final String title;
  final String description;
  final DateTime date;

  HistoryEvent({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.date,
  });
}