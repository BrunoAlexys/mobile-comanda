import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomPhotoMenuItem extends StatelessWidget {
  final String? url;
  final double width;
  final double height;

  const CustomPhotoMenuItem({
    super.key,
    this.url,
    required this.width,
    required this.height,
  });

  String _optimizeCloudinaryUrl(String url) {
    if (!url.contains('cloudinary.com')) return url;

    final parts = url.split('/upload/');
    if (parts.length != 2) return url;

    return '${parts[0]}/upload/w_500,q_auto,f_auto/${parts[1]}';
  }

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return _buildPlaceholder();
    }

    return CachedNetworkImage(
      imageUrl: _optimizeCloudinaryUrl(url!),
      width: width,
      height: height,
      fit: BoxFit.cover,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(width: width, height: height, color: Colors.white),
      ),
      errorWidget: (context, url, error) => _buildPlaceholder(),
      memCacheHeight: (height * MediaQuery.of(context).devicePixelRatio)
          .toInt(),
      memCacheWidth: (width * MediaQuery.of(context).devicePixelRatio).toInt(),
      maxWidthDiskCache: 1000,
      maxHeightDiskCache: 1000,
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: Icon(Icons.fastfood, color: Colors.grey[400], size: width * 0.3),
    );
  }
}
