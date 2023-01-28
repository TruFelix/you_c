import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';

import 'package:collection/collection.dart';
import 'package:you_c/utils.dart';

import 'atoms/contract_card.dart';
import 'models/contract.dart';

final db = Localstore.instance;
final contractsCollection = db.collection('contracts');

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouC',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF9600),
        ),
      ),
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ),
      home: const Wrapper(child: MyHomePage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Contract> contracts = [];

  bool createContract = false;
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  loadContracts() async {
    final value = await getContracts();
    setState(() => contracts = value);
  }

  @override
  void initState() {
    super.initState();

    loadContracts();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          children: contracts
              .map((c) => ContractCard(
                    contract: c,
                    onDelete: (Contract c) async {
                      await contractsCollection.doc(c.id).delete();
                      loadContracts();
                    },
                    onFail: (Contract c) {
                      showDialog(
                        context: context,
                        builder: (context) => Center(
                          child: Column(mainAxisSize: MainAxisSize.min, children: [
                            Dialog(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                                child: Column(
                                  children: [
                                    const Text("Are you sure, this means that all recorded Contracts will be ripped!"),
                                    Row(
                                      children: [
                                        TextButton(
                                          onPressed: () async {
                                            await contractsCollection.delete();
                                            loadContracts();
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            "Yes, I failed",
                                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                                  color: Colors.red,
                                                ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("Cancel"),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ]),
                        ),
                      );
                    },
                    onFulfill: (Contract c) async {
                      await contractsCollection.doc(c.id).set({'fulfilled': true}, SetOptions(merge: true));
                      loadContracts();
                    },
                  ))
              .toList(growable: false),
        ),
        if (createContract) contractForm,
        Positioned(
          bottom: 15,
          right: 15,
          child: FloatingActionButton(
            heroTag: "fab",
            onPressed: () async {
              final oldCreateContract = createContract;
              setState(() => createContract = !createContract);

              if (oldCreateContract) {
                await contractsCollection.doc().set(
                      Contract(title: titleController.text, content: contentController.text).forStorage,
                    );
                loadContracts();
              }
            },
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  Widget get contractForm {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        height: 400,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                blurRadius: 10,
                color: Color(0x6F555555),
              ),
            ]),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: ListView(
            padding: const EdgeInsets.only(bottom: 30, top: 15, left: 4, right: 4),
            children: [
              TextField(controller: titleController, decoration: const InputDecoration(label: Text("Title"))),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(label: Text("Content")),
                maxLines: null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Wrapper extends StatelessWidget {
  final Widget child;

  const Wrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
    );
  }
}

Future<List<Contract>> getContracts() async {
  final docsData = await contractsCollection.get();

  return docsData?.entries
          .map((entry) {
            try {
              return Contract.fromStorage(entry.key.replaceFirst(contractsCollection.path, ""), entry.value);
            } on TypeError {
              return null;
            }
          })
          .whereNotNull()
          .toList() ??
      [];
}
