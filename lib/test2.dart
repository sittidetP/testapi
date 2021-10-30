import 'package:flutter/material.dart';
import 'package:testapi/model/food_item.dart';
import 'package:testapi/services/api.dart';

class Test2 extends StatefulWidget {
  const Test2({Key? key}) : super(key: key);

  @override
  _Test2State createState() => _Test2State();
}

class _Test2State extends State<Test2> {
  List<FoodItem> _foodList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Food List"),
      ),
      body: Container(
              child: ListView.builder(
                  padding: EdgeInsets.all(16.0),
                  itemCount: _foodList.length,
                  itemBuilder: (BuildContext context, int index) {
                    var foodItem = _foodList[index];

                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Image.network(
                            foodItem.image,
                            width: 80.0,
                            height: 80.0,
                            fit: BoxFit.cover,
                          ),
                          Expanded(
                              child: Container(
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Text(foodItem.name),
                                    Text(foodItem.price.toString())
                                  ],
                                )
                              ],
                            ),
                          ))
                        ],
                      ),
                    );
                  })),
    );
  }

  Future<List<FoodItem>> _loadFood() async {
    List list = await Api().fetch('foods');
    var foodList = list.map((item) => FoodItem.fromJson(item)).toList();
    return foodList;
  }

  @override
  void initState() {
    super.initState();

    _loadFood().then((list) {
      _foodList = list;
    });
  }
}
