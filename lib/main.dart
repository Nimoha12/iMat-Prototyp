import 'package:flutter/material.dart';
import 'package:imat_repo/model/AuthState.dart';
import 'package:imat_repo/model/imat_data_handler.dart';
import 'package:provider/provider.dart'; // Provider
import 'package:imat_repo/Theme/imat_colors.dart';
import 'Pages/home_page.dart';
import 'Pages/checkout_page.dart';
import 'Widgets/home/login_overlay_scope.dart';
import 'Widgets/home/login_page.dart';

void main() {
  // Wrap the app in providers so the whole app can access AuthState and ImatDataHandler.
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ImatDataHandler()),
        ChangeNotifierProvider(create: (_) => AuthState()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  OverlayEntry? _loginOverlayEntry;
  VoidCallback? onLoginSuccessAction;

  void _removeLoginOverlayEntry() {
    _loginOverlayEntry?.remove();
    _loginOverlayEntry = null;
  }

  void showLoginOverlay({VoidCallback? onLoginSuccess}) {
    onLoginSuccessAction = onLoginSuccess;
    _removeLoginOverlayEntry();

    void insertLoginOverlay() {
      if (!mounted) {
        return;
      }
      final overlay = _navigatorKey.currentState?.overlay;
      if (overlay == null) {
        return;
      }

      _loginOverlayEntry = OverlayEntry(
        builder: (context) => LoginOverlay(
          onClose: hideLoginOverlay,
          onLoginSuccess: markLoggedIn,
        ),
      );
      overlay.insert(_loginOverlayEntry!);
    }

    final overlay = _navigatorKey.currentState?.overlay;
    if (overlay != null) {
      insertLoginOverlay();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => insertLoginOverlay());
    }
  }

  void hideLoginOverlay() {
    _removeLoginOverlayEntry();
    onLoginSuccessAction = null;
  }

  void markLoggedIn() {
    final afterLogin = onLoginSuccessAction;

    hideLoginOverlay();

    context.read<AuthState>().login();

    afterLogin?.call();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthState>();

    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'iMat',
      theme: ThemeData(
        useMaterial3: false,
        scaffoldBackgroundColor: IMatColors.beige,
        fontFamily: 'Inter',
      ),
      home: const HomePage(),
      routes: {
        '/checkout': (_) => const CheckoutPage(),
      },
      builder: (context, child) {
        return LoginOverlayScope(
          isLoggedIn: authState.isLoggedIn,
          showLoginOverlay: showLoginOverlay,
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: .center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
