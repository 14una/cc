import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cc/models/item.dart';
import 'package:cc/providers/item_list_provider.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CASECounter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _controller = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text("Todo List"),
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: 'Todo...'),
            onSubmitted: (value) {
              context.read(itemListProvider.notifier).addItem(
                    Item(name: value),
                  );

              _controller.clear();
            },
          ),
          Expanded(
            child: Consumer(
              builder: (context, watch, child) {
                final itemList = watch(itemListProvider);

                return ListView.builder(
                  itemCount: itemList.length,
                  itemBuilder: (context, index) {
                    final Item item = itemList[index];

                    return CheckboxListTile(
                      value: item.isDone,
                      onChanged: (value) {
                        context
                            .read(itemListProvider.notifier)
                            .updateItem(item..isDone = value ?? false);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
