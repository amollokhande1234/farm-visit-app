import 'package:feild_visit_app/features/home/bloc/visit/visit_state.dart';
import 'package:feild_visit_app/features/home/screens/visit_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../bloc/visit/visit_cubit.dart';
import '../widgets/visit_card.dart';

class VisitListScreen extends StatefulWidget {
  const VisitListScreen({super.key});

  @override
  State<VisitListScreen> createState() => _VisitListScreenState();
}

class _VisitListScreenState extends State<VisitListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<VisitCubit>().fetchAllVisits();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<VisitCubit>().fetchAllVisits();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: BlocBuilder<VisitCubit, VisitState>(
                builder: (context, state) {
                  if (state is VisitLoading) {
                    return ListView.separated(
                      padding: const EdgeInsets.all(12),
                      itemCount: 5,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return Shimmer(
                          gradient: LinearGradient(
                            colors: [
                              Colors.grey.shade300,
                              Colors.grey.shade100,
                              Colors.grey.shade300,
                            ],
                            stops: const [0.1, 0.3, 0.4],
                            begin: Alignment(-1.0, -0.3),
                            end: Alignment(1.0, 0.3),
                            tileMode: TileMode.clamp,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Placeholder for image
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Placeholder for text
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 16,
                                        width: 120,
                                        color: Colors.grey.shade300,
                                      ),
                                      const SizedBox(height: 6),
                                      Container(
                                        height: 14,
                                        width: 100,
                                        color: Colors.grey.shade300,
                                      ),
                                      const SizedBox(height: 6),
                                      Container(
                                        height: 14,
                                        width: 80,
                                        color: Colors.grey.shade300,
                                      ),
                                      const SizedBox(height: 6),
                                      Container(
                                        height: 12,
                                        width: 60,
                                        color: Colors.grey.shade300,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is VisitLoaded) {
                    final visits = state.visits;

                    if (visits.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 100,
                              width: 100,

                              child: Image.asset('assets/icons/app_icon.png'),
                            ),
                            SizedBox(height: 10),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'No Farm Visit Found\n  Add a Visit Details',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.separated(
                      itemCount: visits.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final visit = visits[index];
                        debugPrint('${visit.toJson()}');
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    VisitDetailScreen(visit: visit),
                              ),
                            );
                          },
                          child: VisitCard(
                            farmerName: visit.farmerName,
                            village: visit.villageName,
                            cropType: visit.cropType,
                            visitDate: visit.time,
                            photoUrl:
                                visit.imagePath ??
                                'https://via.placeholder.com/150',
                            isSynced: visit.isSynced,
                          ),
                        );
                      },
                    );
                  } else if (state is VisitFailure) {
                    return Center(child: Text(state.message));
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
