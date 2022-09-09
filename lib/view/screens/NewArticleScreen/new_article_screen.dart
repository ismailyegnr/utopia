import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/controlller/new_article_screen_controller.dart';
import 'package:utopia/utils/image_picker.dart';

import '../../../utils/article_body_component.dart';

class NewArticleScreen extends StatefulWidget {
  NewArticleScreen({Key? key}) : super(key: key);

  @override
  State<NewArticleScreen> createState() => _NewArticleScreenState();
}

class _NewArticleScreenState extends State<NewArticleScreen> {
  final Logger _logger = Logger("NewArticleScreen");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Consumer<NewArticleScreenController>(
          builder: (context, controller, child) {
            return FloatingActionButton(
              onPressed: () async {
                XFile? imageFile = await pickImage(context);
                if (imageFile != null) {
                  controller.addImageField(imageFile);
                }
              },
              backgroundColor: authBackground,
              child: const Icon(
                Icons.add_a_photo_outlined,
                color: Colors.white,
              ),
            );
          },
        ),
        backgroundColor: primaryBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black54),
          backgroundColor: primaryBackgroundColor,
          actions: [
            Consumer<NewArticleScreenController>(
              builder: (context, controller, child) {
                return TextButton(
                    onPressed: () {
                      _logger.info("Publish Article");
                      controller.publishArticle();
                    },
                    child: const Text(
                      'Publish',
                      style: TextStyle(
                          color: Color(0xfb40B5AD),
                          fontSize: 15,
                          letterSpacing: 0.5),
                    ));
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16, top: 12),
          child: Consumer<NewArticleScreenController>(
            builder: (context, controller, child) {
              if (controller.bodyComponents.isEmpty) {
                Future.delayed(const Duration(microseconds: 1))
                    .then((value) => controller.addTextField());
              }
              List<BodyComponent> bodyComponents = controller.bodyComponents;
              return ListView.builder(
                itemCount: bodyComponents.length,
                itemBuilder: (context, index) {
                  switch (bodyComponents[index].type) {
                    case "text":
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: bodyComponents[index].textFormField!,
                      );
                    case "image":
                      return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              bodyComponents[index].imageProvider!,
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: authBackground,
                                  child: IconButton(
                                      iconSize: 18,
                                      color: authMaterialButtonColor,
                                      onPressed: () {
                                        controller.removeImage(controller
                                            .bodyComponents
                                            .sublist(index - 1, index + 2));
                                      },
                                      icon: const Icon(
                                        Icons.close,
                                      )),
                                ),
                              )
                            ],
                          ));

                    default:
                      return Text("data");
                  }
                },
              );
            },
          ),
        ));
  }
}
