import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pertemuan6/users_model.dart';
import 'api_data_source.dart';
import 'detail_user.dart';


class PageListUsers extends StatelessWidget {
  const PageListUsers({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("List User"),
          backgroundColor: Colors.teal,
        ),
        body: FutureBuilder(
          future: ApiDataSource.instance.loadUsers(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Error");
            }
            if (snapshot.hasData) {
              UsersModel users = UsersModel.fromJson(snapshot.data!);
              return ListView.builder(
                itemCount: users.data!.length,
                itemBuilder: (context, index) {
                  var user = users.data![index];
                  return ListTile(
                      leading: CircleAvatar(
                        foregroundImage: NetworkImage(user.avatar!),
                      ),
                      title: Text(user.firstName! + " " + user.lastName!),
                      subtitle: Text("${user.email}"),
                      onTap: () async {
                        final id = user.id;
                        final detailData = await ApiDataSource.instance.loadDetailUser(id!);
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return HalamanDetail(detailData: detailData);
                        }));
                      }
                  );
                },
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        )
    );
  }
}
