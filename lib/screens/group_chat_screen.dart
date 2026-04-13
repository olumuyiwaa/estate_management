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
        padding: const EdgeInsets.fromLTRB(16,16,16,52),
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

class GroupChatRoomScreen extends StatefulWidget {
  final GroupChat chat;
  const GroupChatRoomScreen({super.key, required this.chat});

  @override
  State<GroupChatRoomScreen> createState() => _GroupChatRoomScreenState();
}

class _GroupChatRoomScreenState extends State<GroupChatRoomScreen> with SingleTickerProviderStateMixin {
  bool _participantsExpanded = false;

  void _showParticipantsSheet() {
    final participants = DummyData.groupChatParticipants(widget.chat);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final maxHeight = MediaQuery.of(context).size.height * 0.56;
        return Container(
          height: maxHeight,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 14),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Participants', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          Text('${participants.length} members', style: const TextStyle(fontSize: 12, color: AppTheme.textMid)),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded, color: AppTheme.textMid),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount: participants.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, indent: 84, endIndent: 20),
                  itemBuilder: (context, index) {
                    final member = participants[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                      leading: CircleAvatar(
                        backgroundColor: AppTheme.secondary.withOpacity(0.18),
                        child: Text(member.avatarInitials, style: const TextStyle(fontSize: 12, color: AppTheme.secondary)),
                      ),
                      title: Text(member.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final participants = DummyData.groupChatParticipants(widget.chat);
    final messages = DummyData.chatMessages.where((m) => m.groupId == widget.chat.id).toList();
    final showToggle = participants.length > 4;
    const collapsedHeight = 48.0;

    return Scaffold(
      appBar: EstateAppBar(
        title: widget.chat.title,
        actions: [
          IconButton(icon: const Icon(Icons.people_rounded, color: Colors.white), onPressed: _showParticipantsSheet),
        ],
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: showToggle ? () => setState(() => _participantsExpanded = !_participantsExpanded) : null,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: AppTheme.divider)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRect(
                    child: AnimatedSize(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: _participantsExpanded ? double.infinity : collapsedHeight),
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
                    ),
                  ),
                  if (showToggle)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            _participantsExpanded ? 'Show less' : 'Show all',
                            style: const TextStyle(fontSize: 12, color: AppTheme.accent),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            _participantsExpanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                            size: 18,
                            color: AppTheme.accent,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
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
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 52),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Send a message to ${widget.chat.title}',
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
