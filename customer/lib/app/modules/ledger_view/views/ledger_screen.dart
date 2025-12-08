import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/ledger_screen_controller.dart';
import '../../../core/utils/DateTimeHelper.dart';
import '../../../data/models/ledger/ledger_response.dart'; 

class LedgerScreen extends GetView<LedgerScreenController> {
  const LedgerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("My Ledger"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
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
                _buildSummaryCard(data),
                const SizedBox(height: 20),
                
                // Transactions / Orders List
                const Text(
                  "Transactions",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                // Based on API response, we have 'orders' and 'payments'
                // We can combine them or show orders as main transactions for now
                if (data.orders != null)
                   _buildOrdersList(data.orders!),
                
                if (data.payments != null && data.payments!.isNotEmpty) ...[
                   const SizedBox(height: 20),
                   const Text(
                    "Payments",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildPaymentsList(data.payments!),
                ]
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSummaryCard(LedgerData data) {
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

  Widget _buildOrdersList(List<dynamic> orders) { // Using dynamic to accept OrderData
    if (orders.isEmpty) {
      return const Center(child: Text("No orders found"));
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final order = orders[index];
        // OrderData order

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red.shade50,
              child: const Icon(
                Icons.shopping_cart,
                color: Colors.red,
              ),
            ),
            title: Text(
              order.orderNo ?? "Order #${order.id}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              order.scheduledDate != null 
                  ? DateTimeHelper.formatDateMonth(order.scheduledDate!)
                  : "N/A",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
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
                   style: TextStyle(color: Colors.grey.shade600, fontSize: 10),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPaymentsList(List<Payment> payments) {
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green.shade50,
              child: const Icon(
                Icons.arrow_downward,
                color: Colors.green,
              ),
            ),
            title: Text(
              "Payment Received",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              payment.paymentDate != null
                  ? DateTimeHelper.formatDateMonth(payment.paymentDate!)
                  : payment.method ?? "Cash",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
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
