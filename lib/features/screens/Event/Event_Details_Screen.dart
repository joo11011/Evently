import 'dart:async';

import 'package:evently/features/cubit/Event_Cubit.dart';
import 'package:evently/core/constants/app_colors.dart';
import 'package:evently/core/constants/app_strings.dart';
import 'package:evently/core/Extension.dart';
import 'package:evently/data/model/event.dart';
import 'package:evently/features/screens/widgets/map_widget.dart';
import 'package:evently/features/widget/elevated_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class EventDetailsScreen extends StatefulWidget {
  final Event event;
  const EventDetailsScreen({super.key, required this.event});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  late Timer _countdownTimer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _calculateRemaining();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _calculateRemaining();
    });
  }

  void _calculateRemaining() {
    final eventDateTime = _parseEventDateTime();
    if (eventDateTime != null) {
      final now = DateTime.now();
      setState(() {
        _remaining = eventDateTime.difference(now);
        if (_remaining.isNegative) _remaining = Duration.zero;
      });
    }
  }

  DateTime? _parseEventDateTime() {
    if (widget.event.date == null || widget.event.date!.isEmpty) return null;
    DateTime? date = DateTime.tryParse(widget.event.date!);
    if (date == null) return null;
    if (widget.event.time != null && widget.event.time!.isNotEmpty) {
      try {
        final parts = widget.event.time!.split(':');
        final hour = int.parse(parts[0]);
        final minute = parts.length > 1 ? int.parse(parts[1]) : 0;
        date = DateTime(date.year, date.month, date.day, hour, minute);
      } catch (_) {}
    }
    return date;
  }

  @override
  void dispose() {
    _countdownTimer.cancel();
    super.dispose();
  }

  void _shareEvent() {
    final event = widget.event;
    final text =
        '''
🎉 ${event.title ?? ''}

📅 ${event.date ?? ''}
⏰ ${event.time ?? ''}
📍 ${(event.latitude != null && event.longitude != null) ? 'Location: https://maps.google.com/?q=${event.latitude},${event.longitude}' : ''}

📝 ${event.desc ?? ''}
''';
    Clipboard.setData(ClipboardData(text: text.trim()));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text(context.locale.eventCopied),
          ],
        ),
        backgroundColor: AppColors.purple,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _confirmDelete(EventCubit eventCubit) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.red),
            const SizedBox(width: 8),
            Text(context.locale.deleteConfirmTitle),
          ],
        ),
        content: Text(context.locale.deleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              context.locale.cancel,
              style: TextStyle(color: AppColors.purple),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              context.locale.deleteText,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await eventCubit.deleteEvent(widget.event.id ?? " ");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.delete_outline, color: Colors.white),
                const SizedBox(width: 8),
                Text(context.locale.eventDeleted),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        Navigator.popAndPushNamed(context, AppStrings.home);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventCubit()..setEvent(widget.event),
      child: BlocConsumer<EventCubit, EventState>(
        listener: (context, state) {},
        builder: (context, state) {
          final eventcubit = context.read<EventCubit>();
          return Scaffold(
            appBar: AppBar(
              title: Text(context.locale.eventDetails),
              actions: [
                IconButton(
                  onPressed: _shareEvent,
                  icon: Icon(Icons.share, color: AppColors.purple),
                  tooltip: context.locale.shareEvent,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppStrings.editEvent,
                      arguments: widget.event,
                    );
                  },
                  icon: Icon(Icons.edit, color: AppColors.purple),
                ),
                IconButton(
                  onPressed: () => _confirmDelete(eventcubit),
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 360,
                        height: 200,
                        child: ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(16),
                          child: Hero(
                            tag: 'event_image_${widget.event.id}',
                            child: Image.asset(
                              widget.event.image ?? " ",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Center(
                      child: Text(
                        widget.event.title ?? " ",
                        style: context.textTheme.labelMedium!.copyWith(
                          fontSize: 24,
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                    // Countdown Timer
                    _buildCountdown(context),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                    Elevatedbtn(
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: AppColors.purple,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.calendar_month_outlined,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.height * 0.01,
                            ),
                            Column(
                              children: [
                                Builder(
                                  builder: (context) {
                                    DateTime? parsedDate;
                                    if (widget.event.date != null &&
                                        widget.event.date!.isNotEmpty) {
                                      parsedDate = DateTime.tryParse(
                                        widget.event.date!,
                                      );
                                    }
                                    final dateText = parsedDate != null
                                        ? DateFormat(
                                            'd MMM yyyy',
                                          ).format(parsedDate)
                                        : '';
                                    return Text(
                                      dateText,
                                      style: context.textTheme.labelMedium,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                    Elevatedbtn(
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: AppColors.purple,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.my_location,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.height * 0.01,
                            ),
                            Text(
                              context.locale.cairoEgypt,
                              style: context.textTheme.labelMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Container(
                      height: 360,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.purple, width: 2),
                      ),
                      child: MapWidget(eventCubit: eventcubit),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Text(
                      context.locale.description,
                      style: context.textTheme.bodySmall!.copyWith(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      widget.event.desc ?? " ",
                      style: context.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCountdown(BuildContext context) {
    final bool hasStarted = _remaining == Duration.zero;

    if (hasStarted) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.celebration, color: Colors.green),
            const SizedBox(width: 8),
            Text(
              context.locale.eventStarted,
              style: context.textTheme.labelMedium?.copyWith(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    final days = _remaining.inDays;
    final hours = _remaining.inHours.remainder(24);
    final minutes = _remaining.inMinutes.remainder(60);
    final seconds = _remaining.inSeconds.remainder(60);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.purple.withOpacity(0.1),
            AppColors.navyBlue.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.purple.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _countdownUnit(
            context,
            days.toString().padLeft(2, '0'),
            context.locale.days,
          ),
          _divider(),
          _countdownUnit(
            context,
            hours.toString().padLeft(2, '0'),
            context.locale.hours,
          ),
          _divider(),
          _countdownUnit(
            context,
            minutes.toString().padLeft(2, '0'),
            context.locale.minutes,
          ),
          _divider(),
          _countdownUnit(
            context,
            seconds.toString().padLeft(2, '0'),
            context.locale.seconds,
          ),
        ],
      ),
    );
  }

  Widget _countdownUnit(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: context.textTheme.bodyLarge?.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.purple,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(
            fontSize: 12,
            color: AppColors.purple.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Text(
      ':',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.purple.withOpacity(0.5),
      ),
    );
  }
}
