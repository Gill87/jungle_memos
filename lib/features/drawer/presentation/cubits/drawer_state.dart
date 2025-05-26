abstract class DrawerState {}

class DrawerInitial extends DrawerState {}

class DrawerLoading extends DrawerState {}

class DrawerLoaded extends DrawerState {
  final String profileImageUrl;
  DrawerLoaded(this.profileImageUrl);
}

class DrawerError extends DrawerState {}