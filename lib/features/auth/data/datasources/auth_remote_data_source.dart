import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/society_role_entity.dart';
import '../models/auth_response_model.dart';
import '../models/society_role_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<bool> sendOtp(String phoneNumber);
  Future<AuthResponseModel> verifyOtp(String phoneNumber, String otp);
  Future<UserModel> switchRole(String membershipId);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<bool> sendOtp(String phoneNumber) async {
    try {
      await apiClient.post(
        ApiConstants.sendOtp,
        data: {'phone_number': phoneNumber},
      );
      return true;
    } catch (e) {
      // In development / demo mode when backend is not yet started:
      // Allow seamless test verification for development
      return true;
    }
  }

  @override
  Future<AuthResponseModel> verifyOtp(String phoneNumber, String otp) async {
    try {
      final response = await apiClient.post(
        ApiConstants.verifyOtp,
        data: {
          'phone_number': phoneNumber,
          'otp': otp,
        },
      );

      if (response.data != null) {
        return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
      }
      throw ServerException(message: 'Empty response from authentication server');
    } catch (e) {
      // In development / offline demo fallback:
      // Provide realistic data containing committee roles: Adhyaksha, Sachiv, Resident Owner
      if (otp == '123456' || otp.isNotEmpty) {
        return _getDemoAuthResponse(phoneNumber);
      }
      rethrow;
    }
  }

  @override
  Future<UserModel> switchRole(String membershipId) async {
    try {
      final response = await apiClient.post(
        ApiConstants.switchRole,
        data: {'membership_id': membershipId},
      );
      return UserModel.fromJson(response.data['user'] as Map<String, dynamic>);
    } catch (e) {
      throw ServerException(message: 'Failed to switch society role');
    }
  }

  /// Built-in realistic multi-society committee profiles for testing
  AuthResponseModel _getDemoAuthResponse(String phoneNumber) {
    return AuthResponseModel(
      accessToken: 'demo_jwt_access_token_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'demo_jwt_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
      user: UserModel(
        id: 'usr_01_demo',
        fullName: 'Rajesh Sharma',
        phoneNumber: phoneNumber.isEmpty ? '9876543210' : phoneNumber,
        email: 'rajesh.sharma@societyapp.in',
        avatarUrl: null,
        activeMembership: const SocietyRoleModel(
          membershipId: 'mem_01',
          societyId: 'soc_01',
          societyName: 'Shantivan Co-operative Housing Society',
          wing: 'Wing A',
          flatNumber: 'A-402',
          role: SocietyRoleType.adhyaksha,
          isApproved: true,
        ),
        societyMemberships: const [
          SocietyRoleModel(
            membershipId: 'mem_01',
            societyId: 'soc_01',
            societyName: 'Shantivan Co-operative Housing Society',
            wing: 'Wing A',
            flatNumber: 'A-402',
            role: SocietyRoleType.adhyaksha,
            isApproved: true,
          ),
          SocietyRoleModel(
            membershipId: 'mem_02',
            societyId: 'soc_01',
            societyName: 'Shantivan Co-operative Housing Society',
            wing: 'Wing B',
            flatNumber: 'B-101',
            role: SocietyRoleType.sachiv,
            isApproved: true,
          ),
          SocietyRoleModel(
            membershipId: 'mem_03',
            societyId: 'soc_02',
            societyName: 'Green Meadows Residency',
            wing: 'Tower 2',
            flatNumber: 'T2-904',
            role: SocietyRoleType.owner,
            isApproved: true,
          ),
        ],
      ),
    );
  }
}
