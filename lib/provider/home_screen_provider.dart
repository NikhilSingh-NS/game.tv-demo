import 'package:game_tv_demo/model/tournament.dart';
import 'package:game_tv_demo/model/tournaments_response.dart';
import 'package:game_tv_demo/model/user_details_response.dart';
import 'package:game_tv_demo/service/data_repo/repository.dart';
import 'package:game_tv_demo/utils/shared_preference_interface.dart';
import 'package:game_tv_demo/utils/utility.dart';
import 'package:flutter/material.dart';

enum HOME_SCREEN_STATE { NO_INTERNET, SUCCESS, FAILURE }

class HomeScreenProvider extends ChangeNotifier {
  HomeScreenProvider() {
    if (!isReady) {
      Utility.isInternetConnected().then((bool value) {
        if (value) {
          Repository().getUserDetails().then((UserDetails details) {
            if (details.statusCode == 200) {
              userDetails = details;
              homeScreenState = HOME_SCREEN_STATE.SUCCESS;
            } else {
              homeScreenState = HOME_SCREEN_STATE.FAILURE;
            }
            isReady = true;
            notifyListeners();
          });
          Repository()
              .getTournamentsData()
              .then((TournamentsResponse tournamentsResponse) {
            if (tournamentsResponse.statusCode == 200) {
              this.tournamentsResponse = tournamentsResponse;
              tournaments = <Tournament>[];
              tournaments.addAll(tournamentsResponse.tournaments);
              homeScreenState = HOME_SCREEN_STATE.SUCCESS;
            } else {
              homeScreenState = HOME_SCREEN_STATE.FAILURE;
            }
            isRecommendationReady = true;
            notifyListeners();
          });
        } else {
          isReady = true;
          homeScreenState = HOME_SCREEN_STATE.NO_INTERNET;
          notifyListeners();
        }
      });
    }
  }

  List<Tournament> tournaments;
  TournamentsResponse tournamentsResponse;
  UserDetails userDetails;
  bool isReady = false;
  bool isRecommendationReady = false;
  bool isLoadingMoreRecommendation = false;
  HOME_SCREEN_STATE homeScreenState;

  void addRecommendation() {
    if (!isLoadingMoreRecommendation && !tournamentsResponse.isLastBatch) {
      Utility.isInternetConnected().then((bool value) {
        if (value) {
          isLoadingMoreRecommendation = true;
          Repository()
              .getTournamentsData(cursor: tournamentsResponse.cursor)
              .then((TournamentsResponse tournamentsResponse) {
            if (tournamentsResponse.statusCode == 200) {
              this.tournamentsResponse = tournamentsResponse;
              tournaments.addAll(tournamentsResponse.tournaments);
              homeScreenState = HOME_SCREEN_STATE.SUCCESS;
            } else {
              //homeScreenState = HOME_SCREEN_STATE.FAILURE;
            }
            isLoadingMoreRecommendation = false;
            notifyListeners();
          });
          notifyListeners();
        }
      });
    }
  }

  Future<void> logout() async{
    await SharedPreferenceInterface().setInt(LOGGED_IN_USER_ID, -1);
  }

}
