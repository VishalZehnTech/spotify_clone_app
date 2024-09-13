part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class GetNavBarIndex extends HomeEvent {
  final int homePageIndex;
  const GetNavBarIndex({required this.homePageIndex});

  @override
  List<Object> get props => [homePageIndex];
}

class GetSongDetails extends HomeEvent {}

class AddSongFavorite extends HomeEvent {}
