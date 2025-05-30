import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/config/theme.dart';

class PhotoItem extends StatelessWidget {
  final String imageUrl;
  final bool isSelected;
  final VoidCallback onSelect;

  const PhotoItem({
    super.key,
    required this.imageUrl,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.all(12),
            width: 100,
            height: 120,
            decoration: BoxDecoration(
              color: Color(0xFFD9D9D9),
              image: imageUrl.isNotEmpty
                  ? DecorationImage(
                image: CachedNetworkImageProvider(imageUrl),
                fit: BoxFit.cover,
              )
                  : null,
              border: Border.all(
                color: isSelected ? Colors.green : Colors.black,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          if (isSelected)
            Positioned(
              top: 4,
              right: 4,
              child: Icon(Icons.check_circle, color: Colors.green, size: 24),
            ),
        ],
      ),
    );
  }
}
