import '../models/item_model.dart';

class ItemService {
  final List<Item> _items = [];

  List<Item> get items => List.unmodifiable(_items);

  void addItem(Item item) {
    _items.add(item);
  }

  void updateItem(Item item) {
    final index = _items.indexWhere((element) => element.id == item.id);

    if (index != -1) {
      _items[index] = item;
    }
  }

  void deleteItem(String id) {
    _items.removeWhere((item) => item.id == id);
  }
}