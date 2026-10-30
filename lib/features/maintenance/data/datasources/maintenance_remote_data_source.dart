import '../../../../core/network/api_client.dart';
import '../../domain/entities/maintenance_member_entity.dart';
import '../models/defaulter_member_model.dart';
import '../models/maintenance_member_model.dart';
import '../models/monthly_maintenance_summary_model.dart';

abstract class MaintenanceRemoteDataSource {
  Future<MonthlyMaintenanceSummaryModel> getMonthlySummary({
    required String societyId,
    required int month,
    required int year,
  });

  Future<List<MaintenanceMemberModel>> getMonthlyRecords({
    required String societyId,
    required int month,
    required int year,
  });

  Future<List<DefaulterMemberModel>> getDefaultersList({
    required String societyId,
  });

  Future<bool> sendPaymentReminder({
    required String memberId,
    required String phoneNumber,
  });
}

class MaintenanceRemoteDataSourceImpl implements MaintenanceRemoteDataSource {
  final ApiClient apiClient;

  MaintenanceRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<MonthlyMaintenanceSummaryModel> getMonthlySummary({
    required String societyId,
    required int month,
    required int year,
  }) async {
    // In production, calls: await apiClient.get('/societies/$societyId/maintenance/summary?month=$month&year=$year')
    // Realistic dataset simulation:
    return MonthlyMaintenanceSummaryModel(
      month: month,
      year: year,
      totalUnits: 40,
      paidUnitsCount: 31,
      pendingUnitsCount: 9,
      totalBilledAmount: 130000.0,
      totalCollectedAmount: 100750.0,
      totalPendingAmount: 29250.0,
      criticalDefaultersCount: 4,
    );
  }

  @override
  Future<List<MaintenanceMemberModel>> getMonthlyRecords({
    required String societyId,
    required int month,
    required int year,
  }) async {
    return [
      // Paid Members
      const MaintenanceMemberModel(
        id: 'rec_01',
        unitNumber: 'A-101',
        wing: 'Wing A',
        ownerName: 'Rajesh Sharma',
        phoneNumber: '9876543210',
        billedAmount: 3250.0,
        paidAmount: 3250.0,
        status: MaintenancePaymentStatus.paid,
        paymentDate: null,
        paymentMode: 'UPI (GPay)',
        receiptNumber: 'REC-2026-1001',
      ),
      const MaintenanceMemberModel(
        id: 'rec_02',
        unitNumber: 'A-102',
        wing: 'Wing A',
        ownerName: 'Pooja Iyer',
        phoneNumber: '9822011223',
        billedAmount: 3250.0,
        paidAmount: 3250.0,
        status: MaintenancePaymentStatus.paid,
        paymentDate: null,
        paymentMode: 'Net Banking (HDFC)',
        receiptNumber: 'REC-2026-1002',
      ),
      const MaintenanceMemberModel(
        id: 'rec_03',
        unitNumber: 'A-201',
        wing: 'Wing A',
        ownerName: 'Manoj Joshi',
        phoneNumber: '9823344556',
        billedAmount: 3250.0,
        paidAmount: 3250.0,
        status: MaintenancePaymentStatus.paid,
        paymentDate: null,
        paymentMode: 'Cheque (#40219)',
        receiptNumber: 'REC-2026-1003',
      ),
      const MaintenanceMemberModel(
        id: 'rec_04',
        unitNumber: 'B-101',
        wing: 'Wing B',
        ownerName: 'Girish Kadam',
        phoneNumber: '9867012345',
        billedAmount: 3250.0,
        paidAmount: 3250.0,
        status: MaintenancePaymentStatus.paid,
        paymentDate: null,
        paymentMode: 'UPI (PhonePe)',
        receiptNumber: 'REC-2026-1004',
      ),
      const MaintenanceMemberModel(
        id: 'rec_05',
        unitNumber: 'B-102',
        wing: 'Wing B',
        ownerName: 'Sneha More',
        phoneNumber: '9890123456',
        billedAmount: 3250.0,
        paidAmount: 3250.0,
        status: MaintenancePaymentStatus.paid,
        paymentDate: null,
        paymentMode: 'UPI (Paytm)',
        receiptNumber: 'REC-2026-1005',
      ),

      // Remaining / Pending Members for this month
      const MaintenanceMemberModel(
        id: 'rec_06',
        unitNumber: 'A-301',
        wing: 'Wing A',
        ownerName: 'Nitin Sawant',
        phoneNumber: '9819988776',
        billedAmount: 3250.0,
        paidAmount: 0.0,
        status: MaintenancePaymentStatus.pending,
      ),
      const MaintenanceMemberModel(
        id: 'rec_07',
        unitNumber: 'B-201',
        wing: 'Wing B',
        ownerName: 'Anil Jadhav',
        phoneNumber: '9845566778',
        billedAmount: 3250.0,
        paidAmount: 0.0,
        status: MaintenancePaymentStatus.pending,
      ),
      const MaintenanceMemberModel(
        id: 'rec_08',
        unitNumber: 'A-304',
        wing: 'Wing A',
        ownerName: 'Sunita Verma',
        phoneNumber: '9892345678',
        billedAmount: 3250.0,
        paidAmount: 0.0,
        status: MaintenancePaymentStatus.pending,
      ),
      const MaintenanceMemberModel(
        id: 'rec_09',
        unitNumber: 'B-202',
        wing: 'Wing B',
        ownerName: 'Vikram Deshmukh',
        phoneNumber: '9820099881',
        billedAmount: 3250.0,
        paidAmount: 0.0,
        status: MaintenancePaymentStatus.pending,
      ),
      const MaintenanceMemberModel(
        id: 'rec_10',
        unitNumber: 'A-501',
        wing: 'Wing A',
        ownerName: 'Sandeep Patil',
        phoneNumber: '9769123450',
        billedAmount: 3250.0,
        paidAmount: 0.0,
        status: MaintenancePaymentStatus.pending,
      ),
    ];
  }

