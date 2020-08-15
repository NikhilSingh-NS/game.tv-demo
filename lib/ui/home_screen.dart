import 'package:game_tv_demo/provider/home_screen_provider.dart';
import 'package:game_tv_demo/ui/utils/colors.dart';
import 'package:game_tv_demo/ui/utils/size_config.dart';
import 'package:game_tv_demo/ui/widgets/circular_widget.dart';
import 'package:game_tv_demo/ui/widgets/image_loader.dart';
import 'package:game_tv_demo/ui/widgets/text_dialog.dart';
import 'package:game_tv_demo/utils/locale/app_translation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../routes.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  ScrollController _scrollController = ScrollController();
  HomeScreenProvider homeScreenProvider;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollController.addListener(() {
        if (_scrollController.position.maxScrollExtent ==
            _scrollController.position.pixels) {
          homeScreenProvider.addRecommendation();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: ChangeNotifierProvider<HomeScreenProvider>(
        create: (_) => HomeScreenProvider(),
        child: Consumer<HomeScreenProvider>(builder:
            (BuildContext context, HomeScreenProvider provider, Widget child) {
          homeScreenProvider = provider;
          return provider.isReady
              ? provider.homeScreenState == HOME_SCREEN_STATE.SUCCESS
                  ? Container(
                      color: homeBgColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin:
                                EdgeInsets.only(top: SizeConfig.getHeight(2)),
                            child: Stack(children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      tryLogOut(provider);
                                    },
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            left: SizeConfig.getWidth(5.0),
                                            top: SizeConfig.getWidth(1.0)),
                                        child: Icon(Icons.arrow_back_ios,
                                            color: nextIconColor,
                                            size: SizeConfig.getHeight(3))),
                                  ),
                                ],
                              ),
                              Center(
                                  child: Text('Flyingwolf',
                                      style: TextStyle(
                                          color: textColor,
                                          fontSize:
                                              SizeConfig.getTextSize(5),
                                          fontWeight: FontWeight.w500)))
                            ]),
                          ),
                          buildUserInfo(provider),
                          buildUserTournamentInfo(provider),
                          Container(
                            padding: EdgeInsets.only(
                                top: SizeConfig.getWidth(2.0),
                                left: SizeConfig.getWidth(5.0),
                                right: SizeConfig.getWidth(5.0)),
                            child: getHeaderText(AppTranslations.of(context)
                                .getString('recommended_for_you')),
                          ),
                          buildRecommendation(provider),
                        ],
                      ),
                    )
                  : Center(
                      child: provider.homeScreenState ==
                              HOME_SCREEN_STATE.NO_INTERNET
                          ? getHeaderText(AppTranslations.of(context)
                              .getString('pls_connect_to_internet'))
                          : getHeaderText(AppTranslations.of(context)
                              .getString('something_went_wrong')),
                    )
              : Center(
                  child: CircularProgressIndicator(),
                );
        }),
      ),
    );
  }

  Widget buildUserInfo(HomeScreenProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Container(
            padding: EdgeInsets.all(SizeConfig.getWidth(5.0)),
            child: CircularWidget(
              borderColor: whiteColor,
              borderStrokeWidth: 0.5,
              height: SizeConfig.getWidth(30.0),
              width: SizeConfig.getWidth(30.0),
              child: ImageLoader().load(provider.userDetails.image),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            padding: EdgeInsets.all(SizeConfig.getWidth(1.0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                getHeaderText(provider.userDetails.name),
                SizedBox(
                  height: SizeConfig.getHeight(2),
                ),
                Container(
                  height: SizeConfig.getHeight(5),
                  width: SizeConfig.getWidth(38),
                  decoration: ShapeDecoration(
                      shape: StadiumBorder(
                          side: BorderSide(
                        color: ratingBorderColor,
                      )),
                      color: Colors.white),
                  padding: EdgeInsets.all(SizeConfig.getWidth(2)),
                  child: Row(
                    children: <Widget>[
                      Text(
                        provider.userDetails.rating.toString(),
                        style: TextStyle(
                            color: ratingTextBlueColor,
                            fontSize: SizeConfig.getTextSize(4.5),
                            fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        width: SizeConfig.getWidth(3),
                      ),
                      Text(
                        AppTranslations.of(context).getString('lbl_rating'),
                        style: TextStyle(
                            color: ratingTextGrayColor,
                            fontSize: SizeConfig.getTextSize(3),
                            fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget buildUserTournamentInfo(HomeScreenProvider provider) {
    return Container(
      height: SizeConfig.getHeight(9.0),
      //padding: EdgeInsets.all(SizeConfig.getWidth(1.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Card(
            elevation: 3.0,
            margin: EdgeInsets.all(1.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20.0))),
            child: Container(
              width: SizeConfig.getWidth(28),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0)),
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: <Color>[initialOrangeColor, endOrangeColor],
                      tileMode: TileMode.repeated)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  getTextWidgetForStat(provider.userDetails.played.toString()),
                  SizedBox(
                    height: 4.0,
                  ),
                  getTextWidgetForStatText(AppTranslations.of(context)
                      .getString('tournament_played')),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 1.0,
          ),
          Card(
            elevation: 3.0,
            margin: EdgeInsets.all(1.0),
            child: Container(
              width: SizeConfig.getWidth(28),
              decoration: BoxDecoration(
                  //borderRadius:BorderRadius.only(topLeft: Radius.circular(20.0), bottomLeft: Radius.circular(20.0)),
                  gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: <Color>[initialBlueColor, endBlueColor],
                      tileMode: TileMode.repeated)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  getTextWidgetForStat(provider.userDetails.won.toString()),
                  SizedBox(
                    height: 4.0,
                  ),
                  getTextWidgetForStatText(
                      AppTranslations.of(context).getString('tournament_won')),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 1.0,
          ),
          Card(
            elevation: 3.0,
            margin: EdgeInsets.all(1.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0)),
            ),
            child: Container(
              width: SizeConfig.getWidth(28),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0)),
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: <Color>[initialPeachColor, endPeachColor],
                      tileMode: TileMode.repeated)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  getTextWidgetForStat(
                      '${provider.userDetails.winningPercentage}%'),
                  SizedBox(
                    height: 4.0,
                  ),
                  getTextWidgetForStatText(
                      AppTranslations.of(context).getString('win_percentage')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRecommendation(HomeScreenProvider provider) {
    return provider.isRecommendationReady
        ? Container(
            height: SizeConfig.getHeight(55),
            child: Column(
              children: <Widget>[
                Container(
                  height: SizeConfig.getHeight(52),
                  child: ListView.separated(
                      controller: _scrollController,
                      padding: EdgeInsets.only(bottom: 5.0),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return buildRecommendationCard(provider, index);
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Container();
                      },
                      itemCount: provider.tournaments.length),
                ),
                provider.isLoadingMoreRecommendation
                    ? Container(
                        height: SizeConfig.getHeight(3.0),
                        child: Center(
                          child: Text(
                              AppTranslations.of(context).getString('loading')),
                        ),
                      )
                    : Container()
              ],
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  Widget getTextWidgetForStat(String text, {Color color = whiteColor}) {
    return Text(
      text,
      style: TextStyle(
          color: color,
          fontSize: SizeConfig.getTextSize(4),
          fontWeight: FontWeight.bold),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget getTextWidgetForStatText(String text, {Color color = whiteColor}) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: SizeConfig.getTextSize(3)),
      textAlign: TextAlign.center,
    );
  }

  Widget getHeaderText(String text) {
    return Text(
      text,
      style: TextStyle(
          color: textColor,
          fontSize: SizeConfig.getTextSize(6),
          fontWeight: FontWeight.w500),
    );
  }

  Widget buildRecommendationCard(HomeScreenProvider provider, int index) {
    return Container(
      padding: EdgeInsets.only(
          top: SizeConfig.getWidth(2.0),
          left: SizeConfig.getWidth(5.0),
          right: SizeConfig.getWidth(5.0)),
      child: Card(
        elevation: 3.0,
        margin: EdgeInsets.all(1.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        )),
        child: Container(
          height: SizeConfig.getHeight(19),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            color: whiteColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 10,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0)),
                  child: ImageLoader().loadWithWidthHeight(
                      provider.tournaments[index].coverUrl,
                      boxFit: BoxFit.cover,
                      width: double.infinity),
                ),
              ),
              Container(
                color: nextIconColor,
                height: 1.0,
              ),
              Expanded(
                flex: 9,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 6,
                      child: Container(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            getTextWidgetForStat(
                                provider.tournaments[index].name,
                                color: textColor),
                            SizedBox(
                              height: 4.0,
                            ),
                            getTextWidgetForStatText(
                                provider.tournaments[index].gameName,
                                color: textColor),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                          child: Icon(
                        Icons.arrow_back_ios,
                        color: nextIconColor,
                        size: SizeConfig.getHeight(2),
                        textDirection: TextDirection.rtl,
                      )),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void tryLogOut(HomeScreenProvider provider) {
    TextDialog.showTextDialog(
        context, AppTranslations.of(context).getString('log_out_msg'),
        title: AppTranslations.of(context).getString('log_out'),
        onPressed: () async {
      await provider.logout();
      Routes().navigateWithReplace(LOGIN_SCREEN);
    },
        isNeedToAvoidOnPressCallOnBackPress: true,
        cancelButtonText: AppTranslations.of(context).getString('cancel'));
  }

  @override
  void dispose(){
    _scrollController.dispose();
    super.dispose();
  }
}
