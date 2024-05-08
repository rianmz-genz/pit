class Network {
  bool Status = false;
  String? Message = "";
  dynamic? Data = null;
  String? Error = "";

  Network(
      {required bool this.Status,
      String? this.Message,
      dynamic? this.Data,
      this.Error});
}
