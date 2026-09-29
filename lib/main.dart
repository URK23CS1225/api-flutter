import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const ApiApp());
}

class ApiApp extends StatelessWidget {
  const ApiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'API App',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF8F4FC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF9C7AC7),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFBFA2DB),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 2,
        ),
        cardTheme: const CardThemeData(
          color: Color(0xFFF0E6F7),
          elevation: 2,
          margin: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 7,
          ),
        ),
      ),
      home: const ApiHomePage(),
    );
  }
}

class ApiHomePage extends StatefulWidget {
  const ApiHomePage({super.key});

  @override
  State<ApiHomePage> createState() => _ApiHomePageState();
}

class _ApiHomePageState extends State<ApiHomePage> {
  List<dynamic> posts = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await http.get(
        Uri.parse(
          'https://jsonplaceholder.typicode.com/posts',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          posts = data;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load data';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage =
            'Network error. Please try again.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'REST API Posts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF9C7AC7),
              ),
            )

          : errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 60,
                        color: Color(0xFF9C7AC7),
                      ),

                      const SizedBox(height: 15),

                      Text(
                        errorMessage,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xFF5E4A6E),
                        ),
                      ),

                      const SizedBox(height: 15),

                      ElevatedButton(
                        onPressed: fetchData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFFBFA2DB),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )

              : RefreshIndicator(
                  color: const Color(0xFF9C7AC7),
                  onRefresh: fetchData,

                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),

                    itemCount: posts.length,

                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.all(12),

                          leading: CircleAvatar(
                            backgroundColor:
                                const Color(0xFFD8C4E8),

                            child: Text(
                              '${posts[index]['id']}',
                              style: const TextStyle(
                                color: Color(0xFF5E4A6E),
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),

                          title: Text(
                            posts[index]['title'],
                            style: const TextStyle(
                              color: Color(0xFF4D3A5C),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),

                          subtitle: Padding(
                            padding:
                                const EdgeInsets.only(
                              top: 8,
                            ),

                            child: Text(
                              posts[index]['body'],
                              style: const TextStyle(
                                color: Color(0xFF6E5A7D),
                                height: 1.4,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}