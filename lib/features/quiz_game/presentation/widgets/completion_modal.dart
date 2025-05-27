import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:love_quest/core/config/theme.dart';
import 'package:love_quest/features/quiz_game/domain/entities/quiz.dart';
import 'package:love_quest/features/quiz_game/presentation/lightning_quiz.controller.dart';
//
// class CompletionModal extends StatelessWidget {
//   final List<QuizEntity> questions;
//   final List<String> answers;
//   final VoidCallback onProceed;
//
//   const CompletionModal({
//     Key? key,
//     required this.questions,
//     required this.answers,
//     required this.onProceed,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Container(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Icon(
//               Icons.celebration,
//               color: AppColors.primary,
//               size: 64,
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'Congratulations!',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.primary,
//               ),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'You\'ve completed the quiz!',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 24),
//             Container(
//               constraints: BoxConstraints(
//                 maxHeight: MediaQuery.of(context).size.height * 0.4,
//               ),
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: List.generate(
//                     questions.length,
//                     (index) => Padding(
//                       padding: const EdgeInsets.only(bottom: 16),
//                       child: Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: Colors.grey[100],
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Q${index + 1}: ${questions[index].question}',
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.black87,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               'Your answer: ${answers[index]}',
//                               style: TextStyle(
//                                 color: AppColors.primary,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: onProceed,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primary,
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: const Text(
//                 'Proceed to Next Game',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
class CompletionModal extends StatelessWidget {
  final List<QuizEntity> questions;
  final List<String> answers;
  final Map<String, String> opponentAnswers;
  final VoidCallback onProceed;

  CompletionModal({
    super.key,
    required this.questions,
    required this.answers,
    required this.opponentAnswers,
    required this.onProceed,
  });

  final LightningQuizController controller = Get.find<
      LightningQuizController>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Quiz Completed!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                itemCount: 4,
                itemBuilder: (context, index) {
                  final quiz = questions[index];
                  final gameId = controller.quizList.length > index
                      ? controller.quizList[index].id ?? 'q$index'
                      : 'q$index';
          
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Q${index + 1}: ${quiz.question}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text("You: ${answers[index]}"),
                      Text("Opponent: ${opponentAnswers[gameId] ?? 'No answer'}"),
                      const SizedBox(height: 16),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onProceed,
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}