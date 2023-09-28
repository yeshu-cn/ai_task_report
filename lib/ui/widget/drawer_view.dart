import 'package:ai_todo/di/di.dart';
import 'package:ai_todo/domain/model/collection.dart';
import 'package:ai_todo/domain/service/collection_service.dart';
import 'package:ai_todo/ui/widget/input_collection_view.dart';
import 'package:ai_todo/utils/sp_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttermoji/fluttermojiCircleAvatar.dart';

// callback
typedef OnCollectionSelected = void Function(Collection collection);

class DrawerView extends StatefulWidget {
  final OnCollectionSelected? onCollectionSelected;

  const DrawerView({super.key, this.onCollectionSelected});

  @override
  State<DrawerView> createState() => _DrawerViewState();
}

class _DrawerViewState extends State<DrawerView> {
  List<Collection> _collections = [];
  String? _avatar;
  String? _nickname;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  void _loadData() async {
    _nickname = await SpUtils.getNickname();
    _avatar = await SpUtils.getAvatar();
    _collections = await getIt.get<CollectionService>().getAllCollections();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DrawerHeader(
          child: Row(
            children: [
              // if (null != _avatar)
              //   CircleAvatar(
              //     child: SvgPicture.asset(_avatar!),
              //   ),
              FluttermojiCircleAvatar(
                radius: 50,
              ),
              if (null != _nickname)
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    _nickname!,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _collections.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_collections[index].name),
                onTap: () {
                  widget.onCollectionSelected?.call(_collections[index]);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              _showAddCollectionInputSheet();
            },
            child: const Row(
              children: [
                // add icon
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.add),
                ),
                // add text
                Text('添加清单'),
              ],
            ),
          ),
        ),
      ],
    );
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
    _loadData();
  }
}
