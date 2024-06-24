class Network {
  bool Status = false;
  String? Message = "";
  dynamic Data;
  String? Error = "";

  Network(
      {required this.Status,
      this.Message,
      this.Data,
      this.Error});
}
