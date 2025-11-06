import 'package:flutter/material.dart';

class AcquariumView extends StatelessWidget {
  const AcquariumView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildAquariumCard(context),
    );
  }

  Widget? _buildAquariumCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //print("Container tapped");
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        height: 150,
        width: 200,
        decoration: BoxDecoration(
          color: Color.fromARGB(153, 187, 177, 177),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/aquarium.png',
                height: 80,
                width: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                      size: 32,
                    ),
                  );
                },
              ),
            ),
            const Spacer(),
            Text(
              "La Mia Vasca",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
              //maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
