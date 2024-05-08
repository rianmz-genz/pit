class TaskModel {
  int id = 0;
  String? name = "";
  bool? fsm_done = false;
  int? distance;
  String? status_worksheet = "";
  String? description = "";
  String? customer = "";
  dynamic task_status;
  bool? handoff = false;
  String? pending_time = "";
  init() {}
  TaskModel(
      {required this.id,
      this.customer,
      required this.name,
      this.description,
      this.fsm_done,
      required this.distance,
      required this.status_worksheet,
      this.handoff,
      this.pending_time,
      required this.task_status});

  getTask() {
    Map data = {
      "id": id,
      "name": name,
      "fsm_done": fsm_done,
      "distance": distance,
      "description": description,
      "customer": customer,
      "status_worksheet": status_worksheet,
      "task_status": task_status,
      "handoff": handoff,
      "pending_time": pending_time
    };
    return data;
  }
}
