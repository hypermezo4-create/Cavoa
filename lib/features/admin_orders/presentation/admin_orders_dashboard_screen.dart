import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/order.dart';
import '../../../shared/widgets/cavo_premium_ui.dart';
import '../data/admin_orders_controller.dart';
import 'admin_order_details_screen.dart';

class AdminOrdersDashboardScreen extends StatefulWidget {
  const AdminOrdersDashboardScreen({super.key});

  @override
  State<AdminOrdersDashboardScreen> createState() => _AdminOrdersDashboardScreenState();
}

class _AdminOrdersDashboardScreenState extends State<AdminOrdersDashboardScreen> {
  OrderStatus? _statusFilter;
  OrderPaymentStatus? _paymentStatusFilter;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondary = isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;

    return Scaffold(
      backgroundColor: isLight ? CavoColors.lightBackground : CavoColors.background,
      body: CavoPremiumBackground(
        isLight: isLight,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: Row(
                  children: [
                    CavoCircleIconButton(
                      icon: Icons.arrow_back_ios_new_rounded,
                      isLight: isLight,
                      onTap: () => Navigator.of(context).maybePop(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Admin Orders Dashboard',
                        style: TextStyle(color: primary, fontSize: 24, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: 'Search by customer, phone, or order ID',
                    prefixIcon: Icon(Icons.search_rounded),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<OrderStatus?>(
                        value: _statusFilter,
                        decoration: const InputDecoration(labelText: 'Order status'),
                        items: [
                          const DropdownMenuItem<OrderStatus?>(value: null, child: Text('All statuses')),
                          ...OrderStatus.values.map(
                            (status) => DropdownMenuItem<OrderStatus?>(
                              value: status,
                              child: Text(status.key),
                            ),
                          ),
                        ],
                        onChanged: (value) => setState(() => _statusFilter = value),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<OrderPaymentStatus?>(
                        value: _paymentStatusFilter,
                        decoration: const InputDecoration(labelText: 'Payment status'),
                        items: [
                          const DropdownMenuItem<OrderPaymentStatus?>(value: null, child: Text('All payments')),
                          ...OrderPaymentStatus.values.map(
                            (status) => DropdownMenuItem<OrderPaymentStatus?>(
                              value: status,
                              child: Text(status.key),
                            ),
                          ),
                        ],
                        onChanged: (value) => setState(() => _paymentStatusFilter = value),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder<List<CavoOrder>>(
                  stream: AdminOrdersController.instance.watchAllOrders(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final query = _searchController.text.trim().toLowerCase();
                    final filtered = (snapshot.data ?? const <CavoOrder>[]).where((order) {
                      final statusMatches = _statusFilter == null || order.status == _statusFilter;
                      final paymentMatches = _paymentStatusFilter == null || order.paymentStatus == _paymentStatusFilter;
                      final searchable = '${order.customerName} ${order.phoneNumber} ${order.id}'.toLowerCase();
                      final searchMatches = query.isEmpty || searchable.contains(query);
                      return statusMatches && paymentMatches && searchMatches;
                    }).toList(growable: false)
                      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

                    if (filtered.isEmpty) {
                      return Center(
                        child: Text('No orders match current filters.', style: TextStyle(color: secondary, fontWeight: FontWeight.w700)),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 6, 20, 20),
                      itemBuilder: (context, index) {
                        final order = filtered[index];
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => AdminOrderDetailsScreen(orderId: order.id)),
                            );
                          },
                          borderRadius: BorderRadius.circular(24),
                          child: CavoGlassCard(
                            isLight: isLight,
                            borderRadius: const BorderRadius.all(Radius.circular(24)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(order.id, style: TextStyle(color: primary, fontWeight: FontWeight.w900)),
                                    ),
                                    CavoPillTag(label: order.status.key, isLight: isLight, selected: true),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text('${order.customerName} • ${order.phoneNumber}', style: TextStyle(color: secondary, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 6),
                                Text('Payment: ${order.paymentStatus.key} • Total: ${order.total} EGP', style: TextStyle(color: secondary, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 6),
                                Text('Placed: ${order.createdAt.toLocal()}', style: TextStyle(color: secondary, fontSize: 12, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemCount: filtered.length,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
