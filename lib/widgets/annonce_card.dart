
import 'package:flutter/material.dart';

class AnnonceCard extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final String subtitle;
  final VoidCallback? onTap;

  const AnnonceCard({Key? key, required this.title, this.imageUrl, this.subtitle = '', this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null && imageUrl!.isNotEmpty)
              AspectRatio(
                aspectRatio: 16/9,
                child: Image.network(imageUrl!, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(color: Colors.grey[200])),
              ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleLarge),
                  if (subtitle.isNotEmpty) SizedBox(height: 6),
                  if (subtitle.isNotEmpty) Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
