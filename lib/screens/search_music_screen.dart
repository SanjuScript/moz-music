import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../PROVIDER/search_screen_provider.dart';
import '../Widgets/song_list_maker.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin {
  bool shouldAutofocus = true;
  late SearchScreenProvider searchProvider;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    searchProvider = Provider.of<SearchScreenProvider>(context, listen: false);
    searchProvider.fetchAllSongs();
  }

  Widget? getListView() {
    final foundSongs = searchProvider.foundSongs;
    if (foundSongs.isNotEmpty) {
      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.0010),
        itemBuilder: (context, index) {
          return songDisplay(
            context,
            song: foundSongs[index],
            songs: foundSongs,
            index: index,
          );
        },
        itemCount: foundSongs.length,
      );
    } else {
      return const Center(
        child: Text.rich(
          TextSpan(text: "NO SEARCH FOUND"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: MediaQuery.of(context).size.height * 0.08,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        title: SizedBox(
          width: MediaQuery.of(context).size.width * 0.88,
          child: TextField(
            autofocus: shouldAutofocus,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).cardColor),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1),
              filled: true,
              fillColor:
                  Theme.of(context).colorScheme.inversePrimary.withOpacity(.3),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none),
              hintText: 'Artists, songs, or albums',
              hintStyle: TextStyle(
                color: Theme.of(context).cardColor,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Theme.of(context).cardColor,
              ),
            ),
            onChanged: (value) {
              setState(() {
                shouldAutofocus = false;
              });
              searchProvider.filterSongs(value);
            },
          ),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Consumer<SearchScreenProvider>(
        builder: (context, provider, _) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 700),
            child: getListView() ?? const SizedBox(),
          );
        },
      ),
    );
  }
}
