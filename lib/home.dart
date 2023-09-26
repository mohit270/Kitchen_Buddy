import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kitchen_buddy/model.dart';
import 'package:kitchen_buddy/recipe_view.dart';
import 'package:kitchen_buddy/search.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  // ignore: library_private_types_in_public_api
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
        "https://api.edamam.com/search?q=$query&app_id=14d768d2&app_key=6d037e21b672ce0508618ecc94f9bb1f";
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
    log(recipeList as String);
  }

  @override
  void initState() {
    super.initState();
    getRecipes("healthy");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xff213A50), Color(0xff071938)])),
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              //Search Bar
              SafeArea(
                child: Container(
                  //Search Wala Container

                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
                            log("Blank search");
                          } else {
                            Navigator.push(
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
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
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
                        margin: const EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.6)),
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
                              ),
                            ),
                            Positioned(
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  decoration: const BoxDecoration(
                                      color: Colors.black54),
                                  child: Text(
                                    recipeList[index].applabel,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                )),
                            Positioned(
                                right: 0,
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10))),
                                  height: 50,
                                  width: 100,
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.local_fire_department),
                                        Text(
                                          recipeList[index]
                                              .appcalories
                                              .toString()
                                              .substring(0, 6),
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      ),
                    );
                  }),
              SizedBox(
                height: 100,
                child: isloading
                    ? const Center(child: CircularProgressIndicator.adaptive())
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
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 10),
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
      ]),
    );
  }

  void performSearch() {
    String query = searchController.text;
    if ((searchController.text).replaceAll(" ", "") == "") {
      log("Blank search");
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: ((context) => Search(query))));
    }

    // You can update the UI or navigate to a new screen with search results.
  }
}
