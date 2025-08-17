// // lib/screens/grammar_detail_screen.dart

// import 'package:flutter/material.dart';
// import '../models/grammar_topic.dart';
// import '../models/grammar_rule.dart';
// import 'grammar_rule_screen.dart';

// class GrammarDetailScreen extends StatelessWidget {
//   final GrammarTopic topic;
//   const GrammarDetailScreen({super.key, required this.topic});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(topic.theme)),
//       body: topic.rules.isEmpty
//           ? const Center(child: Text('Нет правил в этой теме'))
//           : ListView.separated(
//               itemCount: topic.rules.length,
//               separatorBuilder: (_, __) => const Divider(height: 1),
//               itemBuilder: (context, index) {
//                 final GrammarRule rule = topic.rules[index];
//                 return ListTile(
//                   title: Text(rule.title),
//                   subtitle: Text(rule.category),
//                   trailing: const Icon(Icons.arrow_forward_ios, size: 160),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (_) => GrammarRuleScreen(rule: rule)),
//                     );
//                   },
//                 );
//               },
//             ),
//     );
//   }
// }
