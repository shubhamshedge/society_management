import '../../domain/entities/work_order_entity.dart';

class WorkOrderModel extends WorkOrderEntity {
  const WorkOrderModel({
    required super.id,
    required super.workOrderNumber,
    required super.title,
    required super.description,
    required super.category,
    required super.priority,
    required super.status,
    required super.vendorName,
    required super.vendorPhone,
    required super.estimatedCost,
    super.actualCost,
    required super.createdAt,
    super.targetDate,
    super.completedAt,
    super.approvedBy,
    super.location,
    super.beforePhotoUrl,
    super.afterPhotoUrl,
  });

  factory WorkOrderModel.fromJson(Map<String, dynamic> json) {
    return WorkOrderModel(
      id: json['id'] ?? '',
      workOrderNumber: json['work_order_number'] ?? 'WO-${DateTime.now().year}',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? 'General',
      priority: _parsePriority(json['priority']),
      status: _parseStatus(json['status']),
      vendorName: json['vendor_name'] ?? 'Unassigned',
      vendorPhone: json['vendor_phone'] ?? '',
      estimatedCost: (json['estimated_cost'] as num?)?.toDouble() ?? 0.0,
      actualCost: (json['actual_cost'] as num?)?.toDouble(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      targetDate: json['target_date'] != null
          ? DateTime.tryParse(json['target_date'])
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.tryParse(json['completed_at'])
          : null,
      approvedBy: json['approved_by'],
      location: json['location'],
      beforePhotoUrl: json['before_photo_url'],
      afterPhotoUrl: json['after_photo_url'],
    );
  }

  static WorkOrderPriority _parsePriority(dynamic priority) {
    final p = priority?.toString().toLowerCase() ?? '';
    if (p == 'urgent') return WorkOrderPriority.urgent;
    if (p == 'high') return WorkOrderPriority.high;
    if (p == 'low') return WorkOrderPriority.low;
    return WorkOrderPriority.medium;
  }

  static WorkOrderStatus _parseStatus(dynamic status) {
    final s = status?.toString().toLowerCase() ?? '';
    if (s.contains('pending') || s.contains('approval')) {
      return WorkOrderStatus.pendingApproval;
    }
    if (s.contains('progress')) return WorkOrderStatus.inProgress;
    if (s.contains('completed') || s.contains('done')) {
      return WorkOrderStatus.completed;
    }
    if (s.contains('rejected')) return WorkOrderStatus.rejected;
    return WorkOrderStatus.assigned;
  }
}
