import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/order.dart';
import '../../../shared/widgets/cavo_premium_ui.dart';
import '../data/order_controller.dart';

class DeliveryTrackingScreen extends StatelessWidget {
  const DeliveryTrackingScreen({
    super.key,
    required this.order,
  });

  final CavoOrder order;

  List<_TrackingStep> _buildSteps() {
    final statuses = [
      OrderStatus.pendingReview,
      OrderStatus.approved,
      OrderStatus.processing,
      OrderStatus.shipped,
      OrderStatus.delivered,
    ];

    final currentIndex = statuses.indexOf(order.status);
    final safeIndex = currentIndex < 0 ? 0 : currentIndex;

    return [
      _TrackingStep(
        status: OrderStatus.pendingReview,
        title: 'Order placed',
        subtitle: 'Your order reached Firebase and is waiting for review.',
        state: safeIndex >= 0 ? _StepState.done : _StepState.todo,
      ),
      _TrackingStep(
        status: OrderStatus.approved,
        title: 'Approved',
        subtitle: 'The order was approved from the admin side.',
        state: safeIndex > 1
            ? _StepState.done
            : safeIndex == 1
                ? _StepState.current
                : _StepState.todo,
      ),
      _TrackingStep(
        status: OrderStatus.processing,
        title: 'Preparing your order',
        subtitle: 'Your pair is being checked and packed carefully.',
        state: safeIndex > 2
            ? _StepState.done
            : safeIndex == 2
                ? _StepState.current
                : _StepState.todo,
      ),
      _TrackingStep(
        status: OrderStatus.shipped,
        title: 'On the way',
        subtitle: 'Your order has left and is moving to the delivery stage.',
        state: safeIndex > 3
            ? _StepState.done
            : safeIndex == 3
                ? _StepState.current
                : _StepState.todo,
      ),
      _TrackingStep(
        status: OrderStatus.delivered,
        title: 'Delivered',
        subtitle: 'Your order arrived successfully. Enjoy your pair.',
        state: safeIndex >= 4 ? _StepState.done : _StepState.todo,
      ),
    ];
  }

