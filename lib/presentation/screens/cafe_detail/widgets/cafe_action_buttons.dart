import 'package:flutter/material.dart';
import '../../../../domain/entities/cafe.dart';

class CafeActionButtons extends StatefulWidget {
  final Cafe cafe;

  const CafeActionButtons({
    super.key,
    required this.cafe,
  });

  @override
  State<CafeActionButtons> createState() => _CafeActionButtonsState();
}

class _CafeActionButtonsState extends State<CafeActionButtons> {
  bool isFavorite = false;

  void _onCall() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('전화 기능은 Phase 2에서 구현됩니다'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onDirections() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('길 찾기 기능은 Phase 2에서 구현됩니다'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavorite ? '즐겨찾기에 추가되었습니다' : '즐겨찾기에서 제거되었습니다',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          Icons.call,
          '전화',
          _onCall,
        ),
        _buildActionButton(
          Icons.directions,
          '길 찾기',
          _onDirections,
        ),
        _buildActionButton(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          isFavorite ? '즐겨찾기됨' : '즐겨찾기',
          _toggleFavorite,
          iconColor: isFavorite ? Colors.red : null,
        ),
      ],
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    VoidCallback onPressed, {
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Icon(
            icon,
            color: iconColor ?? const Color(0xFF6D4C41),
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6D4C41),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
