import 'package:ai_todo/di/di.dart';
import 'package:ai_todo/domain/model/collection.dart';
import 'package:ai_todo/domain/service/collection_service.dart';
import 'package:ai_todo/ui/desktop_collection_detail_page.dart';
import 'package:ai_todo/ui/report_list_page.dart';
import 'package:ai_todo/ui/setting_page.dart';
import 'package:ai_todo/ui/widget/input_collection_view.dart';
import 'package:ai_todo/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermojiCircleAvatar.dart';

class DesktopHomePage extends StatefulWidget {
  static const routeName = '/desktop_home_page';

  const DesktopHomePage({super.key});

  @override
  State<DesktopHomePage> createState() => _DesktopHomePageState();
}

class _DesktopHomePageState extends State<DesktopHomePage> {
  final PageController _pageController = PageController(initialPage: 0);
  Collection? _selectedCollection;

  @override
  void initState() {
    _initWithInboxCollection();
    super.initState();
  }

  _initWithInboxCollection() async {
    _selectedCollection = await getIt.get<CollectionService>().getInboxCollection();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          _buildMenuSide(),
          const VerticalDivider(
            width: 1,
          ),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return PageView(
      controller: _pageController,
      children: [
        _buildCollection(),
        _buildReport(),
        _buildSetting(),
      ],
    );
  }

  Widget _buildMenuSide() {
    return Container(
      width: 70,
      color: menuBarColor,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 60,
          ),
          FluttermojiCircleAvatar(
            radius: 24,
          ),
          const SizedBox(
            height: 20,
          ),
          IconButton(
            onPressed: () {
              _pageController.jumpToPage(0);
            },
            icon: const Icon(Icons.home),
          ),
          const SizedBox(
            height: 20,
          ),
          IconButton(
            onPressed: () {
              _pageController.jumpToPage(1);
            },
            icon: const Icon(Icons.summarize_outlined),
          ),
          const SizedBox(
            height: 20,
          ),
          IconButton(
            onPressed: () {
              _pageController.jumpToPage(2);
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
    );
  }

  Widget _buildCollection() {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: FutureBuilder(
            future: getIt.get<CollectionService>().getAllCollections(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView.builder(
                  itemCount: snapshot.data!.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      // add collection button
                      return Container(
                        padding: const EdgeInsets.all(8),
                        height: AppBar().preferredSize.height,
                        child: InkWell(
                          onTap: () {
                            _showAddCollectionInputSheet();
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add),
                              Text('添加清单'),
                            ],
                          ),
                        ),
                      );
                    } else {
                      // highlight selected collection
                      var collection = snapshot.data![index - 1];
                      var selected = false;
                      if (null != _selectedCollection) {
                        selected = _selectedCollection!.id == collection.id;
                      }
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedCollection = collection;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          color: selected ? Colors.grey[200] : null,
                          child: Text(collection.name),
                        ),
                      );
                    }
                  },
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
        const VerticalDivider(
          width: 1,
        ),
        if (null != _selectedCollection)
          Expanded(
            child: DesktopCollectionDetailPage(
              collection: _selectedCollection!,
            ),
          ),
      ],
    );
  }

  Widget _buildReport() {
    return const ReportListPage();
  }

  Widget _buildSetting() {
    return const SettingPage();
  }

  void _showAddCollectionInputSheet() async {
    // set bottom sheet border corner
    const RoundedRectangleBorder roundedRectangleBorder = RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(6),
      ),
    );
    var name = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: roundedRectangleBorder,
      builder: (context) {
        return const InputCollectionView();
      },
    );
    if (null != name) {
      await getIt.get<CollectionService>().createCollection(name);
    }
    setState(() {});
  }
}
