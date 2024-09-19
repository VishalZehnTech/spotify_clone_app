part of 'home_bloc.dart';

// HomeState represents the state of the HomeBloc.
// It contains the current page index and a map of music models categorized by different keys.
class HomeState extends Equatable {
  final int homePageIndex; // Index of the current page in the home screen's navigation bar.
  final Map<String, List<MusicModel?>?> musicModel; // Map holding categorized music models.

  // Constructor with named parameters.
  // Defaults `homePageIndex` to 0 and requires a `musicModel`.
  const HomeState({
    this.homePageIndex = 0,
    required this.musicModel,
  });

  // copyWith method allows creating a new instance of HomeState with modified properties.
  // If a property is not provided, it falls back to the current state's value.
  HomeState copyWith({
    int? homePageIndex,
    Map<String, List<MusicModel?>?>? musicModel,
  }) {
    return HomeState(
      homePageIndex: homePageIndex ?? this.homePageIndex,
      musicModel: musicModel ?? this.musicModel,
    );
  }

  @override
  // Equatable props to compare HomeState instances.
  // Includes `homePageIndex` and `musicModel`.
  List<Object?> get props => [homePageIndex, musicModel];
}
