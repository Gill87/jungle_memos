/*

Auth Cubit: State Management

*/

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jungle_memos/features/auth/domain/entities/app_user.dart';
import 'package:jungle_memos/features/auth/domain/repos/auth_repo.dart';
import 'package:jungle_memos/features/auth/presentation/cubits/auth_states.dart';

class AuthCubit extends Cubit<AuthState>{
  final AuthRepo authRepo;
  AppUser? _currentUser;
  
  AuthCubit({required this.authRepo}) : super(AuthInitial());

  // Check if user is already authenticated
  void checkAuth() async {
    final AppUser? user = await authRepo.getCurrentUser();

    if(user != null){
      _currentUser = user;
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated());
    }
  }

  // get current user
  AppUser? get currentUser => _currentUser;

  // login with email and password
  Future <void> login(String email, String password) async {
    try{
      emit(AuthLoading());
      final user = await authRepo.loginWithEmailPassword(email, password);
      if(user != null){
        _currentUser = user;
        emit(Authenticated(user));
        print("Current state in cubit: $state");
      } else {
        emit(Unauthenticated());
      }
    } catch (e){
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }

  // register with email and password
  Future <void> register(String email, String password, String name) async {
      try{

      emit(AuthLoading());
      final user = await authRepo.registerWithEmailPassword(name, email, password);

      if(user != null){
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }

    } catch (e){
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }

  // logout
  Future <void> logout() async {
    authRepo.logout();
    emit(Unauthenticated());
    print("Current state in cubit: $state");
    print("logging out");
  }
  
}