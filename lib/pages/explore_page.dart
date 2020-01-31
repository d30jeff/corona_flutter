import 'package:corona_flutter/core/stat.dart';
import 'package:corona_flutter/utils/helper.dart';
import 'package:corona_flutter/widgets/counter.dart';
import 'package:flutter/material.dart';

class ExplorePage extends StatefulWidget {
  final StatsService statsService;

  const ExplorePage({
    Key key,
    this.statsService,
  }) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  ScrollController statsController;
  ScrollController appBarController;

  @override
  void initState() {
    super.initState();

    appBarController = ScrollController();
    statsController = ScrollController()
      ..addListener(() {
        appBarController.jumpTo(statsController.offset);
      });

    widget.statsService.addListener(() {
      setState(() {});
    });

    loadStats();
  }

  @override
  void dispose() {
    statsController.dispose();
    super.dispose();
  }

  loadStats() {
    widget.statsService.getStats();
  }

  Future<void> handleRefresh() async {
    setState(() {
      loadStats();
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      controller: appBarController,
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            centerTitle: true,
            title: Text(
              'Statistics',
              style: TextStyle(
                fontSize: 24.0,
                fontFamily: 'AbrilFatface',
                color: Colors.black.withOpacity(0.75),
                fontWeight: FontWeight.w700,
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: Helper.getFlagIcon(
                  countryCode: widget.statsService.countryCode ?? 'GLOBAL',
                  width: 24.0,
                  height: null,
                  color: Colors.black.withOpacity(0.75),
                ),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              ),
            ],
            elevation: 0.0,
            backgroundColor: Colors.white24,
          ),
        ];
      },
      body: RefreshIndicator(
        onRefresh: handleRefresh,
        child: ListView(
          key: PageStorageKey('statsCounter'),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                '${Helper.getCountryName(widget.statsService.countryCode ?? 'GLOBAL')}',
                style: TextStyle(
                  fontSize: 50.0,
                  fontFamily: 'AbrilFatface',
                  fontWeight: FontWeight.w700,
                  color: Colors.black.withOpacity(0.75),
                ),
              ),
            ),
            CounterWrapper(
              title: 'Number Confirmed',
              number: widget.statsService.stats?.numConfirm ?? 0,
            ),
            CounterWrapper(
              title: 'Number Dead',
              number: widget.statsService.stats?.numDead ?? 0,
            ),
            CounterWrapper(
              title: 'Number Healed',
              number: widget.statsService.stats?.numHeal ?? 0,
            ),
          ],
        ),
      ),
    );
  }
}

class CounterWrapper extends StatelessWidget {
  final String title;
  final int number;

  const CounterWrapper({
    Key key,
    this.title,
    this.number,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 12.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w700,
              color: Colors.black.withOpacity(0.75),
            ),
          ),
          AnimatedCounter(
            number: number,
          ),
        ],
      ),
    );
  }
}
