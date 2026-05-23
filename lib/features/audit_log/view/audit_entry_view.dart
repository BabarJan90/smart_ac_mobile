import 'package:domain/model/audit_entry.dart';
import 'package:flutter/material.dart';
import 'package:smart_ac/app_theme.dart';

class AuditEntryView extends StatelessWidget {
  final AuditEntry entry;

  const AuditEntryView({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDetail(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(top: 5),
              decoration: const BoxDecoration(
                color: AppTheme.accent,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          entry.action.replaceAll('_', ' ').toUpperCase(),
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      Text(
                        entry.timestamp.length > 19
                            ? entry.timestamp.substring(0, 19)
                            : entry.timestamp,
                        style: const TextStyle(
                          color: AppTheme.textSecond,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  if (entry.justification.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      entry.justification,
                      style: const TextStyle(
                        color: AppTheme.textSecond,
                        fontSize: 12,
                        height: 1.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.smart_toy,
                        size: 12,
                        color: AppTheme.textSecond,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        entry.modelUsed,
                        style: const TextStyle(
                          color: AppTheme.textSecond,
                          fontSize: 11,
                        ),
                      ),
                      if (entry.transactionId != 0) ...[
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.receipt,
                          size: 12,
                          color: AppTheme.textSecond,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'TX #${entry.transactionId}',
                          style: const TextStyle(
                            color: AppTheme.textSecond,
                            fontSize: 11,
                          ),
                        ),
                      ],
                      const Spacer(),
                      const Icon(
                        Icons.expand_more,
                        size: 14,
                        color: AppTheme.textSecond,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        expand: false,
        builder: (_, controller) => ListView(
          controller: controller,
          padding: const EdgeInsets.all(24),
          children: [
            // ── Handle ────────────────────────────────────────────
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
            // ── Action ────────────────────────────────────────────
            Text(
              entry.action.replaceAll('_', ' ').toUpperCase(),
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              entry.timestamp,
              style: const TextStyle(color: AppTheme.textSecond, fontSize: 13),
            ),
            const SizedBox(height: 20),
            const Divider(color: AppTheme.border),
            const SizedBox(height: 16),
            // ── Model ─────────────────────────────────────────────
            Row(
              children: [
                const Icon(Icons.smart_toy, size: 16, color: AppTheme.accent),
                const SizedBox(width: 8),
                Text(
                  entry.modelUsed,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            if (entry.transactionId != 0) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.receipt, size: 16, color: AppTheme.accent),
                  const SizedBox(width: 8),
                  Text(
                    'Transaction #${entry.transactionId}',
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 20),
            const Divider(color: AppTheme.border),
            const SizedBox(height: 16),
            // ── Full Justification ────────────────────────────────
            const Text(
              'Full Details',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.surfaceLight,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.border),
              ),
              child: Text(
                entry.justification,
                style: const TextStyle(
                  color: AppTheme.textSecond,
                  fontSize: 13,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
