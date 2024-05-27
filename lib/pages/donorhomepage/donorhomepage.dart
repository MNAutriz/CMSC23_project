import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmsc23project/models/organization_model.dart';
import 'package:cmsc23project/pages/donateformpage/donate_form.dart';
import 'package:cmsc23project/providers/organization_provider.dart';
import 'package:cmsc23project/providers/auth_provider.dart';
import 'package:cmsc23project/screens/userview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DonorHomePage extends StatefulWidget {
  const DonorHomePage({super.key});

  @override
  State<DonorHomePage> createState() => _DonorHomePageState();
}

class _DonorHomePageState extends State<DonorHomePage> {
  int _selectedIndex = 0;

  String sampleImage =
      'https://adra.ph/wp-content/uploads/2017/09/Gift-Boxes-Aeta-4-1024x683.jpg';

  TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer,
      backgroundColor: const Color(0xFFEEF2E6),
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            iconTheme: IconThemeData(color: Color(0xFFEEF2E6)),
            backgroundColor: Color(0xFF093731),
            pinned: true,
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(left: 0, bottom: 16),
              centerTitle: true,
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text("Donate Now!",
                        style: TextStyle(
                            color: Color(0xFFEEF2E6),
                            fontWeight: FontWeight.bold)),
                  ),
                  Text(
                    "Scroll to explore organizations",
                    style: TextStyle(color: Color(0xFFEEF2E6), fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          SliverAppBar(
            backgroundColor: const Color(0xFFEEF2E6),
            automaticallyImplyLeading: false,
            pinned: true,
            flexibleSpace: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SearchBar(
                controller: _searchController,
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xFFD6CDA4)),
                leading: const Icon(Icons.search, color: Color(0xFF093731)),
                hintText: "Search organization...",
                hintStyle: MaterialStateProperty.all(const TextStyle(
                  color: Color(0xFF093731),
                )),
              ),
            ),
          ),
          stream()
        ],
      ),
    );
  }

  Widget stream() {
    Stream<QuerySnapshot> orgsStream =
        context.watch<OrganizationProvider>().organization;

    return StreamBuilder(
      stream: orgsStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return SliverToBoxAdapter(
            child: Center(
              child: Text("Error encountered! ${snapshot.error}"),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverToBoxAdapter(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return emptyOrganizations();
        }

        var docs = snapshot.data!.docs;
        if (searchQuery.isNotEmpty) {
          docs = docs.where((doc) {
            var data = doc.data() as Map<String, dynamic>;
            var orgName = data['name'].toString().toLowerCase();
            return orgName.contains(searchQuery);
          }).toList();
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              Organization org = Organization.fromJson(
                  docs[index].data() as Map<String, dynamic>);
              org.id = docs[index].id;

              return Stack(children: [
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                //   child: Card(
                //     clipBehavior: Clip.hardEdge,
                //     child: InkWell(
                //       splashColor: const Color(0xFF3D8361).withAlpha(100),
                //       onTap: () {
                //         debugPrint(org.name);
                //         Navigator.pushNamed(context, "/donor/donatedrives");
                //       },
                //       child: Image.network(sampleImage),
                // child: SizedBox(
                //   width: double.infinity,
                //   height: 150,
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Center(
                //       child: Text(
                //         org.name,
                //         style: const TextStyle(
                //           fontSize: 15,
                //           fontWeight: FontWeight.bold,
                //           color: Color(0xFF093731),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    child: Card(
                        clipBehavior: Clip.hardEdge,
                        child: InkWell(
                            child:
                                Image.network(sampleImage, fit: BoxFit.cover),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, '/donor/donatedrives');
                            })),
                  ),
                ),
                Positioned.fill(
                  // so that text will fill the entire card and the center widget will center according to entire card
                  child: Center(
                    child: Text(org.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Color(0xFFEEF2E6),
                            shadows: [
                              Shadow(
                                  blurRadius: 10,
                                  color: Colors.black,
                                  offset: Offset(2, 2))
                            ])),
                  ),
                )
              ]);
            },
            childCount: docs.length,
          ),
        );
      },
    );
  }

  Widget emptyOrganizations() {
    return const SliverToBoxAdapter(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.people),
            Text("No registered organizations yet"),
          ],
        ),
      ),
    );
  }

  Drawer get drawer => Drawer(
        child: Container(
          color: const Color(0xFFEEF2E6),
          child: ListView(padding: EdgeInsets.zero, children: [
            const DrawerHeader(
                decoration: BoxDecoration(color: Color(0xFF1C6758)),
                child: Text("Settings",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Color(0xFFEEF2E6)))),
            ListTile(
              title: const Center(
                child: Text(
                  "Log out",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0xFF1C6758)),
                ),
              ),
              onTap: () {
                context.read<UserAuthProvider>().signOut();
              },
            ),
          ]),
        ),
      );
}
