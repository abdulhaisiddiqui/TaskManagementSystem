// lib/viewmodels/task_viewmodel.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../data/models/task_model.dart';
import '../data/repositories/taskrepository/task_repository.dart';
import '../data/repositories/notificationrepository/notification_repository.dart';

enum TaskSortBy { priority, category }

class TaskViewModel extends ChangeNotifier {
  final TaskRepository _repo = TaskRepository();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NotificationRepository _notificationRepo = NotificationRepository();

  TaskModel _task = TaskModel(
    userId: FirebaseAuth.instance.currentUser?.uid ?? '',
    title: '',
    startTime: DateTime.now(),
    endTime: DateTime.now().add(const Duration(hours: 1)),
  );

  TaskModel get task => _task;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  TaskViewModel() {
    tz.initializeTimeZones();
  }


  List<TaskModel> _allTasksTodayScreen = [];
  bool _tasksLoadingTodayScreen = true;

  List<TaskModel> get allTasksTodayScreen => _allTasksTodayScreen;
  bool get tasksLoadingTodayScreen => _tasksLoadingTodayScreen;


  int get allCountToday => _allTasksTodayScreen.length;
  int get personalCountToday => _allTasksTodayScreen.where((t) => t.category == 'Personal').length;
  int get workCountToday => _allTasksTodayScreen.where((t) => t.category == 'Work').length;
  int get studyCountToday => _allTasksTodayScreen.where((t) => t.category == 'Study').length;
  int get otherCountToday => _allTasksTodayScreen.where((t) => t.category == 'Other').length;


  List<TaskModel> get filteredTasksTodayScreen2 {
    switch (_selectedTabIndexTodayScreen) {
      case 0:
        return _allTasksTodayScreen;
      case 1:
        return _allTasksTodayScreen.where((t) => t.category == 'Personal').toList();
      case 2:
        return _allTasksTodayScreen.where((t) => t.category == 'Work').toList();
      case 3:
        return _allTasksTodayScreen.where((t) => t.category == 'Study').toList();
      case 4:
        return _allTasksTodayScreen.where((t) => t.category == 'Other').toList();
      default:
        return _allTasksTodayScreen;
    }
  }


  void loadAllTasksForTodayScreen() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    _tasksLoadingTodayScreen = true;
    notifyListeners();

    final selectedDate = _selectedDateForTodayScreen;
    final startOfDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    _firestore
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .where('startTime', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('startTime', isLessThan: Timestamp.fromDate(endOfDay))
        .snapshots()
        .listen((snapshot) {
      _allTasksTodayScreen = snapshot.docs
          .map((doc) => TaskModel.fromMap(doc.data(), doc.id))
          .toList();

      _tasksLoadingTodayScreen = false;
      notifyListeners();
    });
  }


  void setSelectedDateForTodayScreen2(DateTime date) {
    final newDate = DateTime(date.year, date.month, date.day);
    if (_selectedDateForTodayScreen.year == newDate.year &&
        _selectedDateForTodayScreen.month == newDate.month &&
        _selectedDateForTodayScreen.day == newDate.day) {
      return;
    }

    _selectedDateForTodayScreen = newDate;
    loadAllTasksForTodayScreen(); // Sirf TodayScreen ke tasks reload honge
  }

