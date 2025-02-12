import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/controller/my_articles_controller.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/common_ui/article_box.dart';

class MyArticleScreen extends StatefulWidget {
  @override
  State<MyArticleScreen> createState() => _MyArticleScreenState();
}

class _MyArticleScreenState extends State<MyArticleScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final String myUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                backgroundColor: authBackground,
                title: const Text(
                  'My Articles',
                  style: TextStyle(fontSize: 15.5),
                ),
                floating: true,
                pinned: true,
                snap: false,
                elevation: 0,
                forceElevated: innerBoxIsScrolled,
                bottom: TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.white,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicator: const UnderlineTabIndicator(
                      insets: EdgeInsets.only(bottom: 8),
                    ),
                    tabs: const [
                      Tab(text: 'Published'),
                      Tab(text: 'Drafts'),
                    ]),
              ),
            ),
          ];
        },
        body: TabBarView(controller: _tabController, children: [
          Consumer<MyArticlesController>(
            builder: (context, controller, child) {
              if (controller.fetchingMyArticleStatus == FetchingMyArticle.nil) {
                controller.fetchMyArticles(myUserId);
              }

              switch (controller.fetchingMyArticleStatus) {
                case FetchingMyArticle.nil:
                  return const Center(child: Text('Swipe to refresh'));
                case FetchingMyArticle.fetching:
                  return const Center(
                    child: CircularProgressIndicator(
                      color: authMaterialButtonColor,
                    ),
                  );
                case FetchingMyArticle.fetched:
                  return Padding(
                    padding:
                        EdgeInsets.only(top: displayHeight(context) * 0.07),
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return ArticleBox(
                            article: controller.publishedArticles[index]);
                      },
                      itemCount: controller.publishedArticles.length,
                    ),
                  );
              }
            },
          ),
          const Center(
            child: Text('Draft articles'),
          ),
        ]),
      ),
    ));
  }
}
