import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../Controller/HomeControllet.dart';
import '../models/booksModel.dart';

class HomePage extends StatefulWidget {
  // final HomeController _homeController = HomeController();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _refreshList() {
    setState(() {});
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  HomeController _homeController = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(children: [
          _Form(),
          Expanded(
              child: GetBuilder<HomeController>(
                  builder: (value) => _homeController.list == null
                      ? const SizedBox()
                      : ListView.builder(
                          itemCount: _homeController.list.length,
                          itemBuilder: (_, index) {
                            return dataList(
                                book: _homeController.list, index: index);
                          })))
        ]));
  }

  Widget _Form() {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _homeController.titleFieldController.value,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter book title';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _homeController.yearFieldController.value,
              decoration: const InputDecoration(
                labelText: 'Year',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d]')),
              ],
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter released year';
                }
                return null;
              },
            ),
            Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: ElevatedButton(
                  onPressed: () async {
                    _homeController.getAllBooks();
                    if (_formKey.currentState!.validate()) {
                      _homeController.updateFunEnable.value
                          ? _homeController.save()
                          : await _homeController.addBook(Book(
                              id: 0,
                              bookTitle: _homeController
                                  .titleFieldController.value.text,
                              bookYear: _homeController
                                  .yearFieldController.value.text));
                      _homeController.yearFieldController.value.clear();
                      _homeController.titleFieldController.value.clear();
                      // widget._refreshList();
                    }
                  },
                  child: const Text('Add book'),
                )),
          ],
        ));
  }

  Widget dataList({var book, required int index}) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      color: Colors.grey.withOpacity(0.1),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Text(book[index]["bookTitle"]),
          const Spacer(),
          IconButton(
            onPressed: () {
              _homeController.updateBook(
                  title: book[index]["bookTitle"],
                  year: book[index]["bookYear"],
                  ids: book[index]["id"]);
              _homeController.getAllBooks();
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
              _homeController.removeBook(book[index]["id"]);
              book[index]["id"];
              book[index]["bookYear"];
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}

// class _Form extends StatefulWidget {
//   final HomeController _homeController;
//   final VoidCallback _refreshList;
//
//   _Form(this._homeController, this._refreshList);
//
//   @override
//   _FormState createState() => _FormState();
// }
//
// class _FormState extends State<_Form> {
//
//
//
//   @override
//   void dispose() {
//     _titleFieldController.dispose();
//     _yearFieldController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: Container(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             TextFormField(
//               controller: _titleFieldController,
//               decoration: const InputDecoration(
//                 labelText: 'Title',
//               ),
//               validator: (String? value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter book title';
//                 }
//                 return null;
//               },
//             ),
//             TextFormField(
//               controller: _yearFieldController,
//               decoration: const InputDecoration(
//                 labelText: 'Year',
//               ),
//               keyboardType: TextInputType.number,
//               inputFormatters: [
//                 FilteringTextInputFormatter.allow(RegExp(r'[\d]')),
//               ],
//               validator: (String? value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter released year';
//                 }
//                 return null;
//               },
//             ),
//             Container(
//                 margin: const EdgeInsets.only(top: 10.0),
//                 child: ElevatedButton(
//                   onPressed: () async {
//                     if (_formKey.currentState!.validate()) {
//                       await widget._homeController.addBook(Book(
//                           id: 0,
//                           bookTitle: _titleFieldController.text,
//                           bookYear: _yearFieldController.text
//                           // 0,
//                           // _titleFieldController.text, _yearFieldController.text
//                           // int.parse(_yearFieldController.text)
//                           ));
//                       _titleFieldController.clear();
//                       _yearFieldController.clear();
//                       widget._refreshList();
//                     }
//                   },
//                   child: const Text('Add book'),
//                 )),
//           ],
//         ),
//       ),
//     );
//   }
// }

class _BookTable extends StatelessWidget {
  final HomeController _homeController;
  final VoidCallback _refreshList;

  _BookTable(this._homeController, this._refreshList);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Book>>(
        future: _homeController.getAllBooks(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: Text('Loading..'));
          } else {
            return DataTable(
                columns: _createBookTableColumns(),
                rows: _createBookTableRows(snapshot.data ?? []));
          }
        });
  }

  List<DataColumn> _createBookTableColumns() {
    return [
      const DataColumn(label: Text('ID')),
      const DataColumn(label: Text('Book')),
      const DataColumn(label: Text('Action')),
    ];
  }

  List<DataRow> _createBookTableRows(List<Book> books) {
    return books
        .map((book) => DataRow(cells: [
              DataCell(Text('#${book.id}')),
              DataCell(Text('${book.bookTitle} (${book.bookYear.toString()})')),
              DataCell(IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  // await _homeController.removeBook(book.id);
                  _refreshList();
                },
              )),
            ]))
        .toList();
  }
}
