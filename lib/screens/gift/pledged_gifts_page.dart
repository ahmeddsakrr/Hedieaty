import 'package:flutter/material.dart';
import '../../old_models/gift.dart';
import '../../components/custom_search_bar.dart';
import '../../widgets/gift/gift_list_item.dart';

class PledgedGiftsPage extends StatefulWidget {
  const PledgedGiftsPage({super.key});

  @override
  _PledgedGiftsPageState createState() => _PledgedGiftsPageState();
}

class _PledgedGiftsPageState extends State<PledgedGiftsPage> {
  List<Gift> pledgedGifts = [
    Gift(name: 'Book', category: 'Books', status: 'Pledged', price: 12.99),
    Gift(name: 'Headphones', category: 'Electronics', status: 'Pledged', price: 49.99),
    Gift(name: 'Smartwatch', category: 'Electronics', status: 'Pledged', price: 99.99),
    Gift(name: 'Sneakers', category: 'Fashion', status: 'Pledged', price: 59.99),
    Gift(name: 'Sunglasses', category: 'Fashion', status: 'Pledged', price: 29.99),
    Gift(name: 'Backpack', category: 'Fashion', status: 'Pledged', price: 39.99),
    Gift(name: 'Coffee Maker', category: 'Home & Kitchen', status: 'Pledged', price: 24.99),
    Gift(name: 'Blender', category: 'Home & Kitchen', status: 'Pledged', price: 34.99),
  ];

  List<Gift> filteredGifts = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    filteredGifts = pledgedGifts;
  }

  void _searchGifts(String query) {
    setState(() {
      searchQuery = query;
      filteredGifts = query.isEmpty
          ? pledgedGifts
          : pledgedGifts.where((gift) => gift.name.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  void _removePledgedGift(Gift gift) {
    setState(() {
      pledgedGifts.remove(gift);
      filteredGifts = pledgedGifts.where((g) => g.name.toLowerCase().contains(searchQuery.toLowerCase())).toList();
    });
  }

  Future<void> _confirmUnpledge(Gift gift) async {
    final shouldUnpledge = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Unpledge Gift'),
          content: Text('Are you sure you want to unpledge the gift "${gift.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(Colors.grey),
                overlayColor: WidgetStateProperty.all(Colors.grey.withOpacity(0.1)),
              ),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(Colors.red),
                overlayColor: WidgetStateProperty.all(Colors.red.withOpacity(0.1)),
              ),
              child: const Text('Unpledge'),
            ),
          ],
        );
      },
    );

    if (shouldUnpledge == true) {
      _removePledgedGift(gift);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Pledged Gifts"),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomSearchBar(
                onSearch: _searchGifts,
                hintText: "Search pledged gifts...",
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: filteredGifts.isEmpty
                  ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text(
                    searchQuery.isEmpty
                        ? 'You have not pledged any gifts yet.\nStart by pledging a gift for your friends!'
                        : 'No pledged gifts found matching "$searchQuery".',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
              )
                  : ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                itemCount: filteredGifts.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16.0),
                itemBuilder: (context, index) {
                  final gift = filteredGifts[index];
                  return GiftListItem(
                    gift: gift,
                    friendName: 'Friend ${index + 1}',
                    dueDate: DateTime.now().add(Duration(days: (index + 1) * 3)),
                    customAction: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: TextButton(
                        onPressed: () => _confirmUnpledge(gift),
                        style: ButtonStyle(
                          foregroundColor: WidgetStateProperty.all(Colors.red),
                          overlayColor: WidgetStateProperty.all(Colors.red.withOpacity(0.1)),
                        ),
                        child: const Text("Unpledge"),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
