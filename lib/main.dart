import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Compras',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ShoppingList(),
    );
  }
}

class ShoppingList extends StatefulWidget {
  @override
  _ShoppingListState createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  List<String> items = [];
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadList();
  }

  // Função para carregar a lista de itens salvos
  Future<void> _loadList() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      items = prefs.getStringList('shopping_list') ?? [];
    });
  }

  // Função para adicionar um item à lista e salvar
  Future<void> addItem() async {
    if (controller.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Digite um item")));
      return;
    }

    if (items.contains(controller.text)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Item já existe na lista")));
      return;
    }

    setState(() {
      items.add(controller.text);
    });

    // Salva a lista de compras no SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('shopping_list', items);

    controller.clear();
  }

  // Função para excluir um item
  Future<void> removeItem(int index) async {
    setState(() {
      items.removeAt(index);
    });

    // Salva a lista após a remoção
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('shopping_list', items);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Compras"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: "Digite o item",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: addItem,
              child: const Text("Adicionar Item"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(items[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => removeItem(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
