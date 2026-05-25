// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:smart_ac/app_theme.dart';
// import 'package:smart_ac/features/dashboard/cubit/product_cubit.dart';
// import 'package:smart_ac/features/speech_screen/cubit/speech_cubit.dart';
// import 'package:speech_to_text/speech_to_text.dart';
// import 'package:translator/translator.dart';
//
// class SpeechScreen extends StatefulWidget {
//   const SpeechScreen({super.key});
//
//   @override
//   State<SpeechScreen> createState() => _SpeechScreenState();
// }
//
// class _SpeechScreenState extends State<SpeechScreen> {
//   final SpeechToText _speech = SpeechToText();
//   final GoogleTranslator _translator = GoogleTranslator();
//
//   bool _isListening = false;
//   String _transcribedText = '';
//   String? _translatedText;
//   String? _detectedLanguage;
//   bool _isTranslating = false;
//   String? _selectedLocale;
//
//   final List<LocaleName> _defaultLanguages = [
//     LocaleName('en_GB', '🇬🇧 English (UK)'),
//     LocaleName('en_US', '🇺🇸 English (US)'),
//     LocaleName('fr_FR', '🇫🇷 French'),
//     LocaleName('de_DE', '🇩🇪 German'),
//     LocaleName('es_ES', '🇪🇸 Spanish'),
//     LocaleName('ar_SA', '🇸🇦 Arabic'),
//     LocaleName('ur_PK', '🇵🇰 Urdu'),
//     LocaleName('zh_CN', '🇨🇳 Chinese'),
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _initSpeech();
//   }
//
//   Future<void> _initSpeech() async {
//     await _speech.initialize();
//   }
//
//   Future<void> _startListening() async {
//     setState(() {
//       _isListening = true;
//       _transcribedText = '';
//       _translatedText = null;
//       _detectedLanguage = null;
//     });
//     context.read<SpeechCubit>().reset();
//
//     await _speech.listen(
//       onResult: (result) {
//         setState(() => _transcribedText = result.recognizedWords);
//         if (result.finalResult) _stopListening();
//       },
//       listenFor: const Duration(seconds: 15),
//       pauseFor: const Duration(seconds: 5),
//       localeId: _selectedLocale ?? 'en_GB',
//     );
//   }
//
//   Future<void> _stopListening() async {
//     await _speech.stop();
//     setState(() => _isListening = false);
//
//     if (_transcribedText.isNotEmpty) {
//       String textToSend = _transcribedText;
//
//       if (_selectedLocale != null && !_selectedLocale!.startsWith('en')) {
//         setState(() => _isTranslating = true);
//         try {
//           final result = await _translator.translate(
//             _transcribedText,
//             to: 'en',
//           );
//           textToSend = result.text;
//           setState(() {
//             _translatedText = result.text;
//             _detectedLanguage = result.sourceLanguage.name;
//             _isTranslating = false;
//           });
//         } catch (e) {
//           setState(() => _isTranslating = false);
//           textToSend = _transcribedText;
//         }
//       }
//
//       context.read<SpeechCubit>().getRecommendation(text: textToSend);
//       context.read<ProductCubit>().load(conversation: textToSend);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocBuilder<SpeechCubit, SpeechState>(
//         builder: (context, state) {
//           return ListView(
//             padding: const EdgeInsets.all(24),
//             children: [
//               _buildHeader(),
//               const SizedBox(height: 16),
//               _buildLanguageSelector(),
//               const SizedBox(height: 20),
//
//               // ── Product Recommendations ───────────────────────
//               BlocBuilder<ProductCubit, ProductState>(
//                 builder: (context, productState) {
//                   if (productState is ProductLoading) {
//                     return const Padding(
//                       padding: EdgeInsets.only(bottom: 16),
//                       child: Row(
//                         children: [
//                           Icon(
//                             Icons.shopping_bag_outlined,
//                             color: AppTheme.accent,
//                             size: 16,
//                           ),
//                           SizedBox(width: 8),
//                           Text(
//                             'Finding product recommendations...',
//                             style: TextStyle(
//                               color: AppTheme.textSecond,
//                               fontSize: 13,
//                             ),
//                           ),
//                           SizedBox(width: 8),
//                           SizedBox(
//                             width: 12,
//                             height: 12,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               color: AppTheme.accent,
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   }
//
//                   if (productState is ProductLoaded &&
//                       productState.recommendation.products.isNotEmpty) {
//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             const Icon(
//                               Icons.shopping_bag_outlined,
//                               color: AppTheme.accent,
//                               size: 16,
//                             ),
//                             const SizedBox(width: 8),
//                             const Text(
//                               'Recommended Products',
//                               style: TextStyle(
//                                 color: AppTheme.textPrimary,
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 14,
//                               ),
//                             ),
//                             const Spacer(),
//                             Text(
//                               '${productState.recommendation.products.length} items',
//                               style: const TextStyle(
//                                 color: AppTheme.textSecond,
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 12),
//                         SizedBox(
//                           height: 160,
//                           child: ListView.separated(
//                             scrollDirection: Axis.horizontal,
//                             itemCount:
//                                 productState.recommendation.products.length,
//                             separatorBuilder: (_, __) =>
//                                 const SizedBox(width: 10),
//                             itemBuilder: (context, index) {
//                               final product =
//                                   productState.recommendation.products[index];
//                               return Container(
//                                 width: 120,
//                                 decoration: BoxDecoration(
//                                   color: AppTheme.surface,
//                                   borderRadius: BorderRadius.circular(12),
//                                   border: Border.all(color: AppTheme.border),
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     ClipRRect(
//                                       borderRadius: const BorderRadius.vertical(
//                                         top: Radius.circular(12),
//                                       ),
//                                       child: Image.network(
//                                         product.image,
//                                         height: 80,
//                                         width: double.infinity,
//                                         fit: BoxFit.cover,
//                                         errorBuilder: (_, __, ___) => Container(
//                                           height: 80,
//                                           color: AppTheme.surfaceLight,
//                                           child: const Icon(
//                                             Icons.image_not_supported,
//                                             color: AppTheme.textSecond,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.all(8),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             product.title,
//                                             style: const TextStyle(
//                                               color: AppTheme.textPrimary,
//                                               fontSize: 10,
//                                               fontWeight: FontWeight.w600,
//                                             ),
//                                             maxLines: 2,
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                           const SizedBox(height: 4),
//                                           Text(
//                                             '£${product.price.toStringAsFixed(0)}',
//                                             style: const TextStyle(
//                                               color: AppTheme.accent,
//                                               fontSize: 11,
//                                               fontWeight: FontWeight.w700,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         const Divider(color: AppTheme.border),
//                         const SizedBox(height: 8),
//                       ],
//                     );
//                   }
//
//                   return const SizedBox.shrink();
//                 },
//               ),
//
//               // ── Mic Button ───────────────────────────────────
//               _buildMicButton(),
//               const SizedBox(height: 24),
//
//               // ── Transcribed + Translated Text ─────────────────
//               if (_transcribedText.isNotEmpty) _buildTranscribedText(),
//               const SizedBox(height: 12),
//
//               // ── Translation Loading ───────────────────────────
//               if (_isTranslating)
//                 const Padding(
//                   padding: EdgeInsets.only(bottom: 12),
//                   child: Row(
//                     children: [
//                       SizedBox(
//                         width: 14,
//                         height: 14,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           color: AppTheme.accent,
//                         ),
//                       ),
//                       SizedBox(width: 8),
//                       Text(
//                         'Translating...',
//                         style: TextStyle(
//                           color: AppTheme.textSecond,
//                           fontSize: 13,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//               // ── Result ────────────────────────────────────────
//               switch (state) {
//                 SpeechInitial() => const SizedBox.shrink(),
//                 SpeechLoading() => const Center(
//                   child: CircularProgressIndicator(color: AppTheme.accent),
//                 ),
//                 SpeechLoaded() => _buildResult(state),
//                 SpeechError() => _buildError(state.message),
//               },
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildHeader() => Row(
//     children: [
//       Container(
//         padding: const EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           color: AppTheme.accentGlow,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: const Icon(Icons.mic, color: AppTheme.accent, size: 22),
//       ),
//       const SizedBox(width: 12),
//       const Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'SmartAC Assistant',
//             style: TextStyle(
//               color: AppTheme.textPrimary,
//               fontSize: 20,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           Text(
//             'Ask me about your accounts',
//             style: TextStyle(color: AppTheme.textSecond, fontSize: 13),
//           ),
//         ],
//       ),
//     ],
//   );
//
//   Widget _buildLanguageSelector() => Container(
//     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//     decoration: BoxDecoration(
//       color: AppTheme.surface,
//       borderRadius: BorderRadius.circular(12),
//       border: Border.all(color: AppTheme.border),
//     ),
//     child: Row(
//       children: [
//         const Icon(Icons.language, color: AppTheme.accent, size: 18),
//         const SizedBox(width: 10),
//         const Text(
//           'Language',
//           style: TextStyle(color: AppTheme.textSecond, fontSize: 13),
//         ),
//         const Spacer(),
//         DropdownButtonHideUnderline(
//           child: DropdownButton<String?>(
//             value: _selectedLocale,
//             dropdownColor: AppTheme.surface,
//             style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
//             icon: const Icon(Icons.expand_more, color: AppTheme.textSecond),
//             items: [
//               const DropdownMenuItem(
//                 value: null,
//                 child: Text('🌐 Auto Detect'),
//               ),
//               ..._defaultLanguages.map(
//                 (locale) => DropdownMenuItem(
//                   value: locale.localeId,
//                   child: Text(locale.name),
//                 ),
//               ),
//             ],
//             onChanged: (val) => setState(() => _selectedLocale = val),
//           ),
//         ),
//       ],
//     ),
//   );
//
//   Widget _buildMicButton() => Column(
//     children: [
//       Center(
//         child: GestureDetector(
//           onTap: _isListening ? _stopListening : _startListening,
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 300),
//             width: 100,
//             height: 100,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: _isListening
//                   ? AppTheme.danger.withAlpha(26)
//                   : AppTheme.accentGlow,
//               border: Border.all(
//                 color: _isListening ? AppTheme.danger : AppTheme.accent,
//                 width: 2,
//               ),
//             ),
//             child: Icon(
//               _isListening ? Icons.stop : Icons.mic,
//               size: 42,
//               color: _isListening ? AppTheme.danger : AppTheme.accent,
//             ),
//           ),
//         ),
//       ),
//       const SizedBox(height: 12),
//       Text(
//         _isListening
//             ? 'Listening... (auto stops after 5s pause)'
//             : 'Tap to speak - max 15 seconds',
//         style: const TextStyle(color: AppTheme.textSecond, fontSize: 12),
//         textAlign: TextAlign.center,
//       ),
//       const SizedBox(height: 16),
//       if (_isListening)
//         ElevatedButton.icon(
//           onPressed: _stopListening,
//           icon: const Icon(Icons.send, size: 16),
//           label: const Text('Ready - Send'),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: AppTheme.accent,
//             foregroundColor: Colors.white,
//           ),
//         ),
//     ],
//   );
//
//   Widget _buildTranscribedText() {
//     final isWide = MediaQuery.of(context).size.width > 700;
//     final hasTranslation = _translatedText != null;
//
//     if (isWide && hasTranslation) {
//       return Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: _buildTextCard(
//               label: 'You said (${_detectedLanguage ?? 'Unknown'}):',
//               text: '"$_transcribedText"',
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: _buildTextCard(
//               label: 'Translated to English:',
//               text: '"$_translatedText"',
//               isTranslated: true,
//             ),
//           ),
//         ],
//       );
//     }
//
//     return Column(
//       children: [
//         _buildTextCard(
//           label: hasTranslation
//               ? 'You said (${_detectedLanguage ?? 'Unknown'}):'
//               : 'You said:',
//           text: '"$_transcribedText"',
//         ),
//         if (hasTranslation) ...[
//           const SizedBox(height: 10),
//           _buildTextCard(
//             label: 'Translated to English:',
//             text: '"$_translatedText"',
//             isTranslated: true,
//           ),
//         ],
//       ],
//     );
//   }
//
//   Widget _buildTextCard({
//     required String label,
//     required String text,
//     bool isTranslated = false,
//   }) => Container(
//     padding: const EdgeInsets.all(16),
//     decoration: BoxDecoration(
//       color: AppTheme.surface,
//       borderRadius: BorderRadius.circular(12),
//       border: Border.all(
//         color: isTranslated
//             ? AppTheme.success.withAlpha(77)
//             : AppTheme.accent.withAlpha(51),
//       ),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Icon(
//               isTranslated ? Icons.translate : Icons.mic,
//               color: isTranslated ? AppTheme.success : AppTheme.accent,
//               size: 14,
//             ),
//             const SizedBox(width: 6),
//             Expanded(
//               child: Text(
//                 label,
//                 style: TextStyle(
//                   color: isTranslated ? AppTheme.success : AppTheme.textSecond,
//                   fontSize: 12,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 6),
//         Text(
//           text,
//           style: const TextStyle(
//             color: AppTheme.textPrimary,
//             fontStyle: FontStyle.italic,
//           ),
//         ),
//       ],
//     ),
//   );
//
//   Widget _buildResult(SpeechLoaded state) => Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: AppTheme.accentGlow,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: AppTheme.accent.withAlpha(77)),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 const Icon(
//                   Icons.auto_awesome,
//                   color: AppTheme.accent,
//                   size: 16,
//                 ),
//                 const SizedBox(width: 8),
//                 const Text(
//                   'AI Recommendation',
//                   style: TextStyle(
//                     color: AppTheme.accent,
//                     fontWeight: FontWeight.w600,
//                     fontSize: 13,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             Text(
//               state.recommendation.recommendation,
//               style: const TextStyle(color: AppTheme.textPrimary, height: 1.5),
//             ),
//           ],
//         ),
//       ),
//
//       const SizedBox(height: 20),
//
//       const Text(
//         'Recommended Services',
//         style: TextStyle(
//           color: AppTheme.textPrimary,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//       const SizedBox(height: 10),
//       ...state.recommendation.services.map(
//         (s) => Padding(
//           padding: const EdgeInsets.only(bottom: 8),
//           child: Row(
//             children: [
//               const Icon(Icons.check_circle, color: AppTheme.success, size: 16),
//               const SizedBox(width: 10),
//               Text(s, style: const TextStyle(color: AppTheme.textPrimary)),
//             ],
//           ),
//         ),
//       ),
//
//       const SizedBox(height: 20),
//
//       const Text(
//         'Next Steps',
//         style: TextStyle(
//           color: AppTheme.textPrimary,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//       const SizedBox(height: 10),
//       ...state.recommendation.nextSteps.map(
//         (s) => Padding(
//           padding: const EdgeInsets.only(bottom: 8),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Icon(Icons.arrow_forward, color: AppTheme.accent, size: 16),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: Text(
//                   s,
//                   style: const TextStyle(color: AppTheme.textSecond),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//
//       const SizedBox(height: 24),
//
//       SizedBox(
//         width: double.infinity,
//         child: TextButton.icon(
//           onPressed: () {
//             setState(() {
//               _transcribedText = '';
//               _translatedText = null;
//               _detectedLanguage = null;
//             });
//             context.read<SpeechCubit>().reset();
//           },
//           icon: const Icon(Icons.refresh),
//           label: const Text('Ask Again'),
//         ),
//       ),
//     ],
//   );
//
//   Widget _buildError(String message) => Center(
//     child: Column(
//       children: [
//         const Icon(Icons.error_outline, color: AppTheme.danger, size: 48),
//         const SizedBox(height: 16),
//         Text(
//           message,
//           style: const TextStyle(color: AppTheme.textSecond),
//           textAlign: TextAlign.center,
//         ),
//       ],
//     ),
//   );
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_ac/app_theme.dart';
import 'package:smart_ac/features/dashboard/cubit/product_cubit.dart';
import 'package:smart_ac/features/dashboard/view/product_sidebar_widget.dart';
import 'package:smart_ac/features/speech_screen/cubit/speech_cubit.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translator/translator.dart';

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({super.key});

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  final SpeechToText _speech = SpeechToText();
  final GoogleTranslator _translator = GoogleTranslator();

  bool _isListening = false;
  String _transcribedText = '';
  String? _translatedText;
  String? _detectedLanguage;
  bool _isTranslating = false;
  String? _selectedLocale = 'en_GB';

  final List<LocaleName> _defaultLanguages = [
    LocaleName('en_GB', '🇬🇧 English (UK)'),
    LocaleName('en_US', '🇺🇸 English (US)'),
    LocaleName('fr_FR', '🇫🇷 French'),
    LocaleName('de_DE', '🇩🇪 German'),
    LocaleName('es_ES', '🇪🇸 Spanish'),
    LocaleName('ar_SA', '🇸🇦 Arabic'),
    LocaleName('ur_PK', '🇵🇰 Urdu'),
    LocaleName('zh_CN', '🇨🇳 Chinese'),
  ];

  @override
  void initState() {
    super.initState();
    _speech.initialize();
  }

  Future<void> _startListening() async {
    setState(() {
      _isListening = true;
      _transcribedText = '';
      _translatedText = null;
      _detectedLanguage = null;
    });
    context.read<SpeechCubit>().reset();

    await _speech.listen(
      onResult: (result) {
        setState(() => _transcribedText = result.recognizedWords);
        if (result.finalResult) _stopListening();
      },
      listenFor: const Duration(seconds: 15),
      pauseFor: const Duration(seconds: 5),
      localeId: _selectedLocale ?? 'en_GB',
    );
  }

  Future<void> _stopListening() async {
    await _speech.stop();
    setState(() => _isListening = false);

    if (_transcribedText.isNotEmpty) {
      String textToSend = _transcribedText;

      if (_selectedLocale != null && !_selectedLocale!.startsWith('en')) {
        setState(() => _isTranslating = true);
        try {
          final result = await _translator.translate(
            _transcribedText,
            to: 'en',
          );
          textToSend = result.text;
          setState(() {
            _translatedText = result.text;
            _detectedLanguage = result.sourceLanguage.name;
            _isTranslating = false;
          });
        } catch (e) {
          setState(() => _isTranslating = false);
          textToSend = _transcribedText;
        }
      }

      context.read<SpeechCubit>().getRecommendation(text: textToSend);
      context.read<ProductCubit>().load(conversation: textToSend);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      body: BlocBuilder<SpeechCubit, SpeechState>(
        builder: (context, state) {
          return BlocBuilder<ProductCubit, ProductState>(
            builder: (context, productState) {
              final hasProducts =
                  productState is ProductLoaded &&
                  productState.recommendation.products.isNotEmpty;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Main Content ────────────────────────────
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(24),
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 16),
                        _buildLanguageSelector(),
                        const SizedBox(height: 20),

                        // ── Mobile product loading ────────────
                        if (!isWide && productState is ProductLoading)
                          const Padding(
                            padding: EdgeInsets.only(bottom: 16),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.shopping_bag_outlined,
                                  color: AppTheme.accent,
                                  size: 16,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Finding product recommendations...',
                                  style: TextStyle(
                                    color: AppTheme.textSecond,
                                    fontSize: 13,
                                  ),
                                ),
                                SizedBox(width: 8),
                                SizedBox(
                                  width: 12,
                                  height: 12,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppTheme.accent,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // ── Mobile horizontal products ────────
                        if (!isWide && hasProducts)
                          _buildMobileHorizontalProducts(
                            (productState as ProductLoaded)
                                .recommendation
                                .products,
                          ),

                        // ── Mic Button ────────────────────────
                        _buildMicButton(),
                        const SizedBox(height: 24),

                        // ── Transcribed + Translated ──────────
                        if (_transcribedText.isNotEmpty)
                          _buildTranscribedText(),
                        const SizedBox(height: 12),

                        // ── Translation Loading ───────────────
                        if (_isTranslating)
                          const Padding(
                            padding: EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppTheme.accent,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Translating...',
                                  style: TextStyle(
                                    color: AppTheme.textSecond,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // ── Result ────────────────────────────
                        switch (state) {
                          SpeechInitial() => const SizedBox.shrink(),
                          SpeechLoading() => const Center(
                            child: CircularProgressIndicator(
                              color: AppTheme.accent,
                            ),
                          ),
                          SpeechLoaded() => _buildResult(state),
                          SpeechError() => _buildError(state.message),
                        },
                      ],
                    ),
                  ),

                  // ── Web Sidebar ──────────────────────────────
                  if (isWide && hasProducts) const ProductSidebarWidget(),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHeader() => Row(
    children: [
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppTheme.accentGlow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.mic, color: AppTheme.accent, size: 22),
      ),
      const SizedBox(width: 12),
      const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SmartAC Assistant',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'Ask me about your accounts',
            style: TextStyle(color: AppTheme.textSecond, fontSize: 13),
          ),
        ],
      ),
    ],
  );

  Widget _buildLanguageSelector() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: AppTheme.surface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppTheme.border),
    ),
    child: Row(
      children: [
        const Icon(Icons.language, color: AppTheme.accent, size: 18),
        const SizedBox(width: 10),
        const Text(
          'Language',
          style: TextStyle(color: AppTheme.textSecond, fontSize: 13),
        ),
        const Spacer(),
        DropdownButtonHideUnderline(
          child: DropdownButton<String?>(
            value: _selectedLocale,
            dropdownColor: AppTheme.surface,
            style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
            icon: const Icon(Icons.expand_more, color: AppTheme.textSecond),
            items: _defaultLanguages
                .map(
                  (locale) => DropdownMenuItem(
                    value: locale.localeId,
                    child: Text(locale.name),
                  ),
                )
                .toList(),
            onChanged: (val) => setState(() => _selectedLocale = val),
          ),
        ),
      ],
    ),
  );

  Widget _buildMicButton() => Column(
    children: [
      Center(
        child: GestureDetector(
          onTap: _isListening ? _stopListening : _startListening,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isListening
                  ? AppTheme.danger.withAlpha(26)
                  : AppTheme.accentGlow,
              border: Border.all(
                color: _isListening ? AppTheme.danger : AppTheme.accent,
                width: 2,
              ),
            ),
            child: Icon(
              _isListening ? Icons.stop : Icons.mic,
              size: 42,
              color: _isListening ? AppTheme.danger : AppTheme.accent,
            ),
          ),
        ),
      ),
      const SizedBox(height: 12),
      Text(
        _isListening
            ? 'Listening... (auto stops after 5s pause)'
            : 'Tap to speak - max 15 seconds',
        style: const TextStyle(color: AppTheme.textSecond, fontSize: 12),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 16),
      if (_isListening)
        ElevatedButton.icon(
          onPressed: _stopListening,
          icon: const Icon(Icons.send, size: 16),
          label: const Text('Ready - Send'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.accent,
            foregroundColor: Colors.white,
          ),
        ),
    ],
  );

  Widget _buildTranscribedText() {
    final isWide = MediaQuery.of(context).size.width > 700;
    final hasTranslation = _translatedText != null;

    if (isWide && hasTranslation) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildTextCard(
              label: 'You said (${_detectedLanguage ?? 'Unknown'}):',
              text: '"$_transcribedText"',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildTextCard(
              label: 'Translated to English:',
              text: '"$_translatedText"',
              isTranslated: true,
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        _buildTextCard(
          label: hasTranslation
              ? 'You said (${_detectedLanguage ?? 'Unknown'}):'
              : 'You said:',
          text: '"$_transcribedText"',
        ),
        if (hasTranslation) ...[
          const SizedBox(height: 10),
          _buildTextCard(
            label: 'Translated to English:',
            text: '"$_translatedText"',
            isTranslated: true,
          ),
        ],
      ],
    );
  }

  Widget _buildTextCard({
    required String label,
    required String text,
    bool isTranslated = false,
  }) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppTheme.surface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: isTranslated
            ? AppTheme.success.withAlpha(77)
            : AppTheme.accent.withAlpha(51),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              isTranslated ? Icons.translate : Icons.mic,
              color: isTranslated ? AppTheme.success : AppTheme.accent,
              size: 14,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isTranslated ? AppTheme.success : AppTheme.textSecond,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          text,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    ),
  );

  Widget _buildMobileHorizontalProducts(List<dynamic> products) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          const Icon(
            Icons.shopping_bag_outlined,
            color: AppTheme.accent,
            size: 16,
          ),
          const SizedBox(width: 8),
          const Text(
            'Recommended Products',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          Text(
            '${products.length} items',
            style: const TextStyle(color: AppTheme.textSecond, fontSize: 12),
          ),
        ],
      ),
      const SizedBox(height: 12),
      SizedBox(
        height: 160,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: products.length,
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemBuilder: (context, index) {
            final product = products[index];
            return Container(
              width: 120,
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.network(
                      product.image,
                      height: 80,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 80,
                        color: AppTheme.surfaceLight,
                        child: const Icon(
                          Icons.image_not_supported,
                          color: AppTheme.textSecond,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '£${product.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: AppTheme.accent,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 20),
      const Divider(color: AppTheme.border),
      const SizedBox(height: 8),
    ],
  );

  Widget _buildResult(SpeechLoaded state) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.accentGlow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.accent.withAlpha(77)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.auto_awesome,
                  color: AppTheme.accent,
                  size: 16,
                ),
                const SizedBox(width: 8),
                const Text(
                  'AI Recommendation',
                  style: TextStyle(
                    color: AppTheme.accent,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              state.recommendation.recommendation,
              style: const TextStyle(color: AppTheme.textPrimary, height: 1.5),
            ),
          ],
        ),
      ),

      const SizedBox(height: 20),

      const Text(
        'Recommended Services',
        style: TextStyle(
          color: AppTheme.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 10),
      ...state.recommendation.services.map(
        (s) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: AppTheme.success, size: 16),
              const SizedBox(width: 10),
              Text(s, style: const TextStyle(color: AppTheme.textPrimary)),
            ],
          ),
        ),
      ),

      const SizedBox(height: 20),

      const Text(
        'Next Steps',
        style: TextStyle(
          color: AppTheme.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 10),
      ...state.recommendation.nextSteps.map(
        (s) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.arrow_forward, color: AppTheme.accent, size: 16),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  s,
                  style: const TextStyle(color: AppTheme.textSecond),
                ),
              ),
            ],
          ),
        ),
      ),

      const SizedBox(height: 24),

      SizedBox(
        width: double.infinity,
        child: TextButton.icon(
          onPressed: () {
            setState(() {
              _transcribedText = '';
              _translatedText = null;
              _detectedLanguage = null;
            });
            context.read<SpeechCubit>().reset();
          },
          icon: const Icon(Icons.refresh),
          label: const Text('Ask Again'),
        ),
      ),
    ],
  );

  Widget _buildError(String message) => Center(
    child: Column(
      children: [
        const Icon(Icons.error_outline, color: AppTheme.danger, size: 48),
        const SizedBox(height: 16),
        Text(
          message,
          style: const TextStyle(color: AppTheme.textSecond),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
