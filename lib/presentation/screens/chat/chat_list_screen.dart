import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../data/repositories/mock_repository.dart';
import '../../widgets/avatar.dart';
import 'chat_screen.dart';

class _ChatPreview {
  final String name;
  final String lastMessage;
  final String time;
  final int unread;
  const _ChatPreview(this.name, this.lastMessage, this.time, this.unread);
}

/// 채팅 목록 화면.
class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  static final _previews = [
    _ChatPreview(MockRepository.therapists[0].name,
        '네, 예약하신 시간에 방문하겠습니다 :)', '오후 2:14', 2),
    _ChatPreview(MockRepository.therapists[1].name,
        '리뷰 남겨주셔서 감사합니다!', '어제', 0),
    _ChatPreview(MockRepository.therapists[2].name,
        '주차 가능한 곳이 있을까요?', '6월 28일', 0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('채팅'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
        itemCount: _previews.length,
        separatorBuilder: (_, __) => const Divider(
            indent: 82, endIndent: AppSizes.screenPadding, height: 1),
        itemBuilder: (_, i) {
          final p = _previews[i];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSizes.screenPadding, vertical: 6),
            leading: Avatar(name: p.name, size: 52),
            title: Text(p.name,
                style: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 15.5)),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(p.lastMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 13.5, color: AppColors.textSecondary)),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(p.time,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textHint)),
                const SizedBox(height: 6),
                if (p.unread > 0)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                        color: AppColors.navy, shape: BoxShape.circle),
                    child: Text('${p.unread}',
                        style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            height: 1)),
                  )
                else
                  const SizedBox(height: 20),
              ],
            ),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (_) => ChatScreen(peerName: p.name)),
            ),
          );
        },
      ),
    );
  }
}
