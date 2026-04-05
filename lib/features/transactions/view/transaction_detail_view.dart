import 'package:domain/model/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_ac/widgets.dart';

import '../../../app_theme.dart';

class TransactionDetailView extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetailView({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(symbol: '£');
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.95,
      builder: (_, controller) => ListView(
        controller: controller,
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Text(
                  transaction.vendor,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              RiskBadge(label: transaction.riskLabel),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            fmt.format(transaction.amount),
            style: const TextStyle(
              color: AppTheme.accent,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          _detailRow(
            'Category',
            transaction.category.isEmpty
                ? 'Uncategorised'
                : transaction.category,
          ),
          _detailRow('Date', transaction.date),
          _detailRow(
            'Risk Score',
            '${transaction.riskScore.toStringAsFixed(1)} / 100',
          ),
          _detailRow('Anomaly', transaction.isAnomaly ? 'Yes - flagged' : 'No'),
          const SizedBox(height: 20),
          if (transaction.explanation.isNotEmpty) ...[
            const Text(
              'AI Explanation (XAI)',
              style: TextStyle(
                color: AppTheme.textSecond,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.accentGlow,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.accent.withAlpha(51)),
              ),
              child: Text(
                transaction.explanation,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 13,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      children: [
        Text(
          label,
          style: const TextStyle(color: AppTheme.textSecond, fontSize: 13),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}
