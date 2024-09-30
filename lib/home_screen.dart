import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'video_list_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late YoutubePlayerController ytController;
  String videoUrl = "https://www.youtube.com/watch?v=ivrumxRUz_Y";

  @override
  void initState() {
    super.initState();
    _initializePlayer(videoUrl);
  }

  void _initializePlayer(String url) {
    final videoId = YoutubePlayer.convertUrlToId(url);
    if (videoId == null) {
      print("Invalid video URL: $url");
      return;
    }
    ytController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
    print("Initialized with videoId: $videoId");
  }

  @override
  void dispose() {
    ytController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> urls = [
      "https://www.youtube.com/watch?v=ivrumxRUz_Y",
      "https://www.youtube.com/watch?v=1hYDVvrdHVU&t=1278s",
      "https://www.youtube.com/watch?v=fVVN_sy-Rmw",
      "https://www.youtube.com/watch?v=2xscQbK97wY",
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Video Player"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: YoutubePlayer(
                  controller: ytController,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                ytController.metadata.title,
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: urls.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1 / .6,
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      String newUrl = urls[index];
                      final String? videoId = YoutubePlayer.convertUrlToId(newUrl);
                      if (videoId != null) {
                        ytController.load(videoId); // Load the new video
                      } else {
                        print("Invalid video ID: $newUrl");
                      }
                      setState(() {
                        videoUrl = newUrl;
                      });
                    },
                    child: VideoListWidget(videoUrl: urls[index]),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
