import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../widgets/avatar.dart';

class _Message {
  final String text;
  final bool mine;
  const _Message(this.text, this.mine);
}

/// 1:1 채팅 화면 (MVP: 로컬 상태만).
class ChatScreen extends StatefulWidget {
  final String peerName;
  const ChatScreen({super.key, required this.peerName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _ctrl = TextEditingController();
  final _scroll = ScrollController();
  final List<_Message> _messages = [
    const _Message('안녕하세요! 예약 문의 드립니다.', true),
    const _Message('안녕하세요 고객님, 무엇을 도와드릴까요?', false),
    const _Message('주차 가능한 곳이 있을까요?', true),
    const _Message('네, 건물 지하에 방문객 주차가 가능합니다 :)', false),
  ];

  @override
  void dispose() {
    _ctrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send() {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_Message(text, true));
      _ctrl.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Avatar(name: widget.peerName, size: 32),
            const SizedBox(width: 8),
            Text(widget.peerName),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.all(AppSizes.lg),
              itemCount: _messages.length,
              itemBuilder: (_, i) => _bubble(_messages[i]),
            ),
          ),
          _inputBar(),
        ],
      ),
    );
  }

  Widget _bubble(_Message m) {
    return Align(
      alignment: m.mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.72),
        decoration: BoxDecoration(
          color: m.mine ? AppColors.navy : AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(m.mine ? 16 : 4),
            bottomRight: Radius.circular(m.mine ? 4 : 16),
          ),
          border: m.mine ? null : Border.all(color: AppColors.border),
        ),
        child: Text(
          m.text,
          style: TextStyle(
            fontSize: 14.5,
            height: 1.4,
            color: m.mine ? AppColors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _inputBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSizes.md,
        AppSizes.sm,
        AppSizes.md,
        AppSizes.sm + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _ctrl,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _send(),
              decoration: InputDecoration(
                hintText: '메시지를 입력하세요',
                fillColor: AppColors.background,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.lg, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _send,
            child: Container(
              width: 46,
              height: 46,
              decoration: const BoxDecoration(
                  color: AppColors.navy, shape: BoxShape.circle),
              child: const Icon(Icons.arrow_upward_rounded,
                  color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}
