class ToDoListModel {
  String docId;
  String title;
  String description;
  DateTime date;
  String time;
  String userId;
  bool complete;
  String operation;

  ToDoListModel(this.docId, this.title, this.description, this.date,
      this.time,this.userId, this.complete, this.operation);

  setDate(DateTime d1) {
    date = d1;
  }

  setOperation(String op) {
    operation = op;
  }
}
