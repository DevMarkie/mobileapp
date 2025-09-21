import 'package:flutter/material.dart';
import '../Saves/home_page.dart';

// Onboarding data model (có thể tách file riêng nếu muốn mở rộng)
class _OnboardPageData {
  final String title;
  final String subtitle;
  final String image; // tạm dùng lại 3 ảnh trong lib/theme/Overview/
  const _OnboardPageData({
    required this.title,
    required this.subtitle,
    required this.image,
  });
}

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  late final PageController _controller;
  int _index = 0;
  double _pageValue = 0.0; // giá trị trang (có phần thập phân) để animate

  final pages = const [
    _OnboardPageData(
      title: 'Note Down Expenses',
      subtitle: 'Daily note your expenses\nto help manage money',
      image: 'lib/theme/Overview/1.png',
    ),
    _OnboardPageData(
      title: 'Simple Money Management',
      subtitle:
          'Get your notifications or alert\nwhen you do the over expenses',
      image: 'lib/theme/Overview/2.png',
    ),
    _OnboardPageData(
      title: 'Easy to Track and Analyze',
      subtitle: 'Tracking your expense help make sure\nyou don\'t overspend',
      image: 'lib/theme/Overview/3.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _controller.addListener(() {
      // setState nhẹ khi giá trị thay đổi (page có thể null lúc đầu)
      final v = _controller.page ?? _controller.initialPage.toDouble();
      if (v != _pageValue) {
        setState(() => _pageValue = v);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_index < pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    } else {
      _finish();
    }
  }

  void _prev() {
    if (_index > 0) {
      _controller.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _finish() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_index > 0) {
          _prev();
          return false; // chặn thoát, chỉ back 1 trang ảnh
        }
        return true; // trang đầu thì thoát như bình thường
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 24),
              // Header: back (nếu >0) + logo + skip (nếu chưa cuối)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    // Back button (ẩn ở trang đầu)
                    if (_index > 0)
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 20,
                        ),
                        onPressed: _prev,
                        splashRadius: 20,
                      )
                    else
                      const SizedBox(width: 48), // giữ layout cân
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'lib/theme/Overview/Group.png',
                            width: 40,
                            height: 40,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'monex',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF242C35),
                                  letterSpacing: -0.24,
                                ),
                          ),
                        ],
                      ),
                    ),
                    // Skip (ẩn ở trang cuối)
                    if (_index < pages.length - 1)
                      TextButton(
                        onPressed: _finish,
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0E33F3),
                          ),
                        ),
                      )
                    else
                      const SizedBox(width: 60),
                  ],
                ),
              ),
              const SizedBox(height: 36),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: pages.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (context, i) {
                    final p = pages[i];

                    // Tính delta so với trang hiện tại để làm parallax
                    final delta = (_pageValue - i);
                    // Giá trị clamp để tránh chạy quá xa lúc overscroll
                    final clamped = delta.clamp(-1.0, 1.0);

                    // Các transform
                    final imageOffsetY = 40 * clamped; // ảnh trôi lên/xuống nhẹ
                    final titleOffsetX = 60 * clamped; // title trôi ngang
                    final subtitleOffsetX =
                        100 * clamped; // subtitle trôi nhiều hơn
                    final fade = (1 - clamped.abs()).clamp(0.0, 1.0);

                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Transform.translate(
                            offset: Offset(0, imageOffsetY),
                            child: Opacity(
                              opacity: fade,
                              child: Image.asset(
                                p.image,
                                width: 250.94,
                                height: 320,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(height: 26),
                          Transform.translate(
                            offset: Offset(titleOffsetX, 0),
                            child: Opacity(
                              opacity: fade,
                              child: Text(
                                p.title,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF242C35),
                                    ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Transform.translate(
                            offset: Offset(subtitleOffsetX, 0),
                            child: Opacity(
                              opacity: fade,
                              child: Text(
                                p.subtitle,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: const Color(0xFF6B747F),
                                      height: 1.5,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              // Indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < pages.length; i++) ...[
                    _Dot(active: i == _index),
                    if (i != pages.length - 1) const SizedBox(width: 8),
                  ],
                ],
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ).copyWith(bottom: 32),
                child: Row(
                  children: [
                    // BACK button (ẩn ở trang đầu -> giữ layout bằng SizedBox)
                    if (_index > 0)
                      Expanded(
                        child: GestureDetector(
                          onTap: _prev,
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE9EDF0),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Center(
                              child: Text(
                                'BACK',
                                style: TextStyle(
                                  color: Color(0xFF242C35),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      const SizedBox(width: 0),
                    if (_index > 0) const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: _next,
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [Color(0xFF2FD9FF), Color(0xFF0E33F3)],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x331D41F9),
                                blurRadius: 24,
                                offset: Offset(0, 12),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              _index == pages.length - 1 ? 'LET\'S GO' : 'NEXT',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ), // end Scaffold
    ); // end WillPopScope
  }
}

class _Dot extends StatelessWidget {
  final bool active;
  const _Dot({this.active = false});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: active ? const Color(0xFF0E33F3) : const Color(0xFFE0E4E7),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
