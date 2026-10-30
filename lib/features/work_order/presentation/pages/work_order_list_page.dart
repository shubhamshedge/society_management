import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/work_order_entity.dart';
import '../bloc/work_order_bloc.dart';
import '../bloc/work_order_event.dart';
import '../bloc/work_order_state.dart';

class WorkOrderListPage extends StatefulWidget {
  final String societyId;
  final String societyName;
  final String userRoleName; // e.g. 'Adhyaksha (Rajesh Sharma)'

  const WorkOrderListPage({
    super.key,
    required this.societyId,
    required this.societyName,
    required this.userRoleName,
  });

  @override
  State<WorkOrderListPage> createState() => _WorkOrderListPageState();
}

class _WorkOrderListPageState extends State<WorkOrderListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    context.read<WorkOrderBloc>().add(
          LoadWorkOrdersEvent(societyId: widget.societyId),
        );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Work Orders (कार्यादेश)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            Text(
              widget.societyName,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
      body: BlocConsumer<WorkOrderBloc, WorkOrderState>(
        listener: (context, state) {
          if (state is WorkOrderLoadedState && state.toastMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.toastMessage!),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is WorkOrderLoadingState || state is WorkOrderInitialState) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is WorkOrderErrorState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline_rounded,
                      color: AppColors.error, size: 48),
                  const SizedBox(height: 12),
                  Text(state.message),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      context.read<WorkOrderBloc>().add(
                            LoadWorkOrdersEvent(societyId: widget.societyId),
                          );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is WorkOrderLoadedState) {
            final allOrders = state.allWorkOrders;
            final pendingOrders = state.pendingApprovalOrders;
            final activeOrders = state.activeOrders;
            final completedOrders = state.completedOrders;

            return Column(
              children: [
                // 1. Metric Overview Cards
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Row(
                    children: [
                      _buildMetricMini(
                        label: 'Total Orders',
                        count: '${allOrders.length}',
                        color: AppColors.textPrimary,
                      ),
                      const SizedBox(width: 8),
                      _buildMetricMini(
                        label: 'Needs Approval',
                        count: '${pendingOrders.length}',
                        color: AppColors.warning,
                      ),
                      const SizedBox(width: 8),
                      _buildMetricMini(
                        label: 'In Progress',
                        count: '${activeOrders.length}',
                        color: AppColors.primaryLight,
                      ),
                      const SizedBox(width: 8),
                      _buildMetricMini(
                        label: 'Completed',
                        count: '${completedOrders.length}',
                        color: AppColors.success,
                      ),
                    ],
                  ),
                ),

                // 2. Tab Bar
                Container(
                  color: Colors.white,
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: AppColors.textSecondary,
                    indicatorColor: AppColors.primary,
                    indicatorWeight: 3,
                    labelStyle: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 13),
                    tabs: [
                      Tab(text: 'All (${allOrders.length})'),
                      Tab(
                        child: Row(
                          children: [
                            const Text('Needs Approval'),
                            const SizedBox(width: 6),
                            if (pendingOrders.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.warning,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${pendingOrders.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Tab(text: 'Active (${activeOrders.length})'),
                      Tab(text: 'Completed (${completedOrders.length})'),
                    ],
                  ),
                ),

                // 3. Tab Views
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildOrderListView(allOrders),
                      _buildOrderListView(pendingOrders),
                      _buildOrderListView(activeOrders),
                      _buildOrderListView(completedOrders),
                    ],
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_task_rounded, color: Colors.white),
        label: const Text(
          'Issue Work Order',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Opening Work Order creation form...'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetricMini({
    required String label,
    required String count,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Text(
              count,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderListView(List<WorkOrderEntity> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.inventory_2_outlined, size: 48, color: AppColors.textMuted),
            SizedBox(height: 12),
            Text(
              'No work orders found in this section',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildWorkOrderCard(order);
      },
    );
  }

  Widget _buildWorkOrderCard(WorkOrderEntity order) {
    Color statusColor;
    Color priorityColor;

    switch (order.status) {
      case WorkOrderStatus.pendingApproval:
        statusColor = AppColors.warning;
        break;
      case WorkOrderStatus.inProgress:
        statusColor = AppColors.primaryLight;
        break;
      case WorkOrderStatus.completed:
        statusColor = AppColors.success;
        break;
      case WorkOrderStatus.rejected:
        statusColor = AppColors.error;
        break;
      case WorkOrderStatus.assigned:
        statusColor = AppColors.sachivColor;
        break;
    }

    switch (order.priority) {
      case WorkOrderPriority.urgent:
        priorityColor = AppColors.error;
        break;
      case WorkOrderPriority.high:
        priorityColor = AppColors.warning;
        break;
      case WorkOrderPriority.medium:
        priorityColor = AppColors.primaryLight;
        break;
      case WorkOrderPriority.low:
        priorityColor = AppColors.textMuted;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header: Order Number & Priority & Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      order.workOrderNumber,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: priorityColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      order.priority.displayName,
                      style: TextStyle(
                        fontSize: 11,
                        color: priorityColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  order.status.displayName,
                  style: TextStyle(
                    fontSize: 11,
                    color: statusColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 2. Title & Category
          Text(
            order.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.category_rounded, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                order.category,
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              if (order.location != null) ...[
                const SizedBox(width: 8),
                const Text('•', style: TextStyle(color: AppColors.textMuted)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    order.location!,
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Text(
            order.description,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Divider(height: 24),

          // 3. Vendor Info & Financial Cost
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Assigned Vendor',
                      style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      order.vendorName,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '+91 ${order.vendorPhone}',
                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    order.status == WorkOrderStatus.completed
                        ? 'Actual Cost'
                        : 'Estimated Budget',
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '₹${(order.actualCost ?? order.estimatedCost).toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // 4. Action Row (Approval for Chairman / Sachiv)
          if (order.status == WorkOrderStatus.pendingApproval) ...[
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
                label: const Text(
                  'Approve Work Order (मंजूर करें)',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                ),
                onPressed: () {
                  context.read<WorkOrderBloc>().add(
                        ApproveWorkOrderEvent(
                          workOrderId: order.id,
                          approverName: widget.userRoleName,
                        ),
                      );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
