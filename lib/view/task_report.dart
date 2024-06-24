import 'package:flutter/material.dart';

import 'package:pit/pages/task_list_adapter.dart';
import 'package:pit/themes/AppTheme.dart';
import 'package:pit/utils/SizeConfig.dart';

class TaskReport extends StatelessWidget {
  const TaskReport({super.key});

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    final ThemeData themeData = Theme.of(context);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.warnaUngu,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'PIT Elektronik',
            style: AppTheme.appBarTheme(),
            textAlign: TextAlign.center,
          ),
        ),
        body: SafeArea(
          child: DefaultTabController(
            length: 3,
            child: Column(
              children: <Widget>[
                Container(
                  constraints: BoxConstraints(
                      maxHeight: MySize.getScaledSizeHeight(159)),
                  child: Stack(
                    children: [
                      Positioned.fill(
                          child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: const Color(0xFFE9E9E9),
                              width: MySize.getScaledSizeWidth(2),
                            ),
                          ),
                        ),
                      )),
                      TabBar(
                        unselectedLabelColor: const Color(0xFF333333),
                        labelColor: AppTheme.warnaHijau,
                        labelStyle: AppTheme.OpenSans600(
                          18,
                          AppTheme.warnaHijau,
                        ),
                        unselectedLabelStyle:
                            AppTheme.OpenSans400(18, const Color(0xFF333333)),
                        indicator: UnderlineTabIndicator(
                            borderSide: BorderSide(
                              width: MySize.getScaledSizeWidth(2),
                              color: AppTheme.warnaHijau,
                            ),
                            insets: EdgeInsets.symmetric(
                                horizontal: -30 * MySize.scaleFactorWidth)),
                        tabs: [
                          Tab(
                              child: Text("Berjalan",
                                  style: AppTheme.tabBarTheme())),
                          Tab(
                              child: Text("Pending",
                                  style: AppTheme.tabBarTheme())),
                          Tab(
                              child: Text("Riwayat",
                                  style: AppTheme.tabBarTheme())),
                        ],
                      )
                    ],
                  ),
                ),
                const Expanded(
                  child: TabBarView(
                    children: [
                      TaskOngoing(),
                      TaskPending(),
                      TaskHistory(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TaskOngoing extends StatelessWidget {
  const TaskOngoing({super.key});

  @override
  Widget build(BuildContext context) {
    // print("kesini nih task ongoin g");
    final ThemeData themeData = Theme.of(context);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        body: SafeArea(
          child: Container(
            child: TaskListAdapter(
              Status: "OnGoing",
              Lat: 0.0,
              Lng: 0.0,
            ),
          ),
        ),
      ),
    );
  }
}

class TaskHistory extends StatelessWidget {
  const TaskHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        body: SafeArea(
          child: Container(
            child: TaskListAdapter(
              Status: "History",
              Lat: 0.0,
              Lng: 0.0,
            ),
          ),
        ),
      ),
    );
  }
}

class TaskPending extends StatelessWidget {
  const TaskPending({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        body: SafeArea(
          child: Container(
            child: TaskListAdapter(
              Status: "Pending",
              Lat: 0.0,
              Lng: 0.0,
            ),
          ),
        ),
      ),
    );
  }
}
