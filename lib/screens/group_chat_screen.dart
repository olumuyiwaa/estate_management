import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';

class GroupChatScreen extends StatelessWidget {
  const GroupChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EstateAppBar(title: 'Group Chat'),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: DummyData.groupChats.length,
        itemBuilder: (_, index) {
          final chat = DummyData.groupChats[index];
          final participantCount = DummyData.groupChatParticipants(chat).length;
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => GroupChatRoomScreen(chat: chat)),
            ),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppTheme.divider),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppTheme.accentLight.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.chat_rounded, color: AppTheme.accent, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(chat.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        Text(chat.description, style: const TextStyle(fontSize: 12, color: AppTheme.textMid), maxLines: 2, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('$participantCount participants', style: const TextStyle(fontSize: 11, color: AppTheme.textMid)),
                      const SizedBox(height: 4),
                      StatusBadge(label: 'Open', color: AppTheme.success),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class GroupChatRoomScreen extends StatelessWidget {
  final GroupChat chat;
  const GroupChatRoomScreen({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    final participants = DummyData.groupChatParticipants(chat);
    final messages = DummyData.chatMessages.where((m) => m.groupId == chat.id).toList();

    return Scaffold(
      appBar: EstateAppBar(
        title: chat.title,
        actions: [
          IconButton(icon: const Icon(Icons.people_rounded, color: Colors.white), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: AppTheme.divider)),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: participants.map((member) {
                return Chip(
                  backgroundColor: AppTheme.surface,
                  label: Text(member.name, style: const TextStyle(fontSize: 12)),
                  avatar: CircleAvatar(
                    radius: 12,
                    backgroundColor: AppTheme.secondary.withOpacity(0.18),
                    child: Text(member.avatarInitials, style: const TextStyle(fontSize: 11, color: AppTheme.secondary)),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: messages.isEmpty
                ? const Center(child: Text('No messages yet. Start the conversation below.', style: TextStyle(color: AppTheme.textMid)))
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    itemCount: messages.length,
                    itemBuilder: (_, index) {
                      final message = messages[index];
                      final isMe = message.sender == DummyData.currentUser.name;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: isMe ? AppTheme.accent.withOpacity(0.12) : AppTheme.surface,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft: Radius.circular(isMe ? 16 : 4),
                              bottomRight: Radius.circular(isMe ? 4 : 16),
                            ),
                            border: Border.all(color: AppTheme.divider),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(message.sender, style: const TextStyle(fontSize: 11, color: AppTheme.textMid)),
                              const SizedBox(height: 6),
                              Text(message.text, style: const TextStyle(fontSize: 14, height: 1.4)),
                              const SizedBox(height: 6),
                              Text(
                                message.timestamp,
                                style: const TextStyle(fontSize: 10, color: AppTheme.textLight),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Send a message to ${chat.title}',
                      suffixIcon: const Icon(Icons.send_rounded, color: AppTheme.accent),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: AppTheme.divider),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: AppTheme.divider),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.accent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.send_rounded, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