  Color _statusTint(OrderStatus status) {
    switch (status) {
      case OrderStatus.rejected:
        return const Color(0xFFDA5A5A);
      case OrderStatus.cancelled:
        return const Color(0xFFC8893A);
      case OrderStatus.delivered:
        return const Color(0xFF2DBA71);
      default:
        return CavoColors.gold;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondary = isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;
    final accent = _statusTint(order.status);
    final steps = _buildSteps();

    return Scaffold(
      backgroundColor: isLight ? CavoColors.lightBackground : CavoColors.background,
      body: CavoPremiumBackground(
        isLight: isLight,
        child: SafeArea(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
            children: [
              Row(
                children: [
                  CavoCircleIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    isLight: isLight,
                    onTap: () => Navigator.of(context).maybePop(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Shipment Review',
                          style: TextStyle(
                            color: primary,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Track every step of your CAVO order.',
                          style: TextStyle(
                            color: secondary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              CavoGlassCard(
                isLight: isLight,
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _MetaBlock(
                            label: 'Order ID',
                            value: order.id,
                            primary: primary,
                            secondary: secondary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            color: accent.withValues(alpha: 0.16),
                            border: Border.all(color: accent.withValues(alpha: 0.20)),
                          ),
                          child: Text(
                            order.status.label,
                            style: TextStyle(
                              color: accent,
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _MetaBlock(
                            label: 'From',
                            value: 'CAVO, Hurghada',
                            primary: primary,
                            secondary: secondary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _MetaBlock(
                            label: 'To',
                            value: '${order.city}, ${order.area}',
                            primary: primary,
                            secondary: secondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: isLight ? const Color(0xFFF7F4ED) : const Color(0xFF111318),
                        border: Border.all(
                          color: accent.withValues(alpha: 0.14),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order.status == OrderStatus.delivered ? 'Enjoy your order' : 'Your order is moving',
                                  style: TextStyle(
                                    color: primary,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.7,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  order.status == OrderStatus.rejected
                                      ? 'The order was rejected from the admin side. Please contact support if needed.'
                                      : 'We keep every status synced from Firebase so you always know the exact step.',
                                  style: TextStyle(
                                    color: secondary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    height: 1.55,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  accent.withValues(alpha: 0.95),
                                  accent.withValues(alpha: 0.55),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: accent.withValues(alpha: 0.18),
                                  blurRadius: 22,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Icon(
                              order.status == OrderStatus.delivered
                                  ? Icons.check_rounded
                                  : order.status == OrderStatus.shipped
                                      ? Icons.local_shipping_rounded
                                      : Icons.inventory_2_outlined,
                              color: Colors.white,
                              size: 34,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              CavoGlassCard(
                isLight: isLight,
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Timeline',
                      style: TextStyle(
                        color: primary,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ...List.generate(steps.length, (index) {
                      final step = steps[index];
                      final showLine = index != steps.length - 1;
                      return _TimelineTile(
                        step: step,
                        showLine: showLine,
                        primary: primary,
                        secondary: secondary,
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              CavoGlassCard(
                isLight: isLight,
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivery details',
                      style: TextStyle(
                        color: primary,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _detailRow('Customer', order.customerName, primary, secondary),
                    _detailRow('Phone', order.phoneNumber, primary, secondary),
                    _detailRow('Address', '${order.city}, ${order.area}\n${order.addressLine}', primary, secondary),
                    _detailRow('Payment', order.paymentMethod.label, primary, secondary),
                    _detailRow('Total', '${order.total} EGP', primary, secondary),
                  ],
                ),
              ),
              if (order.status == OrderStatus.delivered) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await showCavoRatingSheet(context, order: order);
                    },
                    child: Text(order.isRated ? 'Update rating' : 'Rate your delivery'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value, Color primary, Color secondary) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 88,
            child: Text(
              label,
              style: TextStyle(
                color: secondary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: primary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> showCavoRatingSheet(
  BuildContext context, {
  required CavoOrder order,
}) async {
  final isLight = Theme.of(context).brightness == Brightness.light;
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _OrderRatingSheet(order: order, isLight: isLight),
  );
}

class _OrderRatingSheet extends StatefulWidget {
  const _OrderRatingSheet({
    required this.order,
    required this.isLight,
  });

  final CavoOrder order;
  final bool isLight;

  @override
  State<_OrderRatingSheet> createState() => _OrderRatingSheetState();
}

class _OrderRatingSheetState extends State<_OrderRatingSheet>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  int _rating = 5;
  bool _saving = false;
  final Set<String> _tags = {'On time'};

  static const _choices = [
    'On time',
    'Friendly',
    'Careful',
    'Communicative',
    'Above & beyond',
  ];

  @override
  void initState() {
    super.initState();
    _rating = widget.order.rating ?? 5;
    _tags.addAll(widget.order.ratingTags);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    )..forward();
    _scale = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = widget.isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondary = widget.isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;
    return Padding(
      padding: EdgeInsets.only(
        left: 14,
        right: 14,
        bottom: MediaQuery.of(context).viewInsets.bottom + 14,
      ),
      child: ScaleTransition(
        scale: _scale,
        child: CavoGlassCard(
          isLight: widget.isLight,
          borderRadius: const BorderRadius.all(Radius.circular(34)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 62,
                height: 6,
                decoration: BoxDecoration(
                  color: (widget.isLight ? Colors.black : Colors.white).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 18),
              CircleAvatar(
                radius: 28,
                backgroundColor: CavoColors.gold.withValues(alpha: 0.14),
                child: const Text('👟', style: TextStyle(fontSize: 28)),
              ),
              const SizedBox(height: 12),
              Text(
                'How was your delivery?',
                style: TextStyle(
                  color: primary,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Rate the CAVO experience for order ${widget.order.id}.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: secondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final active = _rating >= index + 1;
                  return IconButton(
                    onPressed: () => setState(() => _rating = index + 1),
                    icon: Icon(
                      active ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: active ? CavoColors.gold : secondary,
                      size: 32,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: _choices.map((choice) {
                  final selected = _tags.contains(choice);
                  return ChoiceChip(
                    label: Text(choice),
                    selected: selected,
                    onSelected: (_) {
                      setState(() {
                        if (selected) {
                          _tags.remove(choice);
                        } else {
                          _tags.add(choice);
                        }
                      });
                    },
                    selectedColor: CavoColors.gold.withValues(alpha: 0.20),
                    backgroundColor: widget.isLight ? Colors.white : CavoColors.surfaceSoft,
                    labelStyle: TextStyle(
                      color: selected ? primary : secondary,
                      fontWeight: FontWeight.w700,
                    ),
                    side: BorderSide(
                      color: selected
                          ? CavoColors.gold.withValues(alpha: 0.24)
                          : (widget.isLight ? CavoColors.lightBorder : CavoColors.border),
                    ),
                  );
                }).toList(growable: false),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saving
                      ? null
                      : () async {
                          setState(() => _saving = true);
                          try {
                            await OrderController.instance.submitRating(
                              orderId: widget.order.id,
                              rating: _rating,
                              tags: _tags.toList(growable: false),
                            );
                            if (!mounted) return;
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Thanks — your rating was saved.')),
                            );
                          } finally {
                            if (mounted) setState(() => _saving = false);
                          }
                        },
                  child: Text(_saving ? 'Saving...' : 'Submit rating'),
                ),
              ),
              const SizedBox(height: 6),
              TextButton(
                onPressed: _saving ? null : () => Navigator.of(context).pop(),
                child: const Text('Maybe later'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaBlock extends StatelessWidget {
  const _MetaBlock({
    required this.label,
    required this.value,
    required this.primary,
    required this.secondary,
  });

  final String label;
  final String value;
  final Color primary;
  final Color secondary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: secondary,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: primary,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

enum _StepState { done, current, todo }

class _TrackingStep {
  const _TrackingStep({
    required this.status,
    required this.title,
    required this.subtitle,
    required this.state,
  });

  final OrderStatus status;
  final String title;
  final String subtitle;
  final _StepState state;
}

class _TimelineTile extends StatelessWidget {
  const _TimelineTile({
    required this.step,
    required this.showLine,
    required this.primary,
    required this.secondary,
  });

  final _TrackingStep step;
  final bool showLine;
  final Color primary;
  final Color secondary;

  @override
  Widget build(BuildContext context) {
    final accent = step.state == _StepState.todo
        ? secondary.withValues(alpha: 0.26)
        : step.state == _StepState.current
            ? CavoColors.gold
            : const Color(0xFF2DBA71);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 34,
          child: Column(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accent.withValues(alpha: step.state == _StepState.todo ? 0.10 : 0.18),
                  border: Border.all(color: accent.withValues(alpha: 0.32)),
                ),
                child: Icon(
                  step.state == _StepState.done
                      ? Icons.check_rounded
                      : step.state == _StepState.current
                          ? Icons.radio_button_checked_rounded
                          : Icons.circle_outlined,
                  size: 15,
                  color: accent,
                ),
              ),
              if (showLine)
                Container(
                  width: 2,
                  height: 34,
                  color: accent.withValues(alpha: 0.24),
                ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: TextStyle(
                    color: primary,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  step.subtitle,
                  style: TextStyle(
                    color: secondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
