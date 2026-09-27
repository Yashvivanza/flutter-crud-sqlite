import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/student_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper databaseHelper = DatabaseHelper();

  List<StudentModel> students = [];

  @override
  void initState() {
    super.initState();
    loadStudents();
  }

  // READ
  Future<void> loadStudents() async {
    final data = await databaseHelper.getStudents();

    setState(() {
      students = data;
    });
  }

  // CREATE
  Future<void> addStudent() async {
  final nameController = TextEditingController();
  final courseController = TextEditingController();
  final emailController = TextEditingController();

  await showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Add Student'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextField(
              controller: courseController,
              decoration: const InputDecoration(
                labelText: 'Course',
              ),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
             
              Navigator.pop(dialogContext);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
          
              final student = StudentModel(
                name: nameController.text,
                course: courseController.text,
                email: emailController.text,
              );

                  await databaseHelper.insertStudent(student);

            

              if (!dialogContext.mounted) return;

              Navigator.pop(dialogContext);

              await loadStudents();

              
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}
  // UPDATE
  Future<void> editStudent(StudentModel student) async {
    final nameController =
        TextEditingController(text: student.name);

    final courseController =
        TextEditingController(text: student.course);

    final emailController =
        TextEditingController(text: student.email);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Student'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
              ),
              TextField(
                controller: courseController,
                decoration: const InputDecoration(
                  labelText: 'Course',
                ),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: () async {
                
                final updatedStudent = StudentModel(
                  id: student.id,
                  name: nameController.text,
                  course: courseController.text,
                  email: emailController.text,
                );

                await databaseHelper.updateStudent(
                  updatedStudent,
                );

                if (!context.mounted) return;

                Navigator.pop(context);

                await loadStudents();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  // DELETE
  Future<void> deleteStudent(int id) async {
  final shouldDelete = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Delete Student'),
        content: const Text(
          'Are you sure you want to delete this student?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext, false);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(dialogContext, true);
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );

  if (shouldDelete == true) {
    await databaseHelper.deleteStudent(id);
    await loadStudents();
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('SQLite CRUD'),
      ),

      body: students.isEmpty
          ? const Center(
              child: Text(
                'No Students Found',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];

                return Card(
                  color: const Color.fromARGB(255, 133, 169, 231),
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(student.name),
                    subtitle: Text(
                      '${student.course}\n${student.email}',
                    ),
                    isThreeLine: true,

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            editStudent(student);
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            deleteStudent(student.id!);
                          },
                        ),                             
                      ],
                    ),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: addStudent,
        child: const Icon(Icons.add),
      ),
    );
  }
}