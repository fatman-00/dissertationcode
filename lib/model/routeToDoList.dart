class routeToDoList {
  String docId;
  String title;
  String description;
  DateTime date;
  String userId;
  bool complete;
  String operation;

  routeToDoList(this.docId, this.title, this.description, this.date,
      this.userId, this.complete, this.operation);

  setDate(DateTime d1) {
    date = d1;
  }

  setOperation(String op) {
    operation = op;
  }
}
