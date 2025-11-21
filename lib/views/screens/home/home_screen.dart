import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskapp/core/theme/app_color.dart';
import 'package:taskapp/core/utils/widgets/homewidgets/home_build_tab.dart';
import 'package:taskapp/core/utils/widgets/homewidgets/home_build_task_card.dart';
import 'package:taskapp/core/utils/widgets/reuseable_image_widget.dart';
import 'package:taskapp/data/repositories/notificationrepository/notification_repository.dart';
import 'package:taskapp/viewmodels/auth_viewmodel.dart';
import 'package:taskapp/viewmodels/profile_viewmodel.dart';
import 'package:taskapp/viewmodels/task_viewmodel.dart';
import 'package:taskapp/views/screens/loginsignup/login_screen.dart';
import 'package:taskapp/views/screens/notification/notification_screen.dart';

import '../../../core/utils/widgets/homewidgets/task_filter_bar.dart';
import '../taskscreens/task_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _notificationRepo = NotificationRepository();
  User? currentUser = FirebaseAuth.instance.currentUser;


  @override
  void initState() {
    super.initState();

    _notificationRepo.setupFirebaseMessagingListener();

    _notificationRepo.showWelcomeNotification();

    final now = DateTime.now();
    final dailyTime = DateTime(now.year, now.month, now.day, 9, 0);
    _notificationRepo.scheduleDailySummary(
      dailyTime.isBefore(now) ? dailyTime.add(const Duration(days: 1)) : dailyTime,
    );


    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskViewModel>().loadAllTasksForHome();
    });
  }
  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return const LoginScreen();
    }

    final String userId = currentUser!.uid;

    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [

            Consumer<ProfileViewModel>(
              builder: (context, profileVm, child) {
                final String? photoUrl = profileVm.user?.photoURL;

                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey.shade200,
                        child: ClipOval(
                          child: photoUrl != null && photoUrl.isNotEmpty
                              ? Image.network(photoUrl, width: 60, height: 60, fit: BoxFit.cover)
                              : const Icon(Icons.person, size: 34),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello, ${profileVm.user?.displayName ?? 'User'}',
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Text(
                              'Welcome Back',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'Poppins'),
                            ),
                          ],
                        ),
                      ),



                      // Notification Icon
                      IconButton(
                        icon: const Icon(Icons.notifications_none_outlined),
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const NotificationScreen()),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),



            Container(
              margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0XFF828282),
                borderRadius: BorderRadius.circular(35),
              ),
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance.collection('users').doc(userId).snapshots(),
                builder: (context, snapshot) {
                  double progress = 0.0;
                  String progressText = '0% completed';
                  int pendingTasks = 0;
                  String pendingText = 'You have ... tasks to do!';

                  if (snapshot.hasData && snapshot.data!.exists) {
                    final data = snapshot.data!.data() as Map<String, dynamic>;
                    final stats = data['stats'] as Map<String, dynamic>? ?? {};
                    final totalTasks = (stats['totalTasks'] ?? 0).toDouble();
                    final completedTasks = (stats['completedTasks'] ?? 0).toDouble();
                    pendingTasks = (stats['pendingTasks'] ?? 0) as int;

                    progress = totalTasks > 0 ? completedTasks / totalTasks : 0.0;
                    progressText = '${(progress * 100).toStringAsFixed(1)}% completed';
                    pendingText = 'You have $pendingTasks more task${pendingTasks != 1 ? 's' : ''} to do!';
                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                    pendingText = 'Loading tasks...';
                  } else {
                    pendingText = 'You have 0 tasks to do!';
                  }

                  return Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(progressText, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 8,
                                backgroundColor: Colors.white24,
                                valueColor: const AlwaysStoppedAnimation(Color(0xFFD1D0F9)),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(pendingText, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      const ReuseableImageWidget(img: 'cardimg.png'),
                    ],
                  );
                },
              ),
            ),

            Stack(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding: EdgeInsets.only(right: 40),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Consumer<TaskViewModel>(
                          builder: (context, vm, child) {
                            return Row(
                              children: [
                                HomeBuildTab(
                                  label: 'All',
                                  count: vm.allCount,
                                  isSelected: vm.selectedTabIndex == 0,
                                  onTap: () => vm.selectTab(0),
                                ),
                                HomeBuildTab(
                                  label: 'To Do',
                                  count: vm.todoCount,
                                  isSelected: vm.selectedTabIndex == 1,
                                  onTap: () => vm.selectTab(1),
                                ),
                                HomeBuildTab(
                                  label: 'In Progress',
                                  count: vm.inProgressCount,
                                  isSelected: vm.selectedTabIndex == 2,
                                  onTap: () => vm.selectTab(2),
                                ),
                                HomeBuildTab(
                                  label: 'Completed',
                                  count: vm.completedCount,
                                  isSelected: vm.selectedTabIndex == 3,
                                  onTap: () => vm.selectTab(3),
                                ),

                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),


                Positioned(
                  right: 20,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.appBackgroundColor,

                    ),
                    child: Consumer<TaskViewModel>(
                      builder: (context, vm, child) {
                        return IconButton(
                          onPressed: vm.toggleHomeViewMode,
                          icon: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 320),
                            transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                            child: Icon(
                              vm.isGridViewHome ? Icons.view_list_rounded : Icons.grid_view_rounded,
                              key: ValueKey<bool>(vm.isGridViewHome),
                              size: 28,
                              color: const Color(0xFF6C63FF),
                            ),
                          ),
                          tooltip: vm.isGridViewHome ? "List View" : "Grid View",
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),


            TaskFilterBar(
              selectedSort: context.watch<TaskViewModel>().currentSortBy,
                onSortChanged: (sortBy) {

                  if (context.read<TaskViewModel>().currentSortBy == sortBy) {
                  } else {
                    context.read<TaskViewModel>().setSortAndFilter(sortBy, 'All');
                  }
                },
              onFilterApplied: (filterType, value) {
                context.read<TaskViewModel>().setSortAndFilter(
                  filterType == 'priority' ? TaskSortBy.priority : TaskSortBy.category,
                  value,
                );
              },
            ),

            Expanded(
              child: Consumer<TaskViewModel>(
                builder: (context, vm, child) {
                  if (vm.tasksLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (vm.filteredTasks2.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.event_busy_rounded, size: 70, color: Colors.grey.shade400),
                          const SizedBox(height: 16),
                          Text(
                            vm.selectedTabIndex == 0
                                ? "No tasks yet"
                                : "No ${['All', 'To Do', 'In Progress', 'Completed'][vm.selectedTabIndex]} tasks",
                            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    );
                  }

                  if (vm.isGridViewHome) {
                    return GridView.builder(
                      padding: const EdgeInsets.all(20),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.1,
                      ),
                      itemCount: vm.filteredTasks2.length,
                      itemBuilder: (context, index) {
                        final task = vm.filteredTasks2[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TaskDetailScreen(task: task),
                              ),
                            );
                          },
                          child: HomeBuildTaskCardGrid(task: task, uid: userId),
                        );
                      },
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: vm.filteredTasks2.length,
                    itemBuilder: (context, index) {
                      final task = vm.filteredTasks2[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TaskDetailScreen(task: task),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: HomeBuildTaskCard(uid: userId, task: task),
                        ),
                      );
                    },
                  );
                },

              ),
            ),

            // ----------------------------- TASKS LIST -----------------------------
      Expanded(
        child: StreamBuilder(
          stream: context.read<TaskViewModel>().getTasks(),
          builder: (context, snapshot) {
            print("Tasks snapshot: ${snapshot.data}");

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No tasks found"));
            }

            final tasks = snapshot.data!;

            String format(DateTime t) {
              String hour = t.hour.toString().padLeft(2, '0');
              String minute = t.minute.toString().padLeft(2, '0');
              String ampm = t.hour >= 12 ? 'pm' : 'am';
              return "$hour.$minute $ampm";
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];

                final formattedTime =
                    "${format(task.startTime)} – ${format(task.endTime)}";

                return HomeBuildTaskCard(
                  title: task.title,
                  time: formattedTime,
                  category: task.category,
                  status: task.status,
                  statusColor: task.status == "Completed"
                      ? Colors.green
                      : Colors.orange,
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 110, right: 5),
        child: FloatingActionButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateTaskScreen())),
          child: const Icon(Icons.add),

        ),
      ),
    );
  }
}