import 'package:flutter/material.dart';
import 'package:larva_detector_app_v3/components/my_content_box.dart';
import 'package:larva_detector_app_v3/models/image_model.dart';
import 'package:larva_detector_app_v3/pages/import_picture_page.dart';
import 'package:larva_detector_app_v3/pages/live_analysis_page.dart';// import 'package:larva_detector_app/components/my_content_box.dart';
// import 'package:larva_detector_app/components/my_drawer.dart';
// import 'package:larva_detector_app/models/image_model.dart';
// import 'package:larva_detector_app/pages/import_picture_page.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future navigateToImportPicture(context) async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => LoaderOverlay(child: ImportPicturePage())));
  }

  Future navigateToImportTake(context) async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => LoaderOverlay(child: ImportPicturePage())));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ImageModel>(
      builder: (context, value, child) => SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            title: const Text("HOME PAGE"),
            backgroundColor: Theme.of(context).colorScheme.surface,
            elevation: 0,
          ),
          // drawer: const MyDeawer(),
          body: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Container(
              height: double.infinity,
              alignment: Alignment.topCenter,
              child: Column(children: [
                //Option 1
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    // connet class
                    final addState = context.read<ImageModel>();

                    // set value
                    addState.setIsImportImage(1);

                    navigateToImportPicture(context);
                  },
                  child: SizedBox(
                    // height: 100,
                    width: double.infinity,
                    child: MyContentBox(
                      height: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          "lib/assets/images/IMG_1.jpg",
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                )),
                const SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () async {
                    // connet class
                    final addState = context.read<ImageModel>();

                    // set value
                    addState.setIsImportImage(1);
                    navigateToImportPicture(context);
                  },
                  child: SizedBox(
                    child: Column(children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Upload picture",
                          style: TextStyle(
                              fontSize: 20,
                              color:
                                  Theme.of(context).colorScheme.inversePrimary),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "You can upload your picture from your smart phone from here!",
                          style: TextStyle(
                              fontSize: 15,
                              color:
                                  Theme.of(context).colorScheme.inversePrimary),
                        ),
                      ),
                    ]),
                  ),
                ),

                const SizedBox(
                  height: 25,
                ),

                //Option 2
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    // connet class
                    final addState = context.read<ImageModel>();

                    // set value
                    addState.setIsImportImage(0);
                    navigateToImportTake(context);
                  },
                  child: SizedBox(
                    // height: 100,
                    width: double.infinity,
                    child: MyContentBox(
                      height: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          "lib/assets/images/IMG_2.jpg",
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                )),
                // Add this under your Option 2 in home_page.dart:
                const SizedBox(height: 25),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const LiveAnalysisPage()
                      ));
                    },
                    child: SizedBox(
                      width: double.infinity,
                      child: MyContentBox(
                        height: 100,
                        child: Center(
                          child: Text(
                            "Connect to Live Stream",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                /*const SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () {
                    // connet class
                    final addState = context.read<ImageModel>();

                    // set value
                    addState.setIsImportImage(0);
                    navigateToImportTake(context);
                  },
                  child: SizedBox(
                    child: Column(children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Take a picture",
                          style: TextStyle(
                              fontSize: 20,
                              color:
                                  Theme.of(context).colorScheme.inversePrimary),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "You can taks a picture real time from your farm on here!",
                          style: TextStyle(
                              fontSize: 15,
                              color:
                                  Theme.of(context).colorScheme.inversePrimary),
                        ),
                      ),
                    ]),
                  ),
                ),*/
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
