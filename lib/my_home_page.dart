import 'package:flutter/material.dart';
import 'package:state_package/state_management.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final SimpleStateManager<int> _counterManager =
      SimpleStateManager<int>(const StateModel(value: 0));
  final ListStateManager<String> _listManager = ListStateManager<String>(
      const StateModel(value: ['Item 1', 'Item 2', 'Item 3']));
  final MapStateManager<String, String> _mapManager =
      MapStateManager<String, String>(
          const StateModel(value: {'key1': 'Value 1', 'key2': 'Value 2'}));
  Future<List<String>> _fetchDataFromApi() async {
    await Future.delayed(const Duration(seconds: 2));
    return ['New Item 1', 'New Item 2'];
  }

  @override
  void dispose() {
    _counterManager.dispose();
    _listManager.dispose();
    _mapManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Advanced State Manager')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _buildCounterWidget(),
          const Divider(),
          _buildListWidget(),
          const Divider(),
          _buildMapWidget(),
          const Divider(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _counterManager.update((_counterManager.value.value) + 1);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCounterWidget() {
    return BaseValueListenableBuilder<StateModel>(
      valueListenable: _counterManager,
      builder: (context, value) {
        return Text(
          'Counter: ${value.value}',
        );
      },
      // buildWhen: (previousValue, newValue) {
      //   return newValue.value % 2 == 0;
      // },
    );
  }

  Widget _buildListWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('List:', style: TextStyle(fontWeight: FontWeight.bold)),
        BaseValueListenableBuilder<StateModel>(
          valueListenable: _listManager,
          log: 'list',
          buildWhen: (previousValue, newValue) {
            return previousValue.value != newValue.value;
          },
          builder: (context, value) => value.isLoading == true
              ? const CircularProgressIndicator()
              : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: value.value.length,
                  itemBuilder: (context, index) => RepaintBoundary(
                    child: Row(
                      children: [
                        Text(value.value[index]),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _listManager.removeItem(value.value[index]);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
        ),
        ElevatedButton(
          onPressed: () {
            _listManager.addItem('New Item');
          },
          child: const Text('Add Item'),
        ),
        ElevatedButton(
          onPressed: () {
            _listManager.clearList();
          },
          child: const Text('Clear List'),
        ),
        ElevatedButton(
          onPressed: () {
            _listManager.updateAsync(_fetchDataFromApi());
          },
          child: const Text('Fetch Data From API'),
        ),
      ],
    );
  }

  Widget _buildMapWidget() {
    return AnimatedBuilder(
      animation: _mapManager,
      builder: (context, _) {
        final map = _mapManager.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Map:', style: TextStyle(fontWeight: FontWeight.bold)),
            BaseValueListenableBuilder<StateModel>(
              valueListenable: _mapManager,
              log: 'list',
              builder: (context, state) {
                if (state.isLoading == true) {
                  return const Center(child: CircularProgressIndicator());
                }

                final entries = state.value.entries.toList();
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: entries.length,
                  itemBuilder: (context, index) => RepaintBoundary(
                    child: Row(
                      children: [
                        Text('${entries[index].key}: ${entries[index].value}'),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _mapManager.removeListItem([entries[index].key]);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                _mapManager.addItem('key ${map.value.length + 1}',
                    'Value ${map.value.length + 1}');
              },
              child: const Text('Add Item'),
            ),
            ElevatedButton(
              onPressed: _mapManager.clearMap,
              child: const Text('Clear Map'),
            ),
          ],
        );
      },
    );
  }
}
