import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filroll_app/model/story_model.dart';
import 'package:filroll_app/providers/story.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story/story_page_view/story_page_view.dart';

class UserModel {
  UserModel(this.stories, this.userName, this.imageUrl);

  final List<String> stories;
  final String userName;
  final String imageUrl;
}

class StoryModel {
  StoryModel(this.imageUrl);

  final String imageUrl;
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  Future<String> getUrl(String key) async {
    try {
      final result = await Amplify.Storage.getUrl(
        key: key,
        options: GetUrlOptions(expires: 43200),
      );
      // setState(() {
      //   storyUrl = result.url;
      // });
      print(
          'https://filroll-storage-114584815-staging.s3.ap-south-1.amazonaws.com/public/storyImg-e0773cc0-b754-11ed-8e46-7dfbaf361408.jpg?response-content-disposition=inline&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEMT%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCmFwLXNvdXRoLTEiRjBEAiA6VmgZF0JENemhwFtK9FUHfW68j45LjV8gYmR3xLbHfAIgHZikIpnGtREuEh67EqU0zJzS2Ox8vqfKmiU148ETPi4q5AIIbRAAGgwxMDQwMDM5MzYyOTQiDIosyZSHJ7Q%2BB834QirBAgyRpddIrEyAeqUGmoC1K8v7nK%2FWhW%2BEboJOsAFMOEdRCrET03m3tlck5RiMxUfZLLB1Gfqyr2hRkADepzjMJRCrwmXvNQx48LkaSjXPi0wOF%2BayGAHoBgBhk5aUpj9Dv5VrbDDj54qfhHwSuWm17T2FzDUoW5%2BR6P2Hb0PrSFXqVWtEIiYqGqKFVOcrsiXisLdg50DMB%2FVveoC4K4xAfm455TIqtRT8P4JKWA7jIY7FyV4EJAh7I%2FGgTRicne%2B%2B9c49kdWb%2FuUtF2EiZ9HsAEAd2vQn2%2F1cofKqhiY8PQ1rxZeaCwFIS%2Fv0NQH9hcBW%2FFhRq16mNUE8MMM1%2Bg3u9grjI0Jpo%2F4fflXImGaiYZSijtXl0uaaL3ZViFp9AZXF2DvANMR5IDHNW4er2sKQ%2Bq7Dfvj18FJbQckJhDXZ01vPTjDM%2FvWfBjq0AlwkI%2F3zhCguPP3732FDRPn0PSvYIeYx%2FsPs3VxpFHkl1B1w%2BQxA2sCD29cVadq3jjmlxKs%2Bj%2BvHd98SmyFhke6DFc05qtRu0iHMO03mLdReArJnmsp2EQetc8Hn03mu7D9MiYJvFnrc3xH2M95xJIUaNB0ZtweR7csGXJS8fmRhW4c2Y%2B9gEUEtip8pQZ9sZQ%2B7VDjyA9nndUjON9jd8bnC4vv1fj36aCndbYYNYXSkjoVdbrBXwIKUUxPVB5l%2BTRCBjWtJWThy2px3JPmiWHcLOzpvyXeQCC3l5%2FEf3JNWmyN1Jdi0zeMNTzrZNrLQ7GIJQQpR%2FAu05pJSOPE4u7eRod4vyCqL2fuuoMq%2FQANP7IDauoAjJ806P4WOzgI7KtRKD08c1tFqdTjChRJ0%2F5%2FCXhSp&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20230228T104621Z&X-Amz-SignedHeaders=host&X-Amz-Expires=43200&X-Amz-Credential=ASIARQNY6EATN3BDNQ62%2F20230228%2Fap-south-1%2Fs3%2Faws4_request&X-Amz-Signature=6b9b158841652c75a2f5ea1e8f63bfb7019251aee64f31086b05f2514db25d15');
      print(
          'https://filroll-storage-114584815-staging.s3.ap-south-1.amazonaws.com/public/dp-iEpePVrZ48MLKyICEjo5Egvy9CT2.jpg?X-Amz-Security-Token=IQoJb3JpZ2luX2VjEMr%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCmFwLXNvdXRoLTEiRjBEAiAtGujFJkq5%2B80V1DxaeUti3ejAc%2BqASKSpQbLe0RowvgIgJhsirNmH1VfUSBtlCGbUMdw%2FYXMI4YBuN72tv7qqoKkqlAYIdBAAGgwxMDQwMDM5MzYyOTQiDLYGC6bxA9CCCD0ObirxBXQnjYwB6M2sneg051RJChlv7V805eA7EPJL1VNw1njq1a62F89sZnnvp4j84UbUnU%2BJNdD2hPyojxKd%2BSsLxXM15KW%2FsjPs90bnAMddIoe0ycQA%2BHUjNWACSZMQmlItgE6vsgCm3Fun8VYaVkJMHqpwIQDkn2laycF39sJ7k1OQAoFdIu9K8PwyLAFaJUXQ1ogI%2FHOlh%2FxirLW21VGWN52ayLDGnpkoRngCTqDEljkqkm%2BCMa2aa2LiNygNTIFxWMWDp7Zo72vwVPSimzwDyMtaZCnlOeQ66HKVQnY9FOgfYqjY37GClhGDg2twFYDZY3OfNMBdDPX64VZpNFXsPxgrVzQVxlwfXBVaBqn2JneHBZUj0ghG3Xjto5wk6jiNfdkZAMiNeb0eCHlsyVTPJZ43D4bhRRAa2rGzp7UipvihINA3IyZ5Kr4KCnVDduusqdV9vHn%2B%2BqZhFfajigKefY2nDXC7x%2FAU%2BBpgX2%2B23dbpif0SpaC2cZy2L1MVa4flpF9bIvkF%2BUVVfws%2BfGU6jzTYYGrB5R7pS60DwLFqP8x3mReXTktXMkYDhQpI7E40UZ%2B0Ex17fWpxcm0ZAxsGnFUCV8nbln3Pe9LoL%2FlVvQLQEHsPvX31FPQoKXlqVQBU81tXleZINMJ3FiZm64RCzfKlhdfpf7gFll6TRf9tzTTULLtDoNSsQb5maOosCUFkZbsOaPhlMfa92x48N8lGb2TECO0qEgqMczaQeUuVx3iSkvaPYOZItBLH0nxv0e9XAT7jN4MLJtR46djl1uZ5uf9ephjm%2FjYZLPiOBf73AHF0fVIsJFb7OwFqFE0GnFfmdcK5pddB7SKNY%2FKJRUFczWJxbq1hrSP8tVBLzvUhyqyNzb0KPDTqjwq1tGdVDKOzwUyRQKFtozc4lCk7Jb5MPQi8v05Xqh5XhFn8IH7i5esVElLSYKftLcPytOke7QyHpfSbc7BOms5BtLi5IUSC1BmH4b7pUchAr73slN7qm%2FN95zCyrfefBjqIAu%2BbUlACGU8WzKRcw2frdzqmEFa%2B5FGZDDKdlB2tGplWZMzeHuZFqCKjp8MKJ89smoiLGB0it%2FMlt1BGBpvFNpr2ANl9V%2FqdQUW8rFfxXhwk7NV27kCPnlOnyWGsX7vJFeuctLmC2dCjtR%2Fwk8So2gpbtG6g6paCcwfwdioipY9QKEQJyoVbfRPHoAOKJ7tFTlIc8jJpe%2Fv5Ji3XlBquG%2FaMUIXCO%2BTV%2B27XLkn19Aslpw2pgHKkdx7EmeW7K%2Bw0kcIqF0XQSVYzfZVI6PgCymTZ2LVGAj%2FmbjSWh59Lv7oQSrjfPAkCCnUejuJzXZ9fPB747l0pMG9stw%2Bt4%2BtG9CnI6MKEdiLR2g%3D%3D&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20230228T103952Z&X-Amz-SignedHeaders=host&X-Amz-Expires=43199&X-Amz-Credential=ASIARQNY6EATIM227I6P%2F20230228%2Fap-south-1%2Fs3%2Faws4_request&X-Amz-Signature=f65fa533f08cf596357c4ab1a49c3c89226c52c322f29b9818b1e159da12adb7');
      print(
          'https://filroll-storage-114584815-staging.s3.ap-south-1.amazonaws.com/public/dp-s1T4fOMY9YMTBt6POZ2oSo1g4Lk1.jpg?response-content-disposition=inline&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEMT%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCmFwLXNvdXRoLTEiRjBEAiA6VmgZF0JENemhwFtK9FUHfW68j45LjV8gYmR3xLbHfAIgHZikIpnGtREuEh67EqU0zJzS2Ox8vqfKmiU148ETPi4q5AIIbRAAGgwxMDQwMDM5MzYyOTQiDIosyZSHJ7Q%2BB834QirBAgyRpddIrEyAeqUGmoC1K8v7nK%2FWhW%2BEboJOsAFMOEdRCrET03m3tlck5RiMxUfZLLB1Gfqyr2hRkADepzjMJRCrwmXvNQx48LkaSjXPi0wOF%2BayGAHoBgBhk5aUpj9Dv5VrbDDj54qfhHwSuWm17T2FzDUoW5%2BR6P2Hb0PrSFXqVWtEIiYqGqKFVOcrsiXisLdg50DMB%2FVveoC4K4xAfm455TIqtRT8P4JKWA7jIY7FyV4EJAh7I%2FGgTRicne%2B%2B9c49kdWb%2FuUtF2EiZ9HsAEAd2vQn2%2F1cofKqhiY8PQ1rxZeaCwFIS%2Fv0NQH9hcBW%2FFhRq16mNUE8MMM1%2Bg3u9grjI0Jpo%2F4fflXImGaiYZSijtXl0uaaL3ZViFp9AZXF2DvANMR5IDHNW4er2sKQ%2Bq7Dfvj18FJbQckJhDXZ01vPTjDM%2FvWfBjq0AlwkI%2F3zhCguPP3732FDRPn0PSvYIeYx%2FsPs3VxpFHkl1B1w%2BQxA2sCD29cVadq3jjmlxKs%2Bj%2BvHd98SmyFhke6DFc05qtRu0iHMO03mLdReArJnmsp2EQetc8Hn03mu7D9MiYJvFnrc3xH2M95xJIUaNB0ZtweR7csGXJS8fmRhW4c2Y%2B9gEUEtip8pQZ9sZQ%2B7VDjyA9nndUjON9jd8bnC4vv1fj36aCndbYYNYXSkjoVdbrBXwIKUUxPVB5l%2BTRCBjWtJWThy2px3JPmiWHcLOzpvyXeQCC3l5%2FEf3JNWmyN1Jdi0zeMNTzrZNrLQ7GIJQQpR%2FAu05pJSOPE4u7eRod4vyCqL2fuuoMq%2FQANP7IDauoAjJ806P4WOzgI7KtRKD08c1tFqdTjChRJ0%2F5%2FCXhSp&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20230228T095322Z&X-Amz-SignedHeaders=host&X-Amz-Expires=43200&X-Amz-Credential=ASIARQNY6EATN3BDNQ62%2F20230228%2Fap-south-1%2Fs3%2Faws4_request&X-Amz-Signature=c7899d96a8ffae025b1db9aa602f20191cd55e0ff994df24e33d731efe5aedf2');
      return result.url;
    } catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('show stories'),
              onPressed: () async {
                await getUrl('dp-s1T4fOMY9YMTBt6POZ2oSo1g4Lk1.jpg');
                // var snap = await FirebaseFirestore.instance
                //     .collection('story')
                //     .doc('Fs1RMqasBbfBzK37CmkS5bmziFb2')
                //     .get();
                // List list = snap.data()!['stories'];
                // var i = 0;
                // for (i; i < list.length; i++) {
                //   print(DateTime.now()
                //       .difference(list[i]['dateTime'].toDate())
                //       .inHours);
                //   print(DateTime.now()
                //           .difference(list[i]['dateTime'].toDate())
                //           .inHours >=
                //       12);
                //   if (DateTime.now()
                //           .difference(list[i]['dateTime'].toDate())
                //           .inHours >
                //       12) {
                //     list.removeAt(i);
                //   }
                // }
                //Provider.of<Story>(context, listen: false).getDumStory();
                // List<StoryM> story = [
                //   StoryM(
                //       "https://images.unsplash.com/photo-1601758228041-f3b2795255f1?ixid=MXwxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwxN3x8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60")
                // ];
                // UserM use = UserM([
                //   {
                //     'imageUrl':
                //         'storyImg-1aea7270-b33e-11ed-a9ef-857cfcb06ccd.jpg',
                //     'dateTime': DateTime.now()
                //   },
                //   {
                //     'imageUrl':
                //         'storyImg-73974ec0-b1e0-11ed-855b-b762d5f84804.jpg',
                //     'dateTime': DateTime.now()
                //   },
                //   {
                //     'imageUrl':
                //         'storyImg-dc102140-b1f2-11ed-b9e1-9d36c2a8a70a.jpg',
                //     'dateTime': DateTime.now()
                //   },
                // ], 'Raja',
                //     "https://images.unsplash.com/photo-1601758228041-f3b2795255f1?ixid=MXwxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwxN3x8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60");
                // await FirebaseFirestore.instance
                //     .collection('story')
                //     .doc('Fs1RMqasBbfBzK37CmkS5bmziFb2')
                //     .set(use.toJson());
                //   'dp':
                //       'https://images.unsplash.com/photo-1601758228041-f3b2795255f1?ixid=MXwxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwxN3x8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
                //   'username': 'Raj',
                //   'stories': [
                //     {
                //       'imageUrl':
                //           'storyImg-1aea7270-b33e-11ed-a9ef-857cfcb06ccd.jpg',
                //       'dateTime': DateTime.now()
                //     },
                //     {
                //       'imageUrl':
                //           'storyImg-73974ec0-b1e0-11ed-855b-b762d5f84804.jpg',
                //       'dateTime': DateTime.now()
                //     },
                //     {
                //       'imageUrl':
                //           'storyImg-dc102140-b1f2-11ed-b9e1-9d36c2a8a70a.jpg',
                //       'dateTime': DateTime.now()
                //     },
                //     {
                //       'imageUrl':
                //           'postImg-de5e51c0-ade6-11ed-aaaf-49f2efc38e15.jpg',
                //       'dateTime': DateTime.now()
                //     },
                //   ]
                // });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const StoryPage();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

final sampleUsers = [
  UserModel(
    [
      "https://images.unsplash.com/photo-1601758228041-f3b2795255f1?ixid=MXwxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwxN3x8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
      "https://images.unsplash.com/photo-1609418426663-8b5c127691f9?ixid=MXwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwyNXx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
      // "https://images.unsplash.com/photo-1609444074870-2860a9a613e3?ixid=MXwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw1Nnx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
      // "https://images.unsplash.com/photo-1609504373567-acda19c93dc4?ixid=MXwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw1MHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
    ],
    "User1",
    "https://images.unsplash.com/photo-1609262772830-0decc49ec18c?ixid=MXwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwzMDF8fHxlbnwwfHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
  ),
  // UserModel([
  //   StoryModel(
  //       "https://images.unsplash.com/photo-1609439547168-c973842210e1?ixid=MXwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw4Nnx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"),
  // ], "User2",
  //     "https://images.unsplash.com/photo-1601758125946-6ec2ef64daf8?ixid=MXwxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwzMjN8fHxlbnwwfHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"),
  // UserModel([
  //   StoryModel(
  //       "https://images.unsplash.com/photo-1609421139394-8def18a165df?ixid=MXwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwxMDl8fHxlbnwwfHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"),
  //   StoryModel(
  //       "https://images.unsplash.com/photo-1609377375732-7abb74e435d9?ixid=MXwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwxODJ8fHxlbnwwfHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"),
  //   StoryModel(
  //       "https://images.unsplash.com/photo-1560925978-3169a42619b2?ixid=MXwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwyMjF8fHxlbnwwfHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"),
  // ], "User3",
  //     "https://images.unsplash.com/photo-1609127102567-8a9a21dc27d8?ixid=MXwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwzOTh8fHxlbnwwfHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"),
];

class StoryPage extends StatefulWidget {
  final index;
  const StoryPage({Key? key, this.index}) : super(key: key);

  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  late ValueNotifier<IndicatorAnimationCommand> indicatorAnimationController;
  String storyUrl = '';

  void initState() {
    super.initState();
    indicatorAnimationController = ValueNotifier<IndicatorAnimationCommand>(
        IndicatorAnimationCommand.resume);
    Provider.of<Story>(context, listen: false).getDumStory();
    // setState(() {
    //   userUid = widget.snap['uid'];
    // });
    // Provider.of<Story>(context, listen: false).getUserStory(userUid);

    // getDetail();
  }

  @override
  void dispose() {
    indicatorAnimationController.dispose();
    super.dispose();
  }

  Future<String> getUrl(String key) async {
    try {
      final result = await Amplify.Storage.getUrl(
        key: key,
      );
      // setState(() {
      //   storyUrl = result.url;
      // });
      print(result.url);
      // print(
      //     'https://filroll-storage-114584815-staging.s3.ap-south-1.amazonaws.com/public/dp-s1T4fOMY9YMTBt6POZ2oSo1g4Lk1.jpg?response-content-disposition=inline&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEMT%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCmFwLXNvdXRoLTEiRjBEAiA6VmgZF0JENemhwFtK9FUHfW68j45LjV8gYmR3xLbHfAIgHZikIpnGtREuEh67EqU0zJzS2Ox8vqfKmiU148ETPi4q5AIIbRAAGgwxMDQwMDM5MzYyOTQiDIosyZSHJ7Q%2BB834QirBAgyRpddIrEyAeqUGmoC1K8v7nK%2FWhW%2BEboJOsAFMOEdRCrET03m3tlck5RiMxUfZLLB1Gfqyr2hRkADepzjMJRCrwmXvNQx48LkaSjXPi0wOF%2BayGAHoBgBhk5aUpj9Dv5VrbDDj54qfhHwSuWm17T2FzDUoW5%2BR6P2Hb0PrSFXqVWtEIiYqGqKFVOcrsiXisLdg50DMB%2FVveoC4K4xAfm455TIqtRT8P4JKWA7jIY7FyV4EJAh7I%2FGgTRicne%2B%2B9c49kdWb%2FuUtF2EiZ9HsAEAd2vQn2%2F1cofKqhiY8PQ1rxZeaCwFIS%2Fv0NQH9hcBW%2FFhRq16mNUE8MMM1%2Bg3u9grjI0Jpo%2F4fflXImGaiYZSijtXl0uaaL3ZViFp9AZXF2DvANMR5IDHNW4er2sKQ%2Bq7Dfvj18FJbQckJhDXZ01vPTjDM%2FvWfBjq0AlwkI%2F3zhCguPP3732FDRPn0PSvYIeYx%2FsPs3VxpFHkl1B1w%2BQxA2sCD29cVadq3jjmlxKs%2Bj%2BvHd98SmyFhke6DFc05qtRu0iHMO03mLdReArJnmsp2EQetc8Hn03mu7D9MiYJvFnrc3xH2M95xJIUaNB0ZtweR7csGXJS8fmRhW4c2Y%2B9gEUEtip8pQZ9sZQ%2B7VDjyA9nndUjON9jd8bnC4vv1fj36aCndbYYNYXSkjoVdbrBXwIKUUxPVB5l%2BTRCBjWtJWThy2px3JPmiWHcLOzpvyXeQCC3l5%2FEf3JNWmyN1Jdi0zeMNTzrZNrLQ7GIJQQpR%2FAu05pJSOPE4u7eRod4vyCqL2fuuoMq%2FQANP7IDauoAjJ806P4WOzgI7KtRKD08c1tFqdTjChRJ0%2F5%2FCXhSp&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20230228T095322Z&X-Amz-SignedHeaders=host&X-Amz-Expires=43200&X-Amz-Credential=ASIARQNY6EATN3BDNQ62%2F20230228%2Fap-south-1%2Fs3%2Faws4_request&X-Amz-Signature=c7899d96a8ffae025b1db9aa602f20191cd55e0ff994df24e33d731efe5aedf2');
      return result.url;
    } catch (e) {
      throw e;
    }
  }

  fetchUrl(String key) async {
    storyUrl = await getUrl(key);
    return storyUrl;
  }

  @override
  Widget build(BuildContext context) {
    var ref = Provider.of<Story>(context);
    return Scaffold(
      body: StoryPageView(
        itemBuilder: (context, pageIndex, storyIndex) {
          if (widget.index != 0) pageIndex = widget.index;
          final user = ref.uses[pageIndex];
          final story = user.stories[storyIndex];
          return MyWidget(
            user: user,
            story: story['imageUrl'],
          );
        },
        gestureItemBuilder: (context, pageIndex, storyIndex) {
          if (widget.index != 0) pageIndex = widget.index;
          return Stack(children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 32),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  color: Colors.white,
                  icon: const Icon(Icons.more_vert_rounded),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),

            // if (pageIndex == 0)
            //   Center(
            //     child: ElevatedButton(
            //       child: const Text('show modal bottom sheet'),
            //       onPressed: () async {
            //         indicatorAnimationController.value =
            //             IndicatorAnimationCommand.pause;
            //         await showModalBottomSheet(
            //           context: context,
            //           builder: (context) => SizedBox(
            //             height: MediaQuery.of(context).size.height / 2,
            //             child: Padding(
            //               padding: const EdgeInsets.all(24),
            //               child: Text(
            //                 'Look! The indicator is now paused\n\n'
            //                 'It will be coutinued after closing the modal bottom sheet.',
            //                 style: Theme.of(context).textTheme.headlineSmall,
            //                 textAlign: TextAlign.center,
            //               ),
            //             ),
            //           ),
            //         );
            //         indicatorAnimationController.value =
            //             IndicatorAnimationCommand.resume;
            //       },
            //     ),
            //   ),
          ]);
        },
        indicatorAnimationController: indicatorAnimationController,
        // initialStoryIndex: (pageIndex) {
        //   if (pageIndex == widget.index) {
        //     return 1;
        //   }
        //   return 0;
        // },
        pageLength: ref.uses.length,
        storyLength: (int pageIndex) {
          if (widget.index != 0) pageIndex = widget.index;
          return ref.uses[pageIndex].stories.length;
        },
        onPageLimitReached: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

class MyWidget extends StatefulWidget {
  final story;
  final user;
  MyWidget({super.key, this.story, this.user});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  String storyUrl = '';

  @override
  void initState() {
    super.initState();
    Provider.of<Story>(context, listen: false)
        .viewedStory(widget.user.uid, FirebaseAuth.instance.currentUser!.uid);
    //getUrl();
    // getUrl();
    // print('2: ${widget.story}');
  }

  getUrl() async {
    try {
      var s = await widget.story;
      setState(() {
        storyUrl = s;
      });
    } catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(color: Colors.black),
        ),
        Positioned.fill(
          child: Image.network(
            widget.story,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 44, left: 8),
          child: Row(
            children: [
              Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.user.imageUrl),
                    fit: BoxFit.cover,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                widget.user.userName,
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
