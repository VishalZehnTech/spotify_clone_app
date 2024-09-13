part of 'home_bloc.dart';

class HomeState extends Equatable {
  final int homePageIndex;
  final Map<String, List<MusicModel?>?> musicModel;

  const HomeState({
    this.homePageIndex = 0,
    required this.musicModel,
  });

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
  List<Object?> get props => [homePageIndex, musicModel];
}
