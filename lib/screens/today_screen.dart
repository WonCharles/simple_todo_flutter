import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../providers/todo_provider.dart';
import '../widgets/todo_item.dart';
import 'tomorrow_screen.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({Key? key}) : super(key: key);

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  final _textController = TextEditingController();
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    // 화면이 처음 로드될 때 오늘 할 일 목록 가져오기
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TodoProvider>(context, listen: false).fetchTodayTodos();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, todoProvider, child) {
        final todos = todoProvider.todayTodos;
        // 완료되지 않은 할 일만 필터링
        final incompleteTodos = todos.where((todo) => !todo.isCompleted).toList();
        // 완료된 할 일만 필터링
        final completedTodos = todos.where((todo) => todo.isCompleted).toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text('오늘 할 일'),
            actions: [
              IconButton(
                icon: const Icon(Icons.navigate_next),
                onPressed: () {
                  // 내일 할 일 화면으로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TomorrowScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          body: todoProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Expanded(
                      child: todos.isEmpty
                          ? const Center(child: Text('오늘 할 일이 없습니다.'))
                          : ListView(
                              children: [
                                // 미완료 할 일 목록
                                ...incompleteTodos.map((todo) => TodoItem(
                                      todo: todo,
                                      onToggleComplete: () {
                                        todoProvider.toggleCompleted(todo.id);
                                      },
                                      onDelete: () {
                                        todoProvider.deleteTodo(todo.id);
                                      },
                                      onPostpone: () {
                                        todoProvider.togglePostponed(todo.id);
                                      },
                                    )),
                                
                                // 완료된 할 일 섹션 (토글 가능)
                                if (completedTodos.isNotEmpty)
                                  ListTile(
                                    title: Text(
                                      '완료된 할 일 (${completedTodos.length})',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    trailing: Icon(
                                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _isExpanded = !_isExpanded;
                                      });
                                    },
                                  ),
                                
                                // 완료된 할 일 목록 (확장 시 표시)
                                if (_isExpanded)
                                  ...completedTodos.map((todo) => TodoItem(
                                        todo: todo,
                                        onToggleComplete: () {
                                          todoProvider.toggleCompleted(todo.id);
                                        },
                                        onDelete: () {
                                          todoProvider.deleteTodo(todo.id);
                                        },
                                        onPostpone: () {
                                          todoProvider.togglePostponed(todo.id);
                                        },
                                      )),
                              ],
                            ),
                    ),
                    // 새 할 일 입력 필드
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _textController,
                              decoration: const InputDecoration(
                                hintText: '새 할 일을 입력하세요',
                                border: OutlineInputBorder(),
                              ),
                              onSubmitted: _addTodo,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              _addTodo(_textController.text);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  void _addTodo(String title) {
    if (title.trim().isNotEmpty) {
      Provider.of<TodoProvider>(context, listen: false).addTodo(title.trim());
      _textController.clear();
    }
  }
}