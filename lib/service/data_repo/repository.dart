import 'package:game_tv_demo/model/tournaments_response.dart';
import 'package:game_tv_demo/model/user_details_response.dart';

import 'repository_implementation.dart';

abstract class Repository{
  factory Repository(){
    return RepositoryImplementation();
  }

  Future<UserDetails> getUserDetails();

  Future<TournamentsResponse> getTournamentsData({String cursor});

  int verifyUser(String phoneNumber, String password);

}