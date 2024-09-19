part of 'home_bloc.dart';

// Abstract class representing events related to HomeBloc.
// All events extending HomeEvent must override the `props` getter.
abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

// Event to update the navigation bar index in the home screen.
// Takes an integer `homePageIndex` to determine the current page.
class GetNavBarIndex extends HomeEvent {
  final int homePageIndex;
  const GetNavBarIndex({required this.homePageIndex});

  @override
  List<Object> get props => [homePageIndex];
}

// Event to trigger fetching of song details.
// This event does not carry any additional data.
class GetSongDetails extends HomeEvent {}

// Event to add a song to the user's favorites.
// This event does not carry any additional data. (Implementation to be defined in the bloc)
class AddSongFavorite extends HomeEvent {}
