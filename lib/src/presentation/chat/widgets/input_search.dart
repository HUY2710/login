part of '../chat_screen.dart';

class InputSearch extends StatelessWidget {
  const InputSearch({super.key, required this.textController});

  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      decoration: InputDecoration(
          fillColor: const Color(0xffEFEFEF),
          filled: true,
          hintText: 'Search',
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
  }
}
