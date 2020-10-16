  import 'package:cached_network_image/cached_network_image.dart';
  import 'package:flutter/material.dart';

  class CachedImage extends StatelessWidget {
    final String imageUrl;
    final bool isRound;
    final double height;
    final double width;

    final BoxFit fit;

    final String noImageAvailable =
    "https://www.esm.rochester.edu/uploads/NoPhotoAvailable.jpg";

    CachedImage(
      this.imageUrl, {
      this.isRound = false,
      this.height,
      this.width,
      this.fit = BoxFit.cover, String url,
    });

    @override
    Widget build(BuildContext context) {
      try {
        return SizedBox(
          height:height,
          width:  width,
          child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20) ,
                topRight:  Radius.circular(20),
                bottomLeft:  Radius.circular(20),
              ),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: fit,
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) =>
                    Image.network(noImageAvailable, fit: BoxFit.cover),
              )),
        );
      } catch (e) {
        print(e);
        return Image.network(noImageAvailable, fit: BoxFit.cover);
      }
    }
  }