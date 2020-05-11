class City{
  int _id;
  String _name;
  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  static fromJson(Map<String,dynamic> value){
    var city=City();
    city.name=value['name'];
    city.id=value['id'];
    return city;
  }

  static toJsonMap(List<City> cities){
    List<Map<String,dynamic>> dyn=new List();
    Map<String,dynamic> city=null;
    for(City c in cities){
      city=new Map();
      city['name']=c.name;
      dyn.add(city);
    }
    return dyn;
  }

}