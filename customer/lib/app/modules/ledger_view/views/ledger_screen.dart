import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/ledger_screen_controller.dart';
import '../../../core/utils/DateTimeHelper.dart';
import '../../../data/models/ledger/ledger_response.dart'; 

class LedgerScreen extends GetView<LedgerScreenController> {
  const LedgerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Ledger"),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.isError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(controller.hasError.value),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: controller.fetchLedger,
                  child: const Text("Retry"),
                )
              ],
            ),
          );
        }

        final data = controller.ledgerData.value;
        if (data == null) {
          return const Center(child: Text("No ledger data found"));
        }

        return RefreshIndicator(
          onRefresh: controller.fetchLedger,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary Card
                _buildSummaryCard(data, theme),
                const SizedBox(height: 20),

                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: controller.filterOptions.map((filter) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Obx(() => ChoiceChip(
                          label: Text(filter),
                          selected: controller.selectedFilter.value == filter,
                          onSelected: (selected) {
                            if (selected) {
                              controller.setFilter(filter);
                            }
                          },
                        )),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Transactions / Orders List
                const Text(
                  "Transactions",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                
                // Use filteredOrders from controller
                _buildOrdersList(controller.filteredOrders, theme, isDark),
                
                if (data.payments != null && data.payments!.isNotEmpty) ...[
                   const SizedBox(height: 20),
                   const Text(
                    "Payments",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildPaymentsList(data.payments!, theme, isDark),
                ]
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSummaryCard(LedgerData data, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.blue.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          const Text(
            "Total Pending Amount",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 5),
          Text(
            "₹${data.totalPendingAmount ?? '0'}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Text("Total Order Amt", style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 5),
                    Text(
                      "₹${data.totalOrderAmount ?? '0'}",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 40, color: Colors.white24),
              Expanded(
                child: Column(
                  children: [
                    const Text("Total Paid", style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 5),
                    Text(
                      "₹${data.totalPaidAmount ?? '0'}",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildOrdersList(List<dynamic> orders, ThemeData theme, bool isDark) {
    if (orders.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text("No transactions found", style: theme.textTheme.bodyMedium),
        )
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final order = orders[index];

        return Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isDark ? Colors.red.withOpacity(0.2) : Colors.red.shade50,
              child: const Icon(
                Icons.shopping_cart,
                color: Colors.red,
              ),
            ),
            title: Text(
              order.orderNo ?? "Order #${order.id}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (order.scheduledDate != null)
                  Text(
                    DateTimeHelper.formatDateMonth(order.scheduledDate!),
                    style: theme.textTheme.bodySmall,
                  ),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    order.status?.toUpperCase() ?? "UNKNOWN",
                    style: TextStyle(
                      fontSize: 10, 
                      color: _getStatusColor(order.status),
                      fontWeight: FontWeight.bold
                    ),
                  ),
                )
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "- ₹${order.totalAmount}",
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  order.paymentStatus ?? "Unpaid",
                   style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'delivered': return Colors.green;
      case 'assigned': return Colors.blue;
      case 'created': return Colors.orange;
      case 'cancelled': return Colors.red;
      default: return Colors.grey;
    }
  }

  Widget _buildPaymentsList(List<Payment> payments, ThemeData theme, bool isDark) {
    if (payments.isEmpty) return const SizedBox.shrink();

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: payments.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final payment = payments[index];

        return Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isDark ? Colors.green.withOpacity(0.2) : Colors.green.shade50,
              child: const Icon(
                Icons.arrow_downward,
                color: Colors.green,
              ),
            ),
            title: const Text(
              "Payment Received",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              payment.paymentDate != null
                  ? DateTimeHelper.formatDateMonth(payment.paymentDate!)
                  : payment.method ?? "Cash",
              style: theme.textTheme.bodySmall,
            ),
            trailing: Text(
              "+ ₹${payment.amount}",
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        );
      },
    );
  }
}
