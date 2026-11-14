import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import '../theme/app_theme.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('البحث والتصفية'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => context.read<EventProvider>().filterEvents(value),
              decoration: InputDecoration(
                hintText: 'ابحث عن حدث، راية، أو نص...',
                prefixIcon: const Icon(Icons.search, color: AppTheme.accentGold),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: AppTheme.accentGold),
                ),
              ),
            ),
          ),
          // Filter Chips for Entities
          SizedBox(
            height: 50,
            child: Consumer<EventProvider>(
              builder: (context, provider, child) {
                final entities = ["الكل", ...provider.events.map((e) => e.entity).toSet()];
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: entities.length,
                  itemBuilder: (context, index) {
                    final entity = entities[index];
                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: ActionChip(
                        label: Text(entity),
                        backgroundColor: const Color(0xFF1E1E1E),
                        labelStyle: const TextStyle(color: AppTheme.textOffWhite),
                        onPressed: () => provider.filterByEntity(entity),
                        side: const BorderSide(color: AppTheme.accentGold, width: 0.5),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const Expanded(
            child: TimelineListMinimal(),
          ),
        ],
      ),
    );
  }
}

class TimelineListMinimal extends StatelessWidget {
  const TimelineListMinimal({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(
      builder: (context, provider, child) {
        if (provider.filteredEvents.isEmpty) {
          return const Center(child: Text('لا توجد نتائج'));
        }

        return ListView.builder(
          itemCount: provider.filteredEvents.length,
          itemBuilder: (context, index) {
            final event = provider.filteredEvents[index];
            return ListTile(
              title: Text(event.title),
              subtitle: Text(event.timestamp),
              trailing: const Icon(Icons.chevron_left, color: AppTheme.accentGold),
              onTap: () {
                // Navigate back to timeline or show details
              },
            );
          },
        );
      },
    );
  }
}
