import '../../../../core/network/api_client.dart';
import '../../domain/entities/work_order_entity.dart';
import '../models/work_order_model.dart';

abstract class WorkOrderRemoteDataSource {
  Future<List<WorkOrderModel>> getWorkOrders({
    required String societyId,
    WorkOrderStatus? statusFilter,
  });

  Future<WorkOrderModel> approveWorkOrder({
    required String workOrderId,
    required String approverName,
  });

  Future<WorkOrderModel> createWorkOrder({
    required String societyId,
    required WorkOrderEntity workOrder,
  });
}

class WorkOrderRemoteDataSourceImpl implements WorkOrderRemoteDataSource {
  final ApiClient apiClient;

  // Local state cache to simulate live approvals in demo mode
  final List<WorkOrderModel> _cachedWorkOrders = [
    WorkOrderModel(
      id: 'wo_01',
      workOrderNumber: 'WO-2026-104',
      title: 'Tower 1 Lift #1 Traction Motor Bearing Replacement',
      description:
          'Abnormal grinding noise reported from traction motor bearing. Elevator technician inspected and advised immediate replacement of bearing assembly and lubrication.',
      category: 'Elevator & Safety',
      priority: WorkOrderPriority.urgent,
      status: WorkOrderStatus.inProgress,
      vendorName: 'Otis Elevator Services Pvt Ltd',
      vendorPhone: '9822019900',
      estimatedCost: 14500.0,
      createdAt: DateTime(2026, 10, 28, 11, 30),
      targetDate: DateTime(2026, 11, 2),
      location: 'Tower 1 - Lift Shaft #1 Machine Room',
      approvedBy: 'Sachiv (Secretary)',
    ),
    WorkOrderModel(
      id: 'wo_02',
      workOrderNumber: 'WO-2026-103',
      title: 'Main Borewell 5HP Submersible Pump Rewinding & Starter Coil',
      description:
          'Submersible pump tripping on thermal overload relay. Coil burn identified. Rewinding and replacement of 3-phase starter capacitor required.',
      category: 'Water Infrastructure',
      priority: WorkOrderPriority.urgent,
      status: WorkOrderStatus.pendingApproval,
      vendorName: 'Shree Samarth Electricals & Pumps',
      vendorPhone: '9823456789',
      estimatedCost: 8800.0,
      createdAt: DateTime(2026, 10, 29, 9, 15),
      targetDate: DateTime(2026, 10, 31),
      location: 'Pump Room behind Wing A',
    ),
    WorkOrderModel(
      id: 'wo_03',
      workOrderNumber: 'WO-2026-102',
      title: 'Terrace Overhead Water Tank Leakage Sealing & Epoxy Coating',
      description:
          'Micro-cracks in Wing A overhead concrete tank causing seepage in top floor flats A-401 and A-402. Requires polyurethane pressure grouting & food-grade epoxy.',
      category: 'Civil Maintenance',
      priority: WorkOrderPriority.high,
      status: WorkOrderStatus.pendingApproval,
      vendorName: 'Riddhi Siddhi Waterproofing Works',
      vendorPhone: '9867001122',
      estimatedCost: 24000.0,
      createdAt: DateTime(2026, 10, 27, 16, 45),
      targetDate: DateTime(2026, 11, 5),
      location: 'Wing A Terrace Overhead Tank',
    ),
    WorkOrderModel(
      id: 'wo_04',
      workOrderNumber: 'WO-2026-101',
      title: 'Common Corridor & Staircase LED Retrofit with Motion Sensors',
      description:
          'Replacing legacy 36W tube lights with 12W radar microwave motion sensor LEDs across 5 floors to reduce society common electricity bills.',
      category: 'Electrical',
      priority: WorkOrderPriority.medium,
      status: WorkOrderStatus.assigned,
      vendorName: 'Bright Spark Electrical Solutions',
      vendorPhone: '9845112233',
      estimatedCost: 18500.0,
      createdAt: DateTime(2026, 10, 25, 14, 0),
      targetDate: DateTime(2026, 11, 4),
      location: 'Wing A & Wing B - Common Corridors',
      approvedBy: 'Adhyaksha (Rajesh Sharma)',
    ),
    WorkOrderModel(
      id: 'wo_05',
      workOrderNumber: 'WO-2026-098',
      title: 'Main Security Boom Barrier Sensor & 4K ANPR Camera Repair',
      description:
          'Optical sensor misalignment in automated boom barrier and power supply surge on the license plate camera repaired and recalibrated.',
      category: 'Security & Automation',
      priority: WorkOrderPriority.high,
      status: WorkOrderStatus.completed,
      vendorName: 'SecureVision CCTV & Automation',
      vendorPhone: '9890123999',
      estimatedCost: 12000.0,
      actualCost: 11500.0,
      createdAt: DateTime(2026, 10, 20, 10, 0),
      completedAt: DateTime(2026, 10, 26, 17, 30),
      approvedBy: 'Adhyaksha & Sachiv',
      location: 'Main Security Entrance Gate #1',
    ),
  ];

  WorkOrderRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<WorkOrderModel>> getWorkOrders({
    required String societyId,
    WorkOrderStatus? statusFilter,
  }) async {
    // In production: calls apiClient.get('/societies/$societyId/work-orders')
    if (statusFilter != null) {
      return _cachedWorkOrders.where((w) => w.status == statusFilter).toList();
    }
    return List.from(_cachedWorkOrders);
  }

  @override
  Future<WorkOrderModel> approveWorkOrder({
    required String workOrderId,
    required String approverName,
  }) async {
    final index = _cachedWorkOrders.indexWhere((w) => w.id == workOrderId);
    if (index != -1) {
      final old = _cachedWorkOrders[index];
      final updated = WorkOrderModel(
        id: old.id,
        workOrderNumber: old.workOrderNumber,
        title: old.title,
        description: old.description,
        category: old.category,
        priority: old.priority,
        status: WorkOrderStatus.inProgress, // Approved & moved to active progress
        vendorName: old.vendorName,
        vendorPhone: old.vendorPhone,
        estimatedCost: old.estimatedCost,
        actualCost: old.actualCost,
        createdAt: old.createdAt,
        targetDate: old.targetDate,
        completedAt: old.completedAt,
        approvedBy: approverName,
        location: old.location,
        beforePhotoUrl: old.beforePhotoUrl,
        afterPhotoUrl: old.afterPhotoUrl,
      );
      _cachedWorkOrders[index] = updated;
      return updated;
    }
    throw Exception('Work order not found');
  }

  @override
  Future<WorkOrderModel> createWorkOrder({
    required String societyId,
    required WorkOrderEntity workOrder,
  }) async {
    final model = WorkOrderModel(
      id: 'wo_${DateTime.now().millisecondsSinceEpoch}',
      workOrderNumber: 'WO-2026-${_cachedWorkOrders.length + 105}',
      title: workOrder.title,
      description: workOrder.description,
      category: workOrder.category,
      priority: workOrder.priority,
      status: WorkOrderStatus.pendingApproval,
      vendorName: workOrder.vendorName,
      vendorPhone: workOrder.vendorPhone,
      estimatedCost: workOrder.estimatedCost,
      createdAt: DateTime.now(),
      targetDate: workOrder.targetDate,
      location: workOrder.location,
    );
    _cachedWorkOrders.insert(0, model);
    return model;
  }
}
