import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jungle_memos/features/drawer/domain/drawer_repo.dart';
import 'package:jungle_memos/features/drawer/presentation/cubits/drawer_state.dart';

class DrawerCubit extends Cubit<DrawerState>{
  final DrawerRepo drawerRepo;
   
  DrawerCubit({
    required this.drawerRepo
  }) : super(DrawerInitial());

  Future <void> fetchProfilePictureUrl(String uid) async {
    try {
      emit(DrawerLoading());
            
      // Check if it exists
      String? profileImageUrl = await drawerRepo.getProfilePicture(uid);

      // Emit loaded with either "" or the url
      if(profileImageUrl != "null" && profileImageUrl != null){
        emit(DrawerLoaded(profileImageUrl));
      } else {
        emit(DrawerLoaded(""));
      }

    } catch(e){
      emit(DrawerError());
    }
  }
}