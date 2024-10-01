import 'package:flutter/material.dart';
import 'package:todo_app_using_rest_apis/views/todo_list.dart';
import '../apiServices/ApiServices.dart';
import '../uiHelper/uiHelper.dart';

class AddToDo extends StatefulWidget {
  final todo; // Accepting TodoItem for edit functionality
  const AddToDo({super.key, this.todo});

  @override
  State<AddToDo> createState() => _AddToDoState();
}

class _AddToDoState extends State<AddToDo> {
  TextEditingController titleController = TextEditingController();
  TextEditingController desController = TextEditingController();

  // Key to manage form state
  final _formKey = GlobalKey<FormState>();

  bool isEdit = false;

  @override
  void initState() {
    super.initState();

    // Check if in edit mode and pre-fill fields
    if (widget.todo != null) {
      isEdit = true;
      titleController.text = widget.todo!.title ?? "";
      desController.text = widget.todo!.description ?? "";
    }
  }

  Future<void> saveOrUpdateTodo() async {
    if (_formKey.currentState!.validate()) {
      // Proceed with saving if the form is valid
      if (isEdit) {
        // Call update API when in edit mode
        await ApiServices().updateTodo(widget.todo!.sId!, titleController.text, desController.text);
        UiHelper.message("Todo Updated Successfully", context, Colors.greenAccent);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ToDoList()));
      } else {
        // Call post API when in add mode
        await ApiServices().postTodo(titleController.text, desController.text);
        UiHelper.message("Todo Added Successfully", context, Colors.greenAccent);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ToDoList()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Todo" : "Add Todo",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Add form key here
          child: ListView(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Title"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: desController,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  labelText: "Description",
                  alignLabelWithHint: true, // Align the label with the start of the field
                ),
                minLines: 5,
                maxLines: 8,
                textAlignVertical: TextAlignVertical.top, // Aligns the text to the top
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 60),
              UiHelper.helperButton(isEdit ? "Update Todo" : "Add Todo", saveOrUpdateTodo),
            ],
          ),
        ),
      ),
    );
  }
}
