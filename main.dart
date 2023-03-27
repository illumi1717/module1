import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monument Slider Demo',
      debugShowCheckedModeBanner: false,
      home: MonumentSlider(),
    );
  }
}

class Monument {
  final String name;
  final String description;
  final String imageUrl;

  Monument({
    required this.name,
    required this.description,
    required this.imageUrl,
  });
}

class MonumentCard extends StatelessWidget {
  final Monument monument;

  MonumentCard({required this.monument});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            monument.imageUrl,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 9.0),
          Text(
            monument.name,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Text(
            monument.description,
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class MonumentSlider extends StatefulWidget {
  @override
  _MonumentSliderState createState() => _MonumentSliderState();
}

class _MonumentSliderState extends State<MonumentSlider> {
  List<Monument> monuments = [];
  int _currentIndex = 0;

  Future<void> fetchMonuments() async {
    final List<dynamic> responseData = json.decode(
        '[{ "name" : "Святогірський заповідник", "description" : "Розташований біля підніжжя крейдяних, на правому березі річки Сіверський Донець.", "imageUrl" : "https://rest.guru.ua/img/place_photo/991/2141.jpg" }, { "name" : "Заповідник «Переяслав»", "description" : "Заповідник «Переяслав» віднесено до сфери управління Міністерства культури та інформаційної політики України.", "imageUrl" : "https://upload.wikimedia.org/wikipedia/commons/e/e7/Museum_of_the_Kobzars%2C_Pereiaslav-Khmelnytskyi.JPG" }, { "name" : "Мечеть Кебір-Джамі", "description" : "Соборна мечеть у Сімферополі (Крим) пам\'ятка архітектури XVI століття. Найстаріша будівля міста (саме їй воно завдячує своєю назвою).", "imageUrl" : "https://avdet.org/wp-content/uploads/2016/08/simferopol-73-foto.jpg" }, { "name" : "Херсонес Таврійський", "description" : "Музей, відкритий 1892 на базі археологічних знахідок з розкопів старогрецького міста Херсонесу.", "imageUrl" : "https://upload.wikimedia.org/wikipedia/commons/9/96/Chersonesos_columns.jpg" } ]');

    setState(() {
      monuments = responseData
          .map((monument) => Monument(
              name: monument['name'],
              description: monument['description'],
              imageUrl: monument['imageUrl']))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchMonuments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monument Slider'),
      ),
      body: monuments.isNotEmpty
          ? CarouselSlider(
              options: CarouselOptions(
                height: 400,
                viewportFraction: 0.8,
                enableInfiniteScroll: true,
                autoPlay: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              items: monuments
                  .map((monument) => MonumentCard(monument: monument))
                  .toList(),
            )
          : Center(child: CircularProgressIndicator()),
      bottomNavigationBar: MonumentSliderControls(
        onLeftPressed: () => _currentIndex > 0
            ? setState(() => _currentIndex--)
            : setState(() => _currentIndex = monuments.length - 1),
        onRightPressed: () => _currentIndex < monuments.length - 1
            ? setState(() => _currentIndex++)
            : setState(() => _currentIndex = 0),
      ),
    );
  }
}

class MonumentSliderControls extends StatelessWidget {
  final VoidCallback onLeftPressed;
  final VoidCallback onRightPressed;

  MonumentSliderControls(
      {required this.onLeftPressed, required this.onRightPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: onLeftPressed,
        ),
        IconButton(
          icon: Icon(Icons.arrow_forward_ios),
          onPressed: onRightPressed,
        ),
      ],
    );
  }
}
