import 'base_response.dart';
import 'tournament.dart';

class TournamentsResponse extends BaseResponse {

  TournamentsResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    Map<String, dynamic> data = json['data'];
    tournaments = <Tournament>[];
    if (data != null) {
      if (data['tournaments'] != null) {
        data['tournaments'].forEach((dynamic tournament) {
          tournaments.add(Tournament.fromJson(tournament));
        });
      }
      isLastBatch = data['is_last_batch'];
      cursor = data['cursor'];
    }
  }

  List<Tournament> tournaments;

  String cursor;
  bool isLastBatch;
}