  @override
  Future<List<DefaulterMemberModel>> getDefaultersList({
    required String societyId,
  }) async {
    return [
      const DefaulterMemberModel(
        id: 'def_01',
        unitNumber: 'A-501',
        wing: 'Wing A',
        ownerName: 'Sandeep Patil',
        phoneNumber: '9769123450',
        unpaidMonthsCount: 5,
        unpaidMonths: ['Jun 2026', 'Jul 2026', 'Aug 2026', 'Sep 2026', 'Oct 2026'],
        principalDue: 16250.0,
        interestPenalty: 2430.0,
        totalDue: 18680.0,
      ),
      const DefaulterMemberModel(
        id: 'def_02',
        unitNumber: 'A-304',
        wing: 'Wing A',
        ownerName: 'Sunita Verma',
        phoneNumber: '9892345678',
        unpaidMonthsCount: 4,
        unpaidMonths: ['Jul 2026', 'Aug 2026', 'Sep 2026', 'Oct 2026'],
        principalDue: 13000.0,
        interestPenalty: 1560.0,
        totalDue: 14560.0,
      ),
      const DefaulterMemberModel(
        id: 'def_03',
        unitNumber: 'B-202',
        wing: 'Wing B',
        ownerName: 'Vikram Deshmukh',
        phoneNumber: '9820099881',
        unpaidMonthsCount: 3,
        unpaidMonths: ['Aug 2026', 'Sep 2026', 'Oct 2026'],
        principalDue: 9750.0,
        interestPenalty: 975.0,
        totalDue: 10725.0,
      ),
      const DefaulterMemberModel(
        id: 'def_04',
        unitNumber: 'B-405',
        wing: 'Wing B',
        ownerName: 'Amit Kulkarni',
        phoneNumber: '9833445566',
        unpaidMonthsCount: 3,
        unpaidMonths: ['Aug 2026', 'Sep 2026', 'Oct 2026'],
        principalDue: 9750.0,
        interestPenalty: 975.0,
        totalDue: 10725.0,
      ),
    ];
  }

  @override
  Future<bool> sendPaymentReminder({
    required String memberId,
    required String phoneNumber,
  }) async {
    return true;
  }
}
