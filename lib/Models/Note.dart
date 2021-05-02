class Note{
  int _id;
  String _title;
  String _description;
  String _date;
  int _priorities;

  Note(this._title, this._description, this._date, [this._priorities]);

  Note.withId(this._id, this._title, this._description, this._date, [this._priorities]);

  int get id => _id;
  String get title => _title;
  String get description => _description;
  String get date => _date;
  int get priorities => _priorities;

  set title(String newTitle){
    if(newTitle.length<=255){
      this._title = newTitle;
    }
  }

  set description(String newDescription){
    if(newDescription.length<=255){
      this._description = newDescription;
    }
  }

  set priorities(int newPriorities){
    if(newPriorities==1 || newPriorities==2){
      this._priorities = newPriorities;
    }
  }

  set date(String newDate){
    this._date = newDate;
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    if(id!=null){
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['date'] = _date;
    map['priorities'] = _priorities;
    return map;
  }

  Note.fromMapObject(Map<String, dynamic> map){
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._date = map['date'];
    this._priorities = map['priorities'];
  }
}