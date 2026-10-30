import 'package:equatable/equatable.dart';

enum WorkOrderStatus {
  pendingApproval,
  assigned,
  inProgress,
  completed,
  rejected,
}

extension WorkOrderStatusExtension on WorkOrderStatus {
  String get displayName {
    switch (this) {
      case WorkOrderStatus.pendingApproval:
        return 'Pending Approval';
      case WorkOrderStatus.assigned:
        return 'Vendor Assigned';
      case WorkOrderStatus.inProgress:
        return 'In Progress';
      case WorkOrderStatus.completed:
        return 'Completed';
      case WorkOrderStatus.rejected:
        return 'Rejected';
    }
  }
}

enum WorkOrderPriority { low, medium, high, urgent }

extension WorkOrderPriorityExtension on WorkOrderPriority {
  String get displayName {
    switch (this) {
      case WorkOrderPriority.low:
        return 'Low';
      case WorkOrderPriority.medium:
        return 'Medium';
      case WorkOrderPriority.high:
        return 'High';
      case WorkOrderPriority.urgent:
        return 'Urgent';
    }
  }
}

class WorkOrderEntity extends Equatable {
  final String id;
  final String workOrderNumber; // e.g. 'WO-2026-104'
  final String title;
  final String description;
  final String category; // Elevator, Plumbing, Electrical, Civil, Security
  final WorkOrderPriority priority;
  final WorkOrderStatus status;
  final String vendorName;
  final String vendorPhone;
  final double estimatedCost;
  final double? actualCost;
  final DateTime createdAt;
  final DateTime? targetDate;
  final DateTime? completedAt;
  final String? approvedBy; // e.g. 'Adhyaksha (Rajesh Sharma)'
  final String? location;   // e.g. 'Wing A - Lift Shaft #2'
  final String? beforePhotoUrl;
  final String? afterPhotoUrl;

  const WorkOrderEntity({
    required this.id,
    required this.workOrderNumber,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.status,
    required this.vendorName,
    required this.vendorPhone,
    required this.estimatedCost,
    this.actualCost,
    required this.createdAt,
    this.targetDate,
    this.completedAt,
    this.approvedBy,
    this.location,
    this.beforePhotoUrl,
    this.afterPhotoUrl,
  });

  @override
  List<Object?> get props => [
        id,
        workOrderNumber,
        title,
        description,
        category,
        priority,
        status,
        vendorName,
        vendorPhone,
        estimatedCost,
        actualCost,
        createdAt,
        targetDate,
        completedAt,
        approvedBy,
        location,
        beforePhotoUrl,
        afterPhotoUrl,
      ];
}
