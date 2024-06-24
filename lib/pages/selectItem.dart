import 'dart:async';

import 'package:flutter/material.dart';

import 'package:pit/themes/AppTheme.dart';
import 'package:pit/utils/SizeConfig.dart';
import 'package:pit/utils/boxData.dart';

import '../model/mNetwork.dart';
import '../network/master.dart';

class SelectedItem extends StatefulWidget {
  // const SelelctedItem({Key? key}) : super(key: key);
  List<dynamic> Jenis = [];
  String _title = "";
  List data = [];

  SelectedItem(this.Jenis, this._title, {super.key});

  @override
  _SelectedItemState createState() => _SelectedItemState();
}

class _SelectedItemState extends State<SelectedItem> {
  String keyword = "";
  Timer? _debounce;
  TextEditingController keywordController = TextEditingController();
  Future<dynamic> getDataItems() async {
    List<dynamic> dataFilter = [];
    List<dynamic> dataAsli = [];
    masterNetwork objMaster = masterNetwork();

    if (widget._title == 'Garansi') {
      Network objMasterGaransitNetwork =
          await objMaster.getMasterWaktuGaransi();
      dataAsli = objMasterGaransitNetwork.Data;
    } else if (widget._title == 'Pilih part yang diganti') {
      Network objMasterProductNetwork = await objMaster.getMasterProduct();
      dataAsli = objMasterProductNetwork.Data;
    }
    if (keyword != "") {
      if (widget._title == "Pilih part yang diganti") {
        for (var sort in dataAsli) {
          if (sort['default_code']
                  .toString()
                  .toLowerCase()
                  .contains(keyword.toLowerCase()) ||
              sort['name']
                  .toString()
                  .toLowerCase()
                  .contains(keyword.toLowerCase())) {
            dataFilter.add(sort);
          }
        }
      } else {
        for (var sort in dataAsli) {
          if (sort['name']
              .toString()
              .toLowerCase()
              .contains(keyword.toLowerCase())) {
            dataFilter.add(sort);
          }
        }
      }
    } else {
      dataFilter = widget.Jenis;
    }
    return dataFilter.isEmpty ? dataAsli.toList() : dataFilter.toList();
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Ya"),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop([false, ""]);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Tidak"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Peringatan"),
      content: const Text("Apakah anda yakin ingin menghapus data ini?"),
      actions: [
        continueButton,
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  //delay search biar gaberat
  _onSearchChanged(String data) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      // do something with query
      setState(() {
        keyword = data;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    keywordController.dispose();
  }

  markedPage(String namepage) async {
    final BoxData = boxData(nameBox: "box_MarkedPage");
    await BoxData.markedPage(namePage: namepage);
  }

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    if (widget._title == 'Urutkan') {
      markedPage("select_item_urutkan");
    } else {
      markedPage("select_item");
    }
    print("jeniss, ${widget.Jenis}");

    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: RefreshIndicator(
        notificationPredicate: (_) {
          if (widget._title == 'Garansi' ||
              widget._title == 'Pilih part yang diganti') {
            return true;
          } else {
            return false;
          }
        },
        onRefresh: () async {
          masterNetwork objMaster = masterNetwork();

          if (widget._title == 'Garansi') {
            Network objMasterGaransitNetwork =
                await objMaster.getMasterWaktuGaransi();
            widget.Jenis = objMasterGaransitNetwork.Data;
          } else if (widget._title == 'Pilih part yang diganti') {
            Network objMasterProductNetwork =
                await objMaster.getMasterProduct();
            widget.Jenis = objMasterProductNetwork.Data;
          }
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: AppTheme.warnaUngu,
              actions: [
                widget._title != 'Urutkan'
                    ? IconButton(
                        splashColor: AppTheme.warnaUngu,
                        onPressed: () => showAlertDialog(context),
                        icon: const Icon(
                          Icons.delete,
                          size: 30,
                          color: Colors.white,
                        ),
                      )
                    : Container(),
              ],
              leading: IconButton(
                splashColor: AppTheme.warnaUngu,
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.keyboard_arrow_left, size: 40),
              ),
              automaticallyImplyLeading: true,
              centerTitle: true,
              title: Text(
                widget._title,
                style: AppTheme.appBarTheme(),
                textAlign: TextAlign.center,
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  widget._title == "Pilih part yang diganti"
                      ? Container(
                          padding: const EdgeInsets.all(10),
                          child: TextFormField(
                            controller: keywordController,

                            onChanged: (data) {
                              _onSearchChanged(data);
                            },
                            style: const TextStyle(
                                fontSize: 15,
                                fontFamily: 'OpenSans',
                                color: Color(0xFF2C2948)),
                            maxLines: 1,
                            // max baris

                            decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(left: 29.0, right: 10.0),
                              hintText: 'ketik pencarianmu',
                              hintStyle: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontFamily: 'OpenSans',
                                  fontSize: 15),
                              focusColor: Colors.white70,
                            ),
                          ),
                        )
                      : Container(),
                  widget._title == "Pilih part yang diganti"
                      ? const SizedBox(
                          child: Divider(
                            height: 10,
                          ),
                        )
                      : Container(),
                  Expanded(
                    child: FutureBuilder<dynamic>(
                      future: getDataItems(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          print('snapshot.data ${snapshot.data}');
                          List<dynamic> lstItem = snapshot.data!;
                          int _length = lstItem.length;
                          return ListView.builder(
                              itemCount: _length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () async {
                                    print(lstItem[index].runtimeType);
                                    if (lstItem[index].runtimeType != String) {
                                      if (lstItem[index].containsKey("id")) {
                                        if (lstItem[index]
                                            .containsKey("default_code")) {
                                          widget.data = [
                                            lstItem[index]['id'],
                                            "[${lstItem[index]['default_code']}]  ${lstItem[index]['name']}  "
                                          ];
                                          Navigator.pop(context, widget.data);
                                        } else {
                                          widget.data = [
                                            lstItem[index]['id'],
                                            "${lstItem[index]['name']}"
                                          ];
                                          Navigator.pop(context, widget.data);
                                        }
                                      } else {
                                        if (lstItem[index]
                                                .containsKey("value") &&
                                            lstItem[index]
                                                .containsKey("name")) {
                                          widget.data = [
                                            lstItem[index]['value'],
                                            lstItem[index]['name']
                                          ];
                                          Navigator.pop(context, widget.data);
                                        } else {
                                          Navigator.pop(
                                              context, lstItem[index]);
                                        }
                                      }
                                    } else {
                                      Navigator.pop(context, lstItem[index]);
                                    }
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: widget._title ==
                                                "Pilih part yang diganti"
                                            ? Text((lstItem[index]
                                                            ['default_code'] !=
                                                        false
                                                    ? "[" +
                                                        lstItem[index]
                                                            ['default_code'] +
                                                        "] "
                                                    : "") +
                                                lstItem[index]['name'])
                                            : lstItem[index].runtimeType !=
                                                    String
                                                ? Text(lstItem[index]['name'])
                                                : Text(lstItem[index]),
                                      ),
                                      const Divider(
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                );
                              });
                        }
                        return const Center(
                            child: CircularProgressIndicator(
                          color: AppTheme.warnaHijau,
                        ));
                      },
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
