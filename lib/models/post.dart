

class Post {
  String firstname;
  String lastname;
  String date;
  String content;
  String userId;
  String image;

  Post(this.firstname, this.lastname, this.date, this.content, this.userId, this.image);

  Post.FromJson(Map<String, dynamic> json)
      : firstname = json['firstname'],
        lastname = json['lastname'],
        date = json['date'],
        content = json['content'],
        userId = json['userId'],
        image = json['image'];

  Post.fromjson(dynamic json)
      : firstname = json['firstname'],
        lastname = json['lastname'],
        date = json['date'],
        content = json['content'],
        userId = json['userId'],
        image = json['image'];

  Map<String, String> Tojson() => {
      'firstname' : firstname,
      'lastname' : lastname,
      'date' : date,
      'content' : content,
      'userId' : userId,
      'image' : image,
  };    
        
}
