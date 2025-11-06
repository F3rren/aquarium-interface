import 'package:flutter/material.dart';

class AcquariumView extends StatelessWidget {
  const AcquariumView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(child: _buildAquariumCard(context));
  }

  Widget? _buildAquariumCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
              context,
              '/details',
            );
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          height: 200,
          width: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                //borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/images/aquarium.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
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
                  color: Colors.black87,
                ),
                //maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