  Stream<List<TaskModel>> getTasks() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return _repo.fetchTasks(uid);
  }

  void updateTitle(String title) {
    _task = _task.copyWith(title: title);
    notifyListeners();
  }

  void updateDescription(String? desc) {
    _task = _task.copyWith(description: desc);
    notifyListeners();
  }

  void updateStartTime(DateTime time) {
    _task = _task.copyWith(startTime: time);
    notifyListeners();
  }

  void updateEndTime(DateTime time) {
    _task = _task.copyWith(endTime: time);
    notifyListeners();
  }

  void updatePriority(String priority) {
    _task = _task.copyWith(priority: priority);
    notifyListeners();
  }

  void updateCategory(String category) {
    _task = _task.copyWith(category: category);
    notifyListeners();
  }

  void updateStatus(String status) {
    _task = _task.copyWith(status: status);
    notifyListeners();


    if (status == "Completed") {
      _notificationRepo.scheduleCompletionCelebration(_task);
    }
  }

  void initializeTask(TaskModel? task) {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    _task =
        task?.copyWith(userId: uid) ??
        TaskModel(
          userId: uid,
          title: '',
          startTime: DateTime.now(),
          endTime: DateTime.now(),
        );
    notifyListeners();
  }

  bool get isValid =>
      _task.title.trim().isNotEmpty && _task.startTime.isBefore(_task.endTime);


  Future<bool> saveTask() async {
    if (!isValid) return false;

    _isLoading = true;
    notifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

      final taskRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('tasks');

      Map<String, dynamic> data = _task.toMap();
      data['startTime'] = Timestamp.fromDate(_task.startTime);
      data['endTime'] = Timestamp.fromDate(_task.endTime);

      if (_task.id == null) {
        await _repo.addTask(
          user.uid,
          _task.copyWith(id: DateTime.now().millisecondsSinceEpoch.toString()),
        );
      } else {
        final oldStatus = task.status;
        await _repo.updateTask(
          user.uid,
          _task,
          oldCompletionStatus: oldStatus == "Completed",
        );
      }

      // Schedule task reminder & overdue alert
      await _notificationRepo.scheduleTaskReminder(_task);
      await _notificationRepo.scheduleOverdueAlert(_task);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print("Error saving task: $e");
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> deleteTask(String uid, String taskId, bool wasCompleted) async {
    await _firestore.runTransaction((transaction) async {
      final taskRef = _firestore
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .doc(taskId);
      final userRef = _firestore.collection('users').doc(uid);

      transaction.delete(taskRef);
      transaction.update(userRef, {
        'stats.totalTasks': FieldValue.increment(-1),
        if (wasCompleted)
          'stats.completedTasks': FieldValue.increment(-1)
        else
          'stats.pendingTasks': FieldValue.increment(-1),
      });
    });
  }

  int _selectedTabIndexTodayScreen = 0;

  int get selectedTabIndexTodayScreen => _selectedTabIndexTodayScreen;

  int get allCountCategory => _allTasks.length;
  int get personalCount =>
      _allTasks.where((t) => t.category == 'Personal').length;
  int get workCount => _allTasks.where((t) => t.category == 'Work').length;
  int get studyCount => _allTasks.where((t) => t.category == 'Study').length;
  int get otherCount => _allTasks.where((t) => t.category == 'Other').length;

  List<TaskModel> get filteredTasksTodayScreen {
    switch (_selectedTabIndexTodayScreen) {
      case 0:
        return _allTasks;
      case 1:
        return _allTasks.where((t) => t.category == 'Personal').toList();
      case 2:
        return _allTasks.where((t) => t.category == 'Work').toList();
      case 3:
        return _allTasks.where((t) => t.category == 'Study').toList();

      case 4:
        return _allTasks.where((t) => t.category == 'Other').toList();
      default:
        return _allTasks;
    }
  }

  void selectTabTodayScreen(int index) {
    if (_selectedTabIndexTodayScreen != index) {
      _selectedTabIndexTodayScreen = index;
      notifyListeners();
    }
  }



  DateTime _selectedDateForTodayScreen = DateTime.now();

  void setSelectedDateForTodayScreen(DateTime date) {
    final newDate = DateTime(date.year, date.month, date.day);
    if (_selectedDateForTodayScreen.year == newDate.year &&
        _selectedDateForTodayScreen.month == newDate.month &&
        _selectedDateForTodayScreen.day == newDate.day) {
      return; // Same date, no need to reload
    }

    _selectedDateForTodayScreen = newDate;

    // Reload tasks for the new selected date
    loadAllTasksForTodayScreen();
  }

  // for Home build Tab
  int _selectedTabIndex = 0;
  List<TaskModel> _allTasks = [];
  bool _tasksLoading = true;

  int get selectedTabIndex => _selectedTabIndex;
  List<TaskModel> get allTasks => _allTasks;
  bool get tasksLoading => _tasksLoading;

  int get allCount => _allTasks.length;
  int get todoCount => _allTasks.where((t) => t.status == 'To Do').length;
  int get inProgressCount =>
      _allTasks.where((t) => t.status == 'In Progress').length;
  int get completedCount =>
      _allTasks.where((t) => t.status == 'Completed').length;

  List<TaskModel> get filteredTasks {
    List<TaskModel> tasks = List.from(_allTasks);
    switch (_selectedTabIndex) {
      case 0:
        return _allTasks;
      case 1:
        return _allTasks.where((t) => t.status == 'To Do').toList();
      case 2:
        return _allTasks.where((t) => t.status == 'In Progress').toList();
      case 3:
        return _allTasks.where((t) => t.status == 'Completed').toList();
      default:
        return _allTasks;
    }
  }

  void selectTab(int index) {
    if (_selectedTabIndex != index) {
      _selectedTabIndex = index;
      notifyListeners();
    }
  }

  void loadAllTasksForHome() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    _tasksLoading = true;
    notifyListeners();

    _firestore
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .snapshots()
        .listen((snapshot) {
          _allTasks = snapshot.docs
              .map((doc) => TaskModel.fromMap(doc.data(), doc.id))
              .toList();

          _tasksLoading = false;
          notifyListeners();
        });
  }
  // grid view for home screen

  bool _isGridViewHome = false;
  bool get isGridViewHome => _isGridViewHome;

  void toggleHomeViewMode() {
    _isGridViewHome = !_isGridViewHome;
    notifyListeners();
  }

  //   Grid view for todaytaskscreen

  bool _isGridView = false;
  bool get isGridView => _isGridView;

  void toggleViewMode() {
    _isGridView = !_isGridView;
    notifyListeners();
  }

  // Filter by priority/Category
  TaskSortBy _currentSortBy = TaskSortBy.priority;
  String _currentFilterValue = 'All';

  TaskSortBy get currentSortBy => _currentSortBy;
  String get currentFilterValue => _currentFilterValue;


  void setSortAndFilter(TaskSortBy sortBy, String filterValue) {
    _currentSortBy = sortBy;
    _currentFilterValue = filterValue;
    notifyListeners();
  }


  List<TaskModel> get filteredTasks2 {
    List<TaskModel> tasks = List.from(_allTasks);


    switch (_selectedTabIndex) {
      case 1:
        tasks = tasks.where((t) => t.status == 'To Do').toList();
        break;
      case 2:
        tasks = tasks.where((t) => t.status == 'In Progress').toList();
        break;
      case 3:
        tasks = tasks.where((t) => t.status == 'Completed').toList();
        break;
    }

    if (_currentFilterValue != 'All' && _currentFilterValue.isNotEmpty) {
      if (_currentSortBy == TaskSortBy.priority) {
        tasks = tasks.where((t) => t.priority == _currentFilterValue).toList();
      } else {
        tasks = tasks.where((t) => t.category == _currentFilterValue).toList();
      }
    }

    return tasks;
  }
}
