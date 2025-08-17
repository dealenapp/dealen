import 'package:flutter/material.dart';
import '../services/eng_words_service.dart';
import 'theme_words_screen.dart';

class ThemeListScreen extends StatefulWidget {
  @override
  _ThemeListScreenState createState() => _ThemeListScreenState();
}

class _ThemeListScreenState extends State<ThemeListScreen> {
  List<Map<String, dynamic>> themes = [];

  @override
  void initState() {
    super.initState();
    loadThemes();
  }

  Future<void> loadThemes() async {
    final data = await EngWordsService.loadThemes(); // грузим engwords.json
    setState(() {
      themes = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Themes')),
      body: themes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: themes.length,
              itemBuilder: (context, index) {
                final theme = themes[index];
                final iconData = _getIconData(theme['icon']);

                // Цвета в зависимости от темы
                final cardColor = isDark ? Colors.grey[800] : Colors.blue.shade50;
                final iconColor = isDark ? Colors.lightBlueAccent : Colors.blue;
                final textColor = isDark ? Colors.white : Colors.black87;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ThemeWordsScreen(
                          themeTitle: theme['theme'],
                          words: theme['words'],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    color: cardColor,
                    elevation: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(iconData, size: 40, color: iconColor),
                        const SizedBox(height: 8),
                        Text(
                          theme['theme'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  IconData _getIconData(String iconName) {
    const iconMap = {
      'Icons.book': Icons.book,
      'Icons.shuffle': Icons.shuffle,
      'Icons.link': Icons.link,
      'Icons.chat': Icons.chat,
      'Icons.search': Icons.search,
      'Icons.account_tree': Icons.account_tree,
      'Icons.accessibility': Icons.accessibility,
      'Icons.gesture': Icons.gesture,
      'Icons.directions_run': Icons.directions_run,
      'Icons.volume_up': Icons.volume_up,
      'Icons.visibility': Icons.visibility,
      'Icons.touch_app': Icons.touch_app,
      'Icons.healing': Icons.healing,
      'Icons.person': Icons.person,
      'Icons.mood': Icons.mood,
      'Icons.favorite': Icons.favorite,
      'Icons.star': Icons.star,
      'Icons.volunteer_activism': Icons.volunteer_activism,
      'Icons.handshake': Icons.handshake,
      'Icons.restaurant': Icons.restaurant,
      'Icons.beach_access': Icons.beach_access,
      'Icons.theater_comedy': Icons.theater_comedy,
      'Icons.sports': Icons.sports,
      'Icons.park': Icons.park,
      'Icons.shopping_bag': Icons.shopping_bag,
      'Icons.group': Icons.group,
      'Icons.change_circle': Icons.change_circle,
      'Icons.eco': Icons.eco,
      'Icons.pets': Icons.pets,
      'Icons.medical_services': Icons.medical_services,
      'Icons.devices': Icons.devices,
      'Icons.flight': Icons.flight,
      'Icons.local_hospital': Icons.local_hospital,
      'Icons.account_balance': Icons.account_balance,
      'Icons.gavel': Icons.gavel,
      'Icons.lock': Icons.lock,
      'Icons.military_tech': Icons.military_tech,
      'Icons.newspaper': Icons.newspaper,
      'Icons.mic': Icons.mic,
      'Icons.people': Icons.people,
      'Icons.verified': Icons.verified,
      'Icons.flag': Icons.flag,
      'Icons.warning': Icons.warning,
      'Icons.work': Icons.work,
      'Icons.laptop': Icons.laptop,
      'Icons.business': Icons.business,
      'Icons.trending_up': Icons.trending_up,
      'Icons.account_balance_wallet': Icons.account_balance_wallet,
      'Icons.schedule': Icons.schedule,
      'Icons.block': Icons.block,
      'Icons.report_problem': Icons.report_problem,
      'Icons.arrow_forward': Icons.arrow_forward,
      'Icons.fact_check': Icons.fact_check,
      'Icons.lightbulb': Icons.lightbulb,
      'Icons.history': Icons.history,
      'Icons.emoji_events': Icons.emoji_events,
      'Icons.hourglass_empty': Icons.hourglass_empty,
      'Icons.forum': Icons.forum,
      'Icons.comment': Icons.comment,
      'Icons.connect_without_contact': Icons.connect_without_contact,
      'Icons.compare_arrows': Icons.compare_arrows,
      'Icons.move_up': Icons.move_up,
      'Icons.format_list_bulleted': Icons.format_list_bulleted,
      'Icons.blur_on': Icons.blur_on,
      'Icons.article': Icons.article,
      'Icons.mail': Icons.mail,
      'Icons.school': Icons.school,
      'Icons.menu_book': Icons.menu_book,
      'Icons.science': Icons.science,
      'Icons.engineering': Icons.engineering,
      'Icons.short_text': Icons.short_text,
      'Icons.text_fields': Icons.text_fields,
      'Icons.text_format': Icons.text_format,
      'Icons.navigation': Icons.navigation,
      'Icons.place': Icons.place,
      'Icons.palette': Icons.palette,
      'Icons.speed': Icons.speed,
    };

    return iconMap[iconName] ?? Icons.category;
  }
}
