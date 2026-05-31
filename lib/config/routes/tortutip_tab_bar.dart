import 'package:flutter/material.dart';

class TortuTipTabBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabTap;

  const TortuTipTabBar({
    super.key,
    required this.currentIndex,
    required this.onTabTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _TabIcon(
              icon: Icons.article_outlined,
              selected: currentIndex == 0,
              onTap: () => onTabTap(0),
            ),
            _TabIconCenter(onTap: () => onTabTap(1)),
            _TabIcon(
              icon: Icons.explore_outlined,
              selected: currentIndex == 2,
              onTap: () => onTabTap(2),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabIcon extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _TabIcon({
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          color: selected ? Colors.white : Colors.white54,
          size: 26,
        ),
      ),
    );
  }
}

class _TabIconCenter extends StatelessWidget {
  final VoidCallback onTap;
  const _TabIconCenter({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: const BoxDecoration(
          color: Color(0xFF5B8A3C),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.edit_outlined,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }
}
