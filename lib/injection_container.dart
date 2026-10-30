import 'package:get_it/get_it.dart';
import 'core/network/api_client.dart';
import 'core/storage/secure_storage_service.dart';
import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/get_current_user_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/domain/usecases/select_society_role_usecase.dart';
import 'features/auth/domain/usecases/send_otp_usecase.dart';
import 'features/auth/domain/usecases/verify_otp_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/maintenance/data/datasources/maintenance_remote_data_source.dart';
import 'features/maintenance/data/repositories/maintenance_repository_impl.dart';
import 'features/maintenance/domain/repositories/maintenance_repository.dart';
import 'features/maintenance/domain/usecases/get_maintenance_dues_data_usecase.dart';
import 'features/maintenance/domain/usecases/send_payment_reminder_usecase.dart';
import 'features/maintenance/presentation/bloc/maintenance_bloc.dart';
import 'features/notice/data/datasources/notice_remote_data_source.dart';
import 'features/notice/data/repositories/notice_repository_impl.dart';
import 'features/notice/domain/repositories/notice_repository.dart';
import 'features/notice/domain/usecases/get_notices_usecase.dart';
import 'features/notice/domain/usecases/publish_notice_usecase.dart';
import 'features/notice/presentation/bloc/notice_bloc.dart';
import 'features/work_order/data/datasources/work_order_remote_data_source.dart';
import 'features/work_order/data/repositories/work_order_repository_impl.dart';
import 'features/work_order/domain/repositories/work_order_repository.dart';
import 'features/work_order/domain/usecases/approve_work_order_usecase.dart';
import 'features/work_order/domain/usecases/get_work_orders_usecase.dart';
import 'features/work_order/presentation/bloc/work_order_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // 1. Core Services & Storage
  sl.registerLazySingleton<SecureStorageService>(() => SecureStorageService());
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(storageService: sl<SecureStorageService>()),
  );

  // 2. Data Sources
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(storageService: sl<SecureStorageService>()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );
  sl.registerLazySingleton<MaintenanceRemoteDataSource>(
    () => MaintenanceRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );
  sl.registerLazySingleton<WorkOrderRemoteDataSource>(
    () => WorkOrderRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );
  sl.registerLazySingleton<NoticeRemoteDataSource>(
    () => NoticeRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );

  // 3. Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      localDataSource: sl<AuthLocalDataSource>(),
    ),
  );
  sl.registerLazySingleton<MaintenanceRepository>(
    () => MaintenanceRepositoryImpl(
      remoteDataSource: sl<MaintenanceRemoteDataSource>(),
    ),
  );
  sl.registerLazySingleton<WorkOrderRepository>(
    () => WorkOrderRepositoryImpl(
      remoteDataSource: sl<WorkOrderRemoteDataSource>(),
    ),
  );
  sl.registerLazySingleton<NoticeRepository>(
    () => NoticeRepositoryImpl(
      remoteDataSource: sl<NoticeRemoteDataSource>(),
    ),
  );

  // 4. Use Cases
  sl.registerLazySingleton(() => SendOtpUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SelectSocietyRoleUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => LogoutUseCase(sl<AuthRepository>()));

  sl.registerLazySingleton(
    () => GetMaintenanceDuesDataUseCase(sl<MaintenanceRepository>()),
  );
  sl.registerLazySingleton(
    () => SendPaymentReminderUseCase(sl<MaintenanceRepository>()),
  );

  sl.registerLazySingleton(
    () => GetWorkOrdersUseCase(sl<WorkOrderRepository>()),
  );
  sl.registerLazySingleton(
    () => ApproveWorkOrderUseCase(sl<WorkOrderRepository>()),
  );

  sl.registerLazySingleton(
    () => GetNoticesUseCase(sl<NoticeRepository>()),
  );
  sl.registerLazySingleton(
    () => PublishNoticeUseCase(sl<NoticeRepository>()),
  );

  // 5. Blocs
  sl.registerFactory(
    () => AuthBloc(
      sendOtpUseCase: sl<SendOtpUseCase>(),
      verifyOtpUseCase: sl<VerifyOtpUseCase>(),
      selectSocietyRoleUseCase: sl<SelectSocietyRoleUseCase>(),
      getCurrentUserUseCase: sl<GetCurrentUserUseCase>(),
      logoutUseCase: sl<LogoutUseCase>(),
    ),
  );

  sl.registerFactory(
    () => MaintenanceBloc(
      getMaintenanceDuesDataUseCase: sl<GetMaintenanceDuesDataUseCase>(),
      sendPaymentReminderUseCase: sl<SendPaymentReminderUseCase>(),
    ),
  );

  sl.registerFactory(
    () => WorkOrderBloc(
      getWorkOrdersUseCase: sl<GetWorkOrdersUseCase>(),
      approveWorkOrderUseCase: sl<ApproveWorkOrderUseCase>(),
    ),
  );

  sl.registerFactory(
    () => NoticeBloc(
      getNoticesUseCase: sl<GetNoticesUseCase>(),
      publishNoticeUseCase: sl<PublishNoticeUseCase>(),
    ),
  );
}
