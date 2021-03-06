import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:odds_league/src/custom_drawer.dart';
import 'package:odds_league/src/home/game_list_item.dart';

import '../../custom_icons.dart';
import '../../custom_theme.dart';
import 'bloc/game_bloc.dart';
import 'data/models/game.dart';
import 'home_view_param.dart';

class HomeView extends StatefulWidget {
  final HomeViewParam homeViewParam;

  const HomeView({Key? key, required this.homeViewParam}) : super(key: key);

  static const routeName = '/';

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final PagingController<int, Game> _pagingController;

  @override
  void initState() {
    super.initState();
    _pagingController = PagingController<int, Game>(firstPageKey: 1);
    _pagingController.addPageRequestListener(_getPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(
              CustomIcons.burger,
              size: 16,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            splashRadius: 32.0,
          );
        }),
        backgroundColor: Colors.black,
        actions: [
          if (widget.homeViewParam.isTopOdds)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: const [
                  Text('Top odds'),
                  SizedBox(
                    width: 8.0,
                  ),
                  Icon(
                    CustomIcons.fire,
                    color: CustomColors.primaryColor,
                  )
                ],
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocListener<GameBloc, GameState>(
          listener: (context, state) {
            final finishedLoading = state.status == LoadingStatus.success ||
                state.status == LoadingStatus.failure;
            if (finishedLoading) {
              _pagingController.value = PagingState(
                error: state.error,
                nextPageKey: state.nextPage,
                itemList: state.games.isNotEmpty ? state.games : null,
              );
            }
          },
          child: PagedListView<int, Game>.separated(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate(
              itemBuilder: (_, item, i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GameListItem(game: item),
              ),
            ),
            separatorBuilder: (_, i) => const SizedBox(
              height: 4.0,
            ),
          ),
        ),
      ),
      drawer: const CustomDrawer(),
    );
  }

  void _getPage(pageKey) {
    context.read<GameBloc>().add(
          GetGamesRequested(
            page: pageKey,
            isTopOdds: widget.homeViewParam.isTopOdds,
          ),
        );
  }
}
