import 'package:ai_todo/di/di.dart';
import 'package:ai_todo/domain/model/collection.dart';
import 'package:ai_todo/domain/service/collection_service.dart';
import 'package:ai_todo/ui/widget/input_collection_view.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    _loadCollections();
    super.initState();
  }

  void _loadCollections() async {
    _collections = await getIt.get<CollectionService>().getAllCollections();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DrawerHeader(
          decoration: const BoxDecoration(
            color: Colors.blue,
          ),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundImage:
                NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  'nickname',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(
                  Icons.notifications,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                onPressed: () {},
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
    _loadCollections();
  }
}
