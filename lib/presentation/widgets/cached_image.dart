import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'loading_skeleton.dart';

class CachedProfileImage extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final BorderRadius? borderRadius;

  const CachedProfileImage({
    super.key,
    required this.imageUrl,
    this.size = 100,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(size / 2);

    if (imageUrl == null || imageUrl!.isEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BorderRadius.all(Radius.circular(size / 2)) == const BorderRadius.all(Radius.zero)
              ? BoxShape.rectangle
              : BoxShape.circle,
          color: const Color(0xFFEFEBE9),
          border: Border.all(
            color: const Color(0xFFA1887F),
            width: 2,
          ),
        ),
        child: Icon(
          Icons.person,
          size: size * 0.6,
          color: const Color(0xFF8D6E63),
        ),
      );
    }

    return ClipRRect(
      borderRadius: radius,
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (context, url) => LoadingSkeleton(
          width: size,
          height: size,
          borderRadius: radius,
        ),
        errorWidget: (context, url, error) => Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: radius,
            color: const Color(0xFFEFEBE9),
          ),
          child: Icon(
            Icons.person,
            size: size * 0.6,
            color: const Color(0xFF8D6E63),
          ),
        ),
      ),
    );
  }
}

class CachedReviewImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;

  const CachedReviewImage({
    super.key,
    required this.imageUrl,
    this.width = double.infinity,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        placeholder: (context, url) => LoadingSkeleton(
          width: width,
          height: height,
          borderRadius: BorderRadius.circular(8),
        ),
        errorWidget: (context, url, error) => Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xFFEFEBE9),
          ),
          child: const Icon(
            Icons.image,
            size: 48,
            color: Color(0xFF8D6E63),
          ),
        ),
      ),
    );
  }
}

class CachedCircleImage extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final Color? backgroundColor;
  final IconData? fallbackIcon;
  final Color? iconColor;

  const CachedCircleImage({
    super.key,
    required this.imageUrl,
    this.radius = 24,
    this.backgroundColor,
    this.fallbackIcon = Icons.person,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? const Color(0xFFEFEBE9);
    final iColor = iconColor ?? const Color(0xFF8D6E63);

    if (imageUrl == null || imageUrl!.isEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: bgColor,
        child: Icon(
          fallbackIcon,
          size: radius,
          color: iColor,
        ),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundImage: CachedNetworkImageProvider(imageUrl!),
      backgroundColor: bgColor,
      onBackgroundImageError: (exception, stackTrace) {
        // 에러 처리
      },
      child: CircleAvatar(
        radius: radius,
        backgroundColor: bgColor,
        child: Icon(
          fallbackIcon,
          size: radius,
          color: iColor,
        ),
      ),
    );
  }
}
