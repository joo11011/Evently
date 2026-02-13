import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently/features/cubit/Layout_Cubit.dart';
import 'package:evently/core/constants/app_colors.dart';
import 'package:evently/core/constants/app_strings.dart';
import 'package:evently/core/Extension.dart';
import 'package:evently/data/model/event.dart';
import 'package:evently/data/web_services/layout_service.dart';
import 'package:evently/features/screens/widgets/event_style.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoveScreen extends StatefulWidget {
  const LoveScreen({super.key});

  @override
  State<LoveScreen> createState() => _LoveScreenState();
}

class _LoveScreenState extends State<LoveScreen> {
  late TextEditingController searchController;
  String searchQuery = '';
  List<QueryDocumentSnapshot<Event>> _allEvents = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.toLowerCase();
      });
    });
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final events = await LayoutService.getFavorite();
      if (mounted) {
        setState(() {
          _allEvents = events;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<QueryDocumentSnapshot<Event>> get _filteredEvents {
    if (searchQuery.isEmpty) {
      return _allEvents;
    }
    return _allEvents.where((eventSnapshot) {
      var event = eventSnapshot.data();
      String title = (event.title ?? '').toLowerCase();
      String description = (event.desc ?? '').toLowerCase();
      return title.contains(searchQuery) || description.contains(searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LayoutCubit(),
      child: BlocConsumer<LayoutCubit, LayoutState>(
        listener: (context, state) {},
        builder: (context, state) {
          final layoutCubit = BlocProvider.of<LayoutCubit>(context);
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: searchController,
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus!.unfocus();
                    },
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: AppColors.purple),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: AppColors.purple,
                          width: 2,
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors.purple,
                        size: 35,
                      ),
                      suffixIcon: searchQuery.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear, color: AppColors.purple),
                              onPressed: () {
                                searchController.clear();
                                setState(() {
                                  searchQuery = '';
                                });
                              },
                            )
                          : null,
                      hintText: context.locale.searchForEvent,
                      hintStyle: context.textTheme.headlineLarge!.copyWith(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(child: _buildContent(context, layoutCubit)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, LayoutCubit layoutCubit) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: AppColors.purple));
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(_errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadFavorites,
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }

    final filtered = _filteredEvents;

    if (filtered.isEmpty) {
      return FadeIn(
        duration: const Duration(milliseconds: 500),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.purple.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  searchQuery.isEmpty
                      ? Icons.favorite_border
                      : Icons.search_off,
                  size: 72,
                  color: AppColors.purple.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                searchQuery.isEmpty
                    ? context.locale.noFavoriteEvents
                    : context.locale.noEventsMatch,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.purple,
      onRefresh: _loadFavorites,
      child: ListView.builder(
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          var eventSnapshot = filtered[index];
          var event = eventSnapshot.data();
          return FadeInUp(
            duration: const Duration(milliseconds: 400),
            delay: Duration(milliseconds: 80 * index),
            child: Dismissible(
              key: ValueKey(event.id ?? index),
              direction: DismissDirection.endToStart,
              background: Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 24),
                child: const Icon(
                  Icons.heart_broken,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              onDismissed: (_) {
                // Optimistically remove from local list
                setState(() {
                  _allEvents.removeWhere((e) => e.data().id == event.id);
                });

                // Call API
                layoutCubit.toggleFavorite(event).catchError((e) {
                  // Revert if failed (reload)
                  _loadFavorites();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Failed to remove: $e")),
                    );
                  }
                });

                // Show success snackbar
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(
                          Icons.heart_broken,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(context.locale.removedFromFavorites),
                      ],
                    ),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppStrings.eventDetails,
                    arguments: event,
                  );
                },
                child: EventStyle(
                  event: event,
                  onTap: () {
                    // Logic for tapping heart icon (redundant in fav screen but keeps consistency)
                    // If user taps heart in fav screen, it should probably also remove it?
                    // Original code: layoutCubit.toggleFavorite(event); setState((){});
                    // New logic:
                    setState(() {
                      _allEvents.removeWhere((e) => e.data().id == event.id);
                    });
                    layoutCubit.toggleFavorite(event);
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
