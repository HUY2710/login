part of '../chat_screen.dart';

class InputSearch extends StatelessWidget {
  const InputSearch({super.key, required this.textController});

  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchGroupCubit, List<StoreGroup>>(
      builder: (context, state) {
        return TextField(
          controller: textController,
          onChanged: (value) {
            // context.read<GroupCubit>().searchGroup(value);
            context
                .read<SearchGroupCubit>()
                .searchGroup(value, getIt<GroupCubit>().myGroups);
          },
          onSubmitted: (value) {
            context
                .read<SearchGroupCubit>()
                .searchGroup(value, getIt<GroupCubit>().myGroups);
          },
          decoration: InputDecoration(
              fillColor: const Color(0xffEFEFEF),
              filled: true,
              hintText: context.l10n.search,
              hintStyle: TextStyle(
                color: const Color(0xff928989),
                fontSize: 16.sp,
              ),
              prefixIcon: Icon(
                Icons.search,
                size: 24.r,
                color: const Color(0xff928989),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12.sp)),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 8.r, horizontal: 12.r)),
        );
      },
    );
  }
}
