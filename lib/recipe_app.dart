import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:recipe_app/model.dart';
import 'package:recipe_app/recipeView.dart';
import 'package:recipe_app/search.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isloading = true;
  List<RecipeModel> recipeList = <RecipeModel>[];
  TextEditingController searchController = TextEditingController();
  List reciptCatList = [
    {
      "imgUrl":
          "https://images.pexels.com/photos/7230625/pexels-photo-7230625.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
      "heading": "Spicy Food"
    },
    {
      "imgUrl":
          "https://rachnacooks.com/wp-content/uploads/2020/08/kadaichicken9-1.jpg",
      "heading": "Chicken"
    },
    {
      "imgUrl":
          "https://images.pexels.com/photos/2474661/pexels-photo-2474661.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
      "heading": "Indian Food"
    },
    {
      "imgUrl":
          "https://images.pexels.com/photos/2089712/pexels-photo-2089712.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
      "heading": "Chinese"
    },
    {
      "imgUrl":
          "https://images.pexels.com/photos/1059905/pexels-photo-1059905.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
      "heading": "Salad"
    },
    {
      "imgUrl":
          "https://images.pexels.com/photos/1854652/pexels-photo-1854652.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
      "heading": "Sweets"
    }
  ];
  getRecipes(String query) async {
    String url =
        "https://api.edamam.com/search?q=$query&app_id=ebb6041c&app_key=3c33ad913ab23b8554082bfb5fdd78b5";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      data["hits"].forEach((element) {
        RecipeModel recipeModel = RecipeModel();
        recipeModel = RecipeModel.fromMap(element["recipe"]);
        recipeList.add(recipeModel);
        setState(() {
          isloading = false;
        });
        log(recipeList.toString());
      });
    });

    for (var Recipe in recipeList) {
      print(Recipe.applabel);
      print(Recipe.appcalories);
    }
  }

  @override
  void initState() {
    super.initState();
    getRecipes('Healthy');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blueGrey.shade900,
                  const Color.fromARGB(255, 8, 43, 59)
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                //Search Bar
                SafeArea(
                  child: Container(
                    //Search Wala Container

                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24)),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search Recipe Here ",
                            ),
                            onSubmitted: (value) {
                              performSearch();
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if ((searchController.text).replaceAll(" ", "") ==
                                "") {
                              print("Blank search");
                            } else {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          Search(searchController.text))));
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(3, 0, 7, 0),
                            child: Icon(
                              Icons.search,
                              color: Colors.blueAccent.shade400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "WHAT DISH WOULD YOU LIKE TODAY?",
                        style: TextStyle(fontSize: 33, color: Colors.white),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Let's Eat Something New!",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )
                    ],
                  ),
                ),
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: recipeList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RecipeView(recipeList[index].appurl),
                              ));
                        },
                        child: Card(
                          margin: const EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0.0,
                          child: Stack(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(
                                    recipeList[index].appimgUrl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 200,
                                  )),
                              Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      decoration: const BoxDecoration(
                                          color: Colors.black26),
                                      child: Text(
                                        recipeList[index].applabel,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ))),
                              Positioned(
                                right: 0,
                                height: 40,
                                width: 80,
                                child: Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10))),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.local_fire_department,
                                            size: 15,
                                          ),
                                          Text(recipeList[index]
                                              .appcalories
                                              .toString()
                                              .substring(0, 6)),
                                        ],
                                      ),
                                    )),
                              )
                            ],
                          ),
                        ),
                      );
                    }),

                SizedBox(
                  height: 100,
                  child: isloading
                      ? const Center(
                          child: CircularProgressIndicator.adaptive())
                      : ListView.builder(
                          itemCount: reciptCatList.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) => Search(
                                              reciptCatList[index]["heading"],
                                            ))));
                              },
                              child: Card(
                                  margin: const EdgeInsets.all(20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  elevation: 0.0,
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          child: Image.network(
                                            reciptCatList[index]["imgUrl"],
                                            fit: BoxFit.cover,
                                            width: 200,
                                            height: 250,
                                          )),
                                      Positioned(
                                          left: 0,
                                          right: 0,
                                          bottom: 0,
                                          top: 0,
                                          child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 10),
                                              decoration: const BoxDecoration(
                                                  color: Colors.black26),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    reciptCatList[index]
                                                        ["heading"],
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 28),
                                                  ),
                                                ],
                                              ))),
                                    ],
                                  )),
                            );
                          }),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void performSearch() {
    // Implement your search logic here
    String query = searchController.text;
    if ((searchController.text).replaceAll(" ", "") == "") {
      print("Blank search");
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: ((context) => Search(searchController.text))));
    }

    // You can update the UI or navigate to a new screen with search results.
  }
}
