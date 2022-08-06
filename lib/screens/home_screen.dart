import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gerente_loja/blocs/orders_bloc.dart';
import 'package:gerente_loja/blocs/users_bloc.dart';
import 'package:gerente_loja/tabs/orders_tab.dart';
import 'package:gerente_loja/tabs/products_tab.dart';
import 'package:gerente_loja/tabs/users_tab.dart';
import 'package:gerente_loja/widgets/edit_category_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController? _pageController;
  int _page = 0;

  late UserBloc _userBloc;
  late OrdersBloc _ordersBloc;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    _userBloc = UserBloc();
    _ordersBloc = OrdersBloc();
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.pinkAccent,
          primaryColor: Colors.white,

          /*  textTheme: Theme.of(context).textTheme.copyWith(
                caption: TextStyle(color: Colors.yellow),
              ), */
        ),
        child: BottomNavigationBar(
          currentIndex: _page,
          fixedColor: Colors.white,
          unselectedItemColor: Colors.white54,
          onTap: (p) {
            _pageController!.animateToPage(p,
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Clientes",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: "Pedidos",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: "Produtos",
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: BlocProvider(
          blocs: [
            Bloc((i) => _userBloc, singleton: true),
            Bloc((i) => _ordersBloc),
          ],
          tagText: 'global',
          dependencies: const [],
          child: PageView(
            controller: _pageController,
            onPageChanged: (p) {
              setState(() {
                _page = p;
              });
            },
            children: const [
              UsersTab(),
              OrdersTab(),
              ProductsTab(),
            ],
          ),
        ),
      ),
      floatingActionButton: _page == 0 ? null : _buildFloating(),
    );
  }

  Widget _buildFloating() {
    if (_page == 1) {
      return SpeedDial(
        child: const Icon(Icons.sort),
        backgroundColor: Colors.pinkAccent,
        overlayOpacity: 0.4,
        overlayColor: Colors.black,
        children: [
          SpeedDialChild(
            child: const Icon(
              Icons.arrow_downward,
              color: Colors.pinkAccent,
            ),
            backgroundColor: Colors.white,
            label: "Concluídos Abaixo",
            labelStyle: const TextStyle(fontSize: 14),
            onTap: () {
              _ordersBloc.setOrderCriteria(SortCriteria.READY_LAST);
            },
          ),
          SpeedDialChild(
            child: const Icon(
              Icons.arrow_upward,
              color: Colors.pinkAccent,
            ),
            backgroundColor: Colors.white,
            label: "Concluídos Acima",
            labelStyle: const TextStyle(fontSize: 14),
            onTap: () {
              _ordersBloc.setOrderCriteria(SortCriteria.READY_FIRST);
            },
          ),
        ],
      );
    } else if (_page == 2) {
      return FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.pinkAccent,
        onPressed: (){
          showDialog(
                context: context,
                builder: (context) => EditCategoryDialog(),
              );
        },
      );
    }
    return Container();
  }
}
