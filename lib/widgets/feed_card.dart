import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:quick_news/database/news_database.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../models/news.dart';

class FeedCard extends StatefulWidget {
  final News data;

  const FeedCard({super.key, required this.data});

  @override
  State<FeedCard> createState() => _FeedCardState();
}

class _FeedCardState extends State<FeedCard> {
  FlutterTts flutterTts = FlutterTts();
  @override
  Widget build(BuildContext context) {
    bool isDescBig = false;
    bool isTitleBig = widget.data.title.length > 75;
    if (widget.data.description != null) {
      isDescBig = widget.data.description!.length > 200;
    }
    return Stack(
      alignment: Alignment.bottomRight,
      children: [newsInfo(isTitleBig, isDescBig), newsControls()],
    );
  }

  Padding newsInfo(bool isTitleBig, bool isDescBig) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.data.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: widget.data.description == null ? 0 : 20),
            Text(
              widget.data.description ?? "",
              style: const TextStyle(fontSize: 16),
            ),
            SizedBox(height: isDescBig ? 0 : 20),
            Text(
              (!isDescBig && !isTitleBig) ? widget.data.content ?? "" : "",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                widget.data.urlToImage ??
                    "https://media.istockphoto.com/id/1409329028/vector/no-picture-available-placeholder-thumbnail-icon-illustration-design.jpg?s=612x612&w=0&k=20&c=_zOuJu755g2eEUioiOUdz_mHKJQJn-tDgIAhQzyeKUQ=",
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
              ),
            ),
          ],
        ),
      );

  Container newsControls() => Container(
        padding: const EdgeInsets.only(bottom: 32, right: 8, left: 8),
        height: 350,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.65),
          borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            controlButton(
              context.watch<NewsDatabase>().checkIfExists(widget.data)
                  ? 'Unsave'
                  : 'Save',
              context.watch<NewsDatabase>().checkIfExists(widget.data)
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_outline_rounded,
              () => saveArticle(
                context.read<NewsDatabase>().checkIfExists(widget.data),
              ),
            ),
            controlButton('Visit', Icons.open_in_new_rounded, readFullArticle),
            controlButton(
              'Share',
              Icons.share,
              () => Share.shareUri(Uri.parse(widget.data.url)),
            ),
            controlButton('Listen', Icons.volume_up, () => textToSpeech()),
          ],
        ),
      );

  Column controlButton(String name, IconData icon, void Function()? onPressed) {
    return Column(
      children: [
        const SizedBox(height: 10),
        IconButton(
          onPressed: onPressed,
          tooltip: name,
          icon: Icon(
            icon,
            size: 30,
            semanticLabel: name,
            color: Colors.white,
          ),
        ),
        Text(
          name,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  void saveArticle(bool ifExists) {
    News article = widget.data;
    if (ifExists) {
      context.read<NewsDatabase>().deleteNews(article.id);
    } else {
      context.read<NewsDatabase>().addNews(article);
    }
  }

  Future<void> readFullArticle() async {
    final Uri uri = Uri.parse(widget.data.url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

  void textToSpeech() async {
    await flutterTts.setLanguage('en-IN');
    await flutterTts.setVolume(0.5);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1);
    await flutterTts.speak(
      '${widget.data.title}. ${widget.data.description ?? ""}. ${widget.data.content ?? ""}',
    );
  }
}
