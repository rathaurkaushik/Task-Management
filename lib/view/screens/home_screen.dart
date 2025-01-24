import 'package:flutter/material.dart';
import 'package:task_management/view/widgets/filter_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
          title: const Text(
            'Task Management',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.settings_outlined, color: Colors.white),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          child: Column(
            children: <Widget>[
              // Search Bar
              TextFormField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search_outlined),
                  hintText: 'Search tasks...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
                onChanged: (String value) {
                  //
                },
              ),

              const SizedBox(height: 12),

              // Task Filters
              SizedBox(
                height: 35,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    buildFilterButton("All Tasks", "All Tasks"),
                    const SizedBox(width: 10),
                    buildFilterButton("Pending", "All Tasks"),
                    const SizedBox(width: 10),
                    buildFilterButton("Completed", "All Tasks"),
                    const SizedBox(width: 10),
                    buildFilterButton("High Priority", "All Tasks"),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Task List
              Expanded(
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 1.5,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(15),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Design Mobile App UI',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              height: 35,
                              child: Chip(
                                backgroundColor: const Color(0xfffee2e2),
                                label: const Text(
                                  'Pending',
                                  style: TextStyle(
                                      color: Color(0xffdc2626), fontSize: 13),
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: const Text('Due: Today, 5:00 PM'),
                        // trailing:
                        // Chip(
                        //   backgroundColor: const Color(0xfffee2e2),
                        //   label: const Text(
                        //     'Pending',
                        //     style: TextStyle(color: Color(0xffdc2626)),
                        //   ),
                        // ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),


        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: SvgPicture.asset(
            'assets/icons/to-do-list-svgrepo-com.svg',
            width: 24, // Size can be adjusted
            height: 24, // Size can be adjusted
            fit: BoxFit.contain, // Optional
          ),
        ));
  }
}
