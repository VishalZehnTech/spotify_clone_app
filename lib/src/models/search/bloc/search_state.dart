part of 'search_bloc.dart';

class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<MusicModel> musicModels;

  const SearchLoaded(this.musicModels);

  @override
  List<Object> get props => [musicModels];
}

class SearchError extends SearchState {
  final String error;

  const SearchError(this.error);

  @override
  List<Object> get props => [error];
}
