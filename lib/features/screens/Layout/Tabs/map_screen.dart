import 'dart:ui';

import 'package:evently/features/cubit/Layout_Cubit.dart';
import 'package:evently/core/constants/app_colors.dart';
import 'package:evently/core/Extension.dart';
import 'package:evently/data/model/category.dart';
import 'package:evently/data/web_services/layout_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LayoutCubit(),
      child: BlocConsumer<LayoutCubit, LayoutState>(
        listener: (context, state) {},
        builder: (context, state) {
          final layoutCubit = BlocProvider.of<LayoutCubit>(context);
          return Scaffold(
            body: Stack(
              alignment: AlignmentGeometry.bottomCenter,
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(30, 30),
                    zoom: 14,
                  ),
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                ),
                StreamBuilder(
                  stream: LayoutService.getEventsStream(
                    Category.catwithall[layoutCubit.state.tabIndex].id ?? "",
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    var events = snapshot.data!.docs;
                    return SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SizedBox(
                          height: 150,
                          child: ListView.separated(
                            separatorBuilder: (context, index) =>
                                SizedBox(width: 10),
                            scrollDirection: Axis.horizontal,
                            itemCount: events.length,
                            itemBuilder: (context, index) {
                              var event = events[index].data();
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: 18.0,
                                  right: 12,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    // Navigate to event location if coordinates exist
                                    if (event.latitude != null &&
                                        event.longitude != null) {
                                      _mapController.animateCamera(
                                        CameraUpdate.newCameraPosition(
                                          CameraPosition(
                                            target: LatLng(
                                              event.latitude!,
                                              event.longitude!,
                                            ),
                                            zoom: 16,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 20,
                                        sigmaY: 20,
                                      ),
                                      child: Container(
                                        width: 320,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.15),
                                          border: Border.all(
                                            width: 2,
                                            color: AppColors.purple,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                            sigmaX: 20,
                                            sigmaY: 20,
                                          ),
                                          child: Container(
                                            width: 320,
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(
                                                0.15,
                                              ),
                                              border: Border.all(
                                                width: 2,
                                                color: AppColors.purple,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                    child: Image.asset(
                                                      event.image ?? "",
                                                      width: 170,
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          event.title ?? '',
                                                          style: context
                                                              .textTheme
                                                              .bodyLarge!
                                                              .copyWith(
                                                                color: AppColors
                                                                    .purple,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        SizedBox(height: 5),
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons.location_on,
                                                              size: 16,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
