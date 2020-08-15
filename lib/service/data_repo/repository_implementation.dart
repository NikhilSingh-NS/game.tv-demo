import 'package:game_tv_demo/model/base_response.dart';
import 'package:game_tv_demo/model/tournaments_response.dart';
import 'package:game_tv_demo/model/user_details_response.dart';
import 'package:game_tv_demo/service/data_repo/local/user_login_validation.dart';
import 'package:game_tv_demo/service/data_repo/network/base_api.dart';
import 'package:game_tv_demo/utils/constants.dart';

import 'repository.dart';

class RepositoryImplementation implements Repository {
  @override
  Future<TournamentsResponse> getTournamentsData({String cursor}) async {
    final String url = cursor == null
        ? '$baseTournamentsUrl$limitCount'
        : '$baseTournamentsUrl$limitCount&cursor=$cursor';
    final BaseApi baseApi = BaseApi(url, RequestType.GET);
    dynamic response = await baseApi.makeRequest();
    TournamentsResponse tournamentsResponse;
    if (response['status'] == 200) {
      tournamentsResponse = TournamentsResponse.fromJson(response);
      return tournamentsResponse;
    } else
      return Future.value(
          BaseResponse.fromJson(response) as TournamentsResponse);
  }

  @override
  Future<UserDetails> getUserDetails() async {
    final BaseApi baseApi = BaseApi(userDetailsUrl, RequestType.GET);
    dynamic response = await baseApi.makeRequest();
    UserDetails userDetails;
    if (response['status'] == 200) {
      print(response);
      userDetails = UserDetails.fromJson(response);
      return userDetails;
    } else
      return Future.value(BaseResponse.fromJson(response) as UserDetails);
  }

  @override
  int verifyUser(String phoneNumber, String password) {
    return UserLogInValidation().checkUserInfo(phoneNumber, password);
  }
}
