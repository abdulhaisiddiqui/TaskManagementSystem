// lib/views/screens/todays_tasks_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskapp/core/theme/app_color.dart';
import 'package:taskapp/views/screens/taskscreens/task_detail_screen.dart';

import '../../../core/utils/widgets/homewidgets/home_build_tab.dart';
import '../../../core/utils/widgets/homewidgets/home_build_task_card.dart';
import '../../../data/models/task_model.dart';
import '../../../viewmodels/task_calender_provider.dart';
import '../../../viewmodels/task_viewmodel.dart';

class TodaysTasksScreen extends StatelessWidget {
  const TodaysTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;

    User? currentUser = FirebaseAuth.instance.currentUser;
    final String userId = currentUser!.uid;

    if (uid == null) {
      return const Scaffold(body: Center(child: Text("Please login first")));
    }

    return ChangeNotifierProvider(
      create: (_) {
        final provider = TaskProvider();
        provider.initializeUserData(uid);
        return provider;
      },
      child: Scaffold(
        backgroundColor: AppColors.appBackgroundColor,
        body: SafeArea(
          child: Consumer<TaskProvider>(
            builder: (context, provider, child) {
              // Loading state
              if (provider.isLoading) {
                return const Center(
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xFF6C63FF)),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Today's tasks",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5D5DA8),
                          ),
                        ),
                        Consumer<TaskViewModel>(
                          builder: (context, vm, child) {
                            return IconButton(
                              onPressed: vm.toggleViewMode,
                              icon: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                transitionBuilder: (child, animation) {
                                  return ScaleTransition(
                                    scale: animation,
                                    child: child,
                                  );
                                },
                                child: Icon(
                                  vm.isGridView
                                      ? Icons.view_list_rounded
                                      : Icons.grid_view_rounded,
                                  key: ValueKey<bool>(vm.isGridView),
                                  size: 28,
                                  color: const Color(0xFF6C63FF),
                                ),
                              ),
                              splashRadius: 24,
                              tooltip: vm.isGridView
                                  ? "List View"
                                  : "Grid View",
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // Date Selector
                    const DateSelectorRow(),
                    const SizedBox(height: 30),

                    Consumer<TaskViewModel>(
                      builder: (context, vm, child) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                HomeBuildTab(
                                  label: 'All',
                                  count: vm.allCountToday,
                                  isSelected:
                                      vm.selectedTabIndexTodayScreen == 0,
                                  onTap: () => vm.selectTabTodayScreen(0),
                                ),

                                HomeBuildTab(
                                  label: 'Personal',
                                  count: vm.personalCountToday,
                                  isSelected:
                                      vm.selectedTabIndexTodayScreen == 1,
                                  onTap: () => vm.selectTabTodayScreen(1),
                                ),

                                HomeBuildTab(
                                  label: 'Work',
                                  count: vm.workCountToday,
                                  isSelected:
                                      vm.selectedTabIndexTodayScreen == 2,
                                  onTap: () => vm.selectTabTodayScreen(2),
                                ),

                                HomeBuildTab(
                                  label: 'Study',
                                  count: vm.studyCountToday,
                                  isSelected:
                                      vm.selectedTabIndexTodayScreen == 3,
                                  onTap: () => vm.selectTabTodayScreen(3),
                                ),
                                HomeBuildTab(
                                  label: 'Other',
                                  count: vm.otherCountToday,
                                  isSelected:
                                      vm.selectedTabIndexTodayScreen == 4,
                                  onTap: () => vm.selectTabTodayScreen(4),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 30),

                    // Tasks List
                    Expanded(child: TaskListView(uid: userId)),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class DateSelectorRow extends StatelessWidget {
  const DateSelectorRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, child) {
        final dates = provider.availableDates;

        if (dates.isEmpty) {
          return const SizedBox(
            height: 90,
            child: Center(child: Text("Loading dates...")),
          );
        }

        return SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            reverse: true,
            itemCount: dates.length,
            itemBuilder: (context, index) {
              final date = dates[index];
              final isSelected = provider.isSameDay(
                provider.selectedDate,
                date,
              );

              return GestureDetector(
                onTap: () {
                  provider.selectDate(date);
                  Provider.of<TaskViewModel>(
                    context,
                    listen: false,
                  ).setSelectedDateForTodayScreen2(date);
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 12),
                  width: 70,
                  child: Column(
                    children: [
                      Text(
                        DateFormat('MMM').format(date),
                        style: TextStyle(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 56,
                        width: 56,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF6C63FF)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class TaskListView extends StatelessWidget {
  final String uid;
  const TaskListView({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskViewModel>(
      builder: (context, vm, child) {
        if (vm.tasksLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (vm.filteredTasksTodayScreen2.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.event_busy_rounded,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  vm.selectedTabIndexTodayScreen == 0
                      ? "No tasks yet"
                      : "No ${['All', 'Personal', 'Work', 'Study', 'Other'][vm.selectedTabIndexTodayScreen]} tasks",
                  style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                ),
              ],
            ),
          );
        }


        if (vm.isGridView) {
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.1,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: vm.filteredTasksTodayScreen2.length,
            itemBuilder: (context, index) {
              final task = vm.filteredTasks2[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TaskDetailScreen(taskId: task.id!,),
                    ),
                  );
                },
                child: TaskCardGrid(task: task),
              );
            },
          );
        } else {
          return ListView.builder(
            padding: const EdgeInsets.only(top: 8),
            itemCount: vm.filteredTasksTodayScreen2.length,
            itemBuilder: (context, index) {
              final task = vm.filteredTasksTodayScreen2[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TaskDetailScreen(taskId: task.id!,),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TaskCard(
                    task: task,
                    timeRange:
                        "${task.startTime.hour}:${task.startTime.minute.toString().padLeft(2, '0')} - ${task.endTime.hour}:${task.endTime.minute.toString().padLeft(2, '0')}",
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}

class TaskCardGrid extends StatelessWidget {
  final TaskModel task;
  const TaskCardGrid({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E6FF),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  task.category,
                  style: const TextStyle(
                    color: Color(0xFF6C63FF),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                task.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3F3D56),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.access_time, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                "${task.startTime.hour}:${task.startTime.minute.toString().padLeft(2, '0')}",
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final String timeRange;

  const TaskCard({super.key, required this.task, required this.timeRange});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E6FF),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task.category,
            style: const TextStyle(
              color: Color(0xFF6C63FF),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            task.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3F3D56),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.access_time, size: 18, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                timeRange,
                style: const TextStyle(color: Colors.grey, fontSize: 15),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
