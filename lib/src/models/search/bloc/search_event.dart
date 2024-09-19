part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchSongs extends SearchEvent {
  final String songName;
  const SearchSongs({required this.songName});
  @override
  List<Object> get props => [];
}

class ClearSearch extends SearchEvent {}
