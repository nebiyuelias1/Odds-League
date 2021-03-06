part of 'game_bloc.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();
}

class GetGamesRequested extends GameEvent {
  final int page;
  final bool isTopOdds;

  const GetGamesRequested({
    required this.page,
    required this.isTopOdds,
  });

  @override
  List<Object?> get props => [
        page,
        isTopOdds,
      ];
}

class DateSet extends GameEvent {
  final DateTime date;

  const DateSet(this.date);

  @override
  List<Object?> get props => [date];
}

class AddedToFavourite extends GameEvent {
  final String gameId;
  final OddOption option;

  const AddedToFavourite({required this.gameId, required this.option});

  @override
  List<Object> get props => [gameId, option];
}

class RemovedFromFavourite extends GameEvent {
  final String gameId;

  const RemovedFromFavourite({required this.gameId});

  @override
  List<Object> get props => [gameId];
}

class ResetState extends GameEvent {
  @override
  List<Object> get props => [];
}
