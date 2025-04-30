import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:love_quest/core/config/theme.dart';
import 'package:love_quest/features/film_choosing/film_choosing.controller.dart';
import 'package:love_quest/widgets/Appbar.dart';

class FilmChoosingPage extends GetView<FilmChoosingController> {
  const FilmChoosingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBarCustomize(title: "Movie"),
            Container(
              height:
                  300, // Phải set chiều cao để Expanded không lỗi trong Column
              child: Column(
                children: [
                  Expanded(
                      child: CarouselSlider(
                    items: controller.imgList
                        .map((item) => Container(
                              margin: const EdgeInsets.all(5.0),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(18.0)),
                                child: Stack(
                                  children: <Widget>[
                                    Image.network(
                                      item,
                                      fit: BoxFit.cover,
                                      width: 1000.0,
                                    ),
                                    Positioned(
                                      bottom: 0.0,
                                      left: 0.0,
                                      right: 0.0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color.fromARGB(200, 0, 0, 0),
                                              Color.fromARGB(0, 0, 0, 0),
                                            ],
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 20.0),
                                        child: Text(
                                          'No. ${controller.imgList.indexOf(item)} image',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ))
                        .toList(),
                    carouselController: controller.carouselSliderController,
                    options: CarouselOptions(
                      autoPlay: true,
                      enlargeCenterPage: true,
                      aspectRatio: 2,
                      onPageChanged: (index, reason) {
                        controller.changeCurrentIndex(index);
                      },
                    ),
                  )),
                  Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                            controller.imgList.asMap().entries.map((entry) {
                          return GestureDetector(
                            onTap: () => controller.carouselSliderController
                                .animateToPage(entry.key),
                            child: Container(
                              width: 8.0,
                              height: 8.0,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 4.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black)
                                    .withOpacity(controller.current == entry.key
                                        ? 0.9
                                        : 0.4),
                              ),
                            ),
                          );
                        }).toList(),
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 32,
            ),
            Container(
              margin: EdgeInsets.only(left: 32),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 100,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(right: 12),
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                          color: Color(0xFF3A21D9),
                          borderRadius: BorderRadius.circular(12)),
                      child: Text(
                        "Action",
                        style:
                            Styles.mediumTextW800.copyWith(color: Colors.white),
                      ),
                    ),
                    Container(
                      width: 100,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(right: 12),
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                          color: Color(0xFF3A21D9),
                          borderRadius: BorderRadius.circular(12)),
                      child: Text(
                        "Action",
                        style:
                            Styles.mediumTextW800.copyWith(color: Colors.white),
                      ),
                    ),
                    Container(
                      width: 100,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(right: 12),
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                          color: Color(0xFF3A21D9),
                          borderRadius: BorderRadius.circular(12)),
                      child: Text(
                        "Action",
                        style:
                            Styles.mediumTextW800.copyWith(color: Colors.white),
                      ),
                    ),
                    Container(
                      width: 100,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(right: 12),
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                          color: Color(0xFF3A21D9),
                          borderRadius: BorderRadius.circular(12)),
                      child: Text(
                        "Action",
                        style:
                            Styles.mediumTextW800.copyWith(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 32,
            ),
            Container(
              // margin: EdgeInsets.only(left: 32, right: 32),
              child: Wrap(
                runSpacing: 32,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.bottomSheet(
                        Container(
                          height: Get.height * 0.6,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Text căn giữa
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Text(
                                        "Movie Detail",
                                        style: Styles.bigTextW700,
                                      ),
                                    ),
                                    // Nút close góc phải
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                        icon: Icon(Icons.close, size: 32,),
                                        onPressed: () {
                                          Get.back();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                  child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 18, right: 18),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Purple Heart",
                                                style: Styles.mediumTextW800,
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                  style: Styles.mediumTextW800
                                                      .copyWith(
                                                          color: Colors.black),
                                                  children: [
                                                    TextSpan(
                                                        text: "Directed by "),
                                                    TextSpan(
                                                      text: "Jame Mangold",
                                                      style: Styles
                                                          .mediumTextW800
                                                          .copyWith(
                                                              color: Colors
                                                                  .purple),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                  style: Styles.mediumTextW800
                                                      .copyWith(
                                                          color: Colors.black),
                                                  children: [
                                                    TextSpan(
                                                        text: "Released date "),
                                                    TextSpan(
                                                      text: "2023",
                                                      style: Styles
                                                          .mediumTextW800
                                                          .copyWith(
                                                              color:
                                                                  Colors.blue),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                  style: Styles.mediumTextW800
                                                      .copyWith(
                                                          color: Colors.black),
                                                  children: [
                                                    TextSpan(text: "Duration "),
                                                    TextSpan(
                                                      text: "2h 20m",
                                                      style: Styles
                                                          .mediumTextW800
                                                          .copyWith(
                                                              color:
                                                                  Colors.green),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            width: 120,
                                            height: 200,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    'https://toomva.com/images/videos/2022/11/trai-tim-mau-tim-2022-1667485708.jpg'), // Phải dùng NetworkImage
                                                fit: BoxFit
                                                    .cover, // tuỳ chọn: cover, contain, fill...
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 32,
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(left: 18),
                                        child: Text(
                                          "Description",
                                          style: Styles.bigTextW800,
                                        )),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 18, right: 18),
                                        child: Text(
                                          'Purple Heart follows Cassie, an aspiring musician, and Luke, a Marine with a troubled past, who agree to marry solely for military benefits. As Luke prepares for deployment and Cassie faces her own struggles at home, what began as a practical arrangement slowly transforms into a deep and genuine love. Set against the realities of war, sacrifice, and dreams deferred, the film captures the power of unexpected connections and the healing strength of love.',
                                          style: Styles.mediumTextW500,
                                          textAlign: TextAlign.justify,
                                        )),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Center(
                                      child: AbsorbPointer(
                                        absorbing: !controller.canChoose.value,
                                        child: GestureDetector(
                                          onTap: () {
                                            controller.handleChoosingFilm();
                                          },
                                          child: Obx(() {
                                            return Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8, horizontal: 18),
                                              decoration: BoxDecoration(
                                                  color: controller.canChoose.value ? AppColors.primary : Colors.grey,
                                                  borderRadius:
                                                  BorderRadius.circular(18)),
                                              child: Text(
                                                'Watch',
                                                style: Styles.mediumTextW700
                                                    .copyWith(color: Colors.white),
                                              ),
                                            );
                                          })
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                  ],
                                ),
                              )),
                            ],
                          ),
                        ),
                        isScrollControlled: true,
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 32),
                      child: Column(
                        children: [
                          Container(
                            width: 160,
                            height: 280,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                    'https://toomva.com/images/videos/2022/11/trai-tim-mau-tim-2022-1667485708.jpg'), // Phải dùng NetworkImage
                                fit: BoxFit
                                    .cover, // tuỳ chọn: cover, contain, fill...
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            "Purple Hearts",
                            style: Styles.mediumTextW700
                                .copyWith(color: Colors.grey),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 32),
                    child: Column(
                      children: [
                        Container(
                          width: 160,
                          height: 280,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  'https://toomva.com/images/videos/2022/11/trai-tim-mau-tim-2022-1667485708.jpg'), // Phải dùng NetworkImage
                              fit: BoxFit
                                  .cover, // tuỳ chọn: cover, contain, fill...
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          "Purple Hearts",
                          style: Styles.mediumTextW700
                              .copyWith(color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 32),
                    child: Column(
                      children: [
                        Container(
                          width: 160,
                          height: 280,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  'https://toomva.com/images/videos/2022/11/trai-tim-mau-tim-2022-1667485708.jpg'), // Phải dùng NetworkImage
                              fit: BoxFit
                                  .cover, // tuỳ chọn: cover, contain, fill...
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          "Purple Hearts",
                          style: Styles.mediumTextW700
                              .copyWith(color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
