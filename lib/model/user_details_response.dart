import 'base_response.dart';

class UserDetails extends BaseResponse{

  UserDetails.fromJson(Map<String, dynamic> json):super.fromJson(json){
    name = json['name'];
    image = json['image'];
    rating = json['rating'];
    played = json['played'];
    won = json['won'];
    winningPercentage = json['winning_percentage'];
  }

  String name;
  String image;
  int rating;
  int played;
  int won;
  int winningPercentage;

  @override
  String toString() {
    return 'UserDetails{name: $name, image: $image, rating: $rating, played: $played, won: $won, winningPercentage: $winningPercentage}';
  }


}