import 'package:flutter/material.dart';
import '../../HELPER/sort_enum.dart';

class SortOptionBottomSheet extends StatelessWidget {
  final SortOption selectedOption;
  final ValueChanged<SortOption> onSelected;

  const SortOptionBottomSheet({
    Key? key,
    required this.selectedOption,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Scrollbar(
        interactive: true,
        radius: const Radius.circular(20),
        thickness: 10,
        child: ListView.builder(
          itemCount: SortOption.values.length,
          itemBuilder: (context, index) {
            final option = SortOption.values[index];
            final title = _getTitleForSortOption(option);
            return ListTile(
              title: buildListTileTitle(context, option, title),
              onTap: () {
                onSelected(option);
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
    );
  }

  String _getTitleForSortOption(SortOption option) {
    switch (option) {
      case SortOption.atitle:
        return "Name A-z";
      case SortOption.ztitle:
        return "Name Z-a";
      case SortOption.aartist:
        return "Artist A-z";
      case SortOption.zartist:
        return "Artist Z-a";
      case SortOption.aduration:
        return "Smallest Duration";
      case SortOption.zduaration:
        return "Largest Duration";
      case SortOption.adate:
        return "Newest Date First";
      case SortOption.zdate:
        return "Oldest Date First";
      case SortOption.afileSize:
        return "Largest File First";
      case SortOption.zfileSize:
        return "Smallest File First";
    }
  }

  Text buildListTileTitle(
      BuildContext context, SortOption option, String title) {
    final isSelected = selectedOption == option;
    final textStyle = TextStyle(
      letterSpacing: 2,
      fontFamily: 'coolvetica',
      color: isSelected ? Colors.green : Theme.of(context).cardColor,
      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
    );
    return Text(
      title.toUpperCase(),
      style: textStyle,
    );
  }
}
