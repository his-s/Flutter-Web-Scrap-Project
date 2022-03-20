import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard(
      {Key? key,
      required this.title,
      required this.price,
      required this.imgUrl})
      : super(key: key);
  final String title;
  final String price;
  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          imgUrl.isNotEmpty
              ? Image.network(
                  "https://www.sigma-computer.com/" + imgUrl,
                  width: 153,
                  height: 153,
                  fit: BoxFit.contain,
                )
              : const SizedBox(),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xff333333),
            ),
          ),
          Text(
            price,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xff58a3da),
              fontWeight: FontWeight.w600,
              height: 2,
            ),
          ),
        ],
      ),
    );
  }
}
