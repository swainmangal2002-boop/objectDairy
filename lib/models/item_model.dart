import 'history_event.dart';

class Item {
  final String id;
  String name;
  String category;
  DateTime purchaseDate;
  double purchasePrice;
  String location;
  DateTime? warrantyExpiry;
  String description;

  final List<HistoryEvent> history;

  Item({
    required this.id,
    required this.name,
    required this.category,
    required this.purchaseDate,
    required this.purchasePrice,
    required this.location,
    this.warrantyExpiry,
    this.description = '',
    List<HistoryEvent>? history,
  }) : history = history ?? [];
}