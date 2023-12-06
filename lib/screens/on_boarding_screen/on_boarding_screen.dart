import 'dart:async';

import 'package:flutter/rendering.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/screens/auth_screens/auth_screen.dart';
import 'package:meetox/screens/on_boarding_screen/components/build_subtitle.dart';
import 'package:meetox/services/secure_storage_services.dart';
import 'package:meetox/widgets/custom_button.dart';

import '../../core/imports/core_imports.dart';
import '../../models/boarding_model.dart';
import 'components/build_title.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController pageController = PageController();
  final RxString swipingDirection = 'right'.obs;
  RxInt currentPage = 0.obs;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (currentPage < 2) {
        currentPage++;
      } else {
        currentPage.value = 0;
      }

      pageController.animateToPage(
        currentPage.value,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: context.theme.appBarTheme.backgroundColor,
        elevation: 0,
        systemOverlayStyle: context.theme.appBarTheme.systemOverlayStyle,
        iconTheme: context.theme.appBarTheme.iconTheme,
      ),
      body: PageView.builder(
        controller: pageController,
        itemCount: boardings.length,
        onPageChanged: (int page) {
          if (pageController.position.userScrollDirection ==
              ScrollDirection.reverse) {
            swipingDirection.value = 'right';
          } else {
            swipingDirection.value = 'left';
          }
        },
        itemBuilder: (context, index) {
          final BoardingModel board = boardings[index];
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Column(
                children: [
                  Obx(
                    () => swipingDirection.value == 'right'
                        ? SlideInLeft(
                            delay: const Duration(milliseconds: 100),
                            duration: const Duration(seconds: 1),
                            from: 300,
                            child: FlutterLogo(
                              size: 100.sp,
                            ),
                          )
                        : SlideInRight(
                            delay: const Duration(milliseconds: 100),
                            duration: const Duration(seconds: 1),
                            from: 300,
                            child: FlutterLogo(
                              size: 100.sp,
                            ),
                          ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SmoothPageIndicator(
                    controller: pageController, // PageController
                    count: boardings.length,
                    effect: ExpandingDotsEffect(
                      dotHeight: 6.sp,
                      dotWidth: 6.sp,
                      activeDotColor: AppColors.primaryYellow,
                      dotColor: AppColors.customGrey,
                    ), // your preferred effect
                    onDotClicked: (index) {},
                  ),
                  SizedBox(height: 20.sp),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Transform.rotate(
                        angle: 0.1,
                        child: Container(
                          height: 200.sp,
                          width: Get.width,
                          margin: EdgeInsets.only(
                              bottom: 40.sp, right: 20.sp, left: 20.sp),
                          decoration: BoxDecoration(
                            color: context.isDarkMode
                                ? Colors.black
                                : AppColors.customGrey,
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                      FlipInY(
                        delay: const Duration(milliseconds: 300),
                        child: Container(
                          height: 200.sp,
                          width: Get.width,
                          margin: EdgeInsets.only(
                              bottom: 40.sp, right: 20.sp, left: 20.sp),
                          decoration: BoxDecoration(
                            color: AppColors.primaryYellow,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Obx(
                                () => swipingDirection.value == 'right'
                                    ? SlideInLeft(
                                        delay:
                                            const Duration(milliseconds: 100),
                                        duration: const Duration(seconds: 1),
                                        from: 300,
                                        child: BuildTitle(
                                          title: board.title,
                                        ),
                                      )
                                    : SlideInRight(
                                        delay:
                                            const Duration(milliseconds: 100),
                                        duration: const Duration(seconds: 1),
                                        from: 300,
                                        child: BuildTitle(
                                          title: board.title,
                                        ),
                                      ),
                              ),
                              Obx(
                                () => swipingDirection.value == 'right'
                                    ? SlideInLeft(
                                        delay:
                                            const Duration(milliseconds: 100),
                                        duration: const Duration(seconds: 1),
                                        from: 300,
                                        child: BuildSubTitle(
                                          subTitle: board.subTitle,
                                        ),
                                      )
                                    : SlideInRight(
                                        delay:
                                            const Duration(milliseconds: 100),
                                        duration: const Duration(seconds: 1),
                                        from: 300,
                                        child: BuildSubTitle(
                                          subTitle: board.subTitle,
                                        ),
                                      ),
                              ),
                              Obx(
                                () => swipingDirection.value == 'right'
                                    ? SlideInLeft(
                                        delay:
                                            const Duration(milliseconds: 100),
                                        duration: const Duration(seconds: 1),
                                        from: 300,
                                        child: CustomButton(
                                          width: Get.width * 0.5,
                                          color: AppColors.customBlack,
                                          text: "Let's Go",
                                          onPressed: () {
                                            SecureStorageServices.putValue(
                                                key: 'isFirstTime',
                                                value: 'false');
                                            Get.to(() => const AuthScreen());
                                          },
                                        ),
                                      )
                                    : SlideInRight(
                                        delay:
                                            const Duration(milliseconds: 100),
                                        duration: const Duration(seconds: 1),
                                        from: 300,
                                        child: CustomButton(
                                          width: Get.width * 0.5,
                                          color: AppColors.customBlack,
                                          text: "Let's Go",
                                          onPressed: () {
                                            SecureStorageServices.putValue(
                                                key: 'isFirstTime',
                                                value: 'false');
                                            Get.to(() => const AuthScreen());
                                          },
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
