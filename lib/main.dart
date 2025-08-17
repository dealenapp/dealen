import 'package:flutter/material.dart';
import 'package:dealen/screens/dictionary_en_screen.dart';
import 'package:dealen/screens/favorites_de_screen.dart';
import 'package:dealen/screens/favorites_en_screen.dart';
import 'package:dealen/screens/game_articles_screen.dart';
import 'package:dealen/screens/game_en_translation.dart';
import 'package:dealen/screens/game_translation_screen.dart';
import 'package:dealen/screens/grammar_de_screen.dart';
import 'package:dealen/screens/grammar_en_screen.dart';
import 'package:dealen/screens/main_screen.dart';
import 'package:dealen/screens/theme_list_screen.dart';
import 'screens/dictionary_de_screen.dart';
import '../widgets/markdown_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Языковое приложение',

      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        fontFamily: 'RobotoCondensed',
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        fontFamily: 'RobotoCondensed',
        scaffoldBackgroundColor: Colors.black,
      ),
      themeMode: _themeMode,

      builder: (context, child) => _MarkdownWrapper(child: child!),

      // Используем onGenerateRoute для глобального слайд-перехода
      onGenerateRoute: (settings) {
        Widget screen;
        switch (settings.name) {
          case '/dictionary_de':
            screen = DictionaryDeScreen();
            break;
          case '/grammar_de':
            screen = GrammarDeScreen();
            break;
          case '/game_articles':
            screen = const GameArticlesScreen();
            break;
          case '/game_translation':
            screen = const GameTranslationScreen();
            break;
          case '/favorites_de':
            screen = FavoritesDeScreen();
            break;
          case '/dictionary_en':
            screen = DictionaryEnScreen();
            break;
          case '/grammar_en':
            screen = GrammarEnScreen();
            break;
          case '/game_en_translation':
            screen = const GameEnTranslationScreen();
            break;
          case '/favorites_en':
            screen = FavoritesEnScreen();
            break;
          case '/theme_list':
            screen = ThemeListScreen();
            break;
          case '/':
          default:
            screen = MainScreen();
        }

        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => screen,
          transitionsBuilder: (_, animation, __, child) {
            const begin = Offset(1.0, 0.0); // слайд слева направо
            const end = Offset.zero;
            final tween = Tween(begin: begin, end: end)
                .chain(CurveTween(curve: Curves.easeInOutCubic));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 400),
        );
      },
    );
  }
}

/// Обёртка для Markdown
class _MarkdownWrapper extends StatelessWidget {
  final Widget child;
  const _MarkdownWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return _replaceTextWidgets(child);
  }

  Widget _replaceTextWidgets(Widget widget) {
    if (widget is Text) {
      return MarkdownText(widget.data ?? '');
    } else if (widget is MultiChildRenderObjectWidget) {
      return widget is Flex
          ? Flex(
              direction: widget.direction,
              children:
                  widget.children.map((e) => _replaceTextWidgets(e)).toList(),
            )
          : widget;
    } else if (widget is SingleChildRenderObjectWidget) {
      return widget.child != null
          ? _replaceTextWidgets(widget.child!)
          : widget;
    }
    return widget;
  }
}
