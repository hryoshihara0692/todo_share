import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_share/riverpod/selected_todolist.dart';

class TodoListCollection extends ConsumerWidget {
  const TodoListCollection({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var todoListCollection = [
      '買い物リスト',
      'やることリスト',
      '引っ越し',
      'TODOリスト',
      'お返しリスト',
      '電話帳',
      'おいしかったご飯'
    ];
    // var selectedTodoList = '買い物リスト';
    var selectedTodoList = ref.watch(selectedTodoListNotifierProvider);

    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: todoListCollection.length,
        itemBuilder: (context, index) {
          final todo = todoListCollection[index];
          final isSelected = todo == selectedTodoList;

          // todoListCollectionのTODOリストを順番に表示する
          return Container(
            // 左右のTODOリストと2x2で4開けて、上下は4開ける
            margin: EdgeInsets.fromLTRB(2.0, 4.0, 2.0, 4.0),
            child: isSelected
                ? ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      foregroundColor: Colors.white,
                      backgroundColor: Color.fromARGB(255, 15, 9, 64),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      todo,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: GoogleFonts.notoSansJp(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                          ),
                        ).fontFamily,
                      ),
                    ),
                  )
                : TextButton(
                    onPressed: () {
                      var notifier =
                          ref.read(selectedTodoListNotifierProvider.notifier);
                      notifier.update(todo);
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      foregroundColor: Color.fromARGB(255, 15, 9, 64),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      todo,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: GoogleFonts.notoSansJp(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                          ),
                        ).fontFamily,
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
