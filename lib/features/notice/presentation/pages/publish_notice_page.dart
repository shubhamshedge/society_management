import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/notice_entity.dart';
import '../bloc/notice_bloc.dart';
import '../bloc/notice_event.dart';
import '../bloc/notice_state.dart';

class PublishNoticePage extends StatefulWidget {
  final String societyId;
  final String societyName;
  final String chairmanName;

  const PublishNoticePage({
    super.key,
    required this.societyId,
    required this.societyName,
    required this.chairmanName,
  });

  @override
  State<PublishNoticePage> createState() => _PublishNoticePageState();
}

class _PublishNoticePageState extends State<PublishNoticePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  NoticeCategory _selectedCategory = NoticeCategory.meetingAgm;
  NoticePriority _selectedPriority = NoticePriority.high;
  bool _sendViaPush = true;
  bool _sendViaWhatsapp = true;

  @override
  void initState() {
    super.initState();
    context.read<NoticeBloc>().add(LoadNoticesEvent(widget.societyId));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _submitNotice() {
    if (_formKey.currentState?.validate() ?? false) {
      final notice = NoticeEntity(
        id: '',
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        category: _selectedCategory,
        priority: _selectedPriority,
        publishedBy: widget.chairmanName,
        publisherRole: 'Adhyaksha (Chairman)',
        publishedAt: DateTime.now(),
        totalRecipients: 40,
        sentViaPush: _sendViaPush,
        sentViaWhatsapp: _sendViaWhatsapp,
      );

      context.read<NoticeBloc>().add(
            PublishNoticeEvent(
              societyId: widget.societyId,
              notice: notice,
            ),
          );

      _titleController.clear();
      _contentController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Publish Official Notice',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            Text(
              '${widget.societyName} • Chairman Exclusive',
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
      body: BlocConsumer<NoticeBloc, NoticeState>(
        listener: (context, state) {
          if (state is NoticeLoadedState && state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 4),
              ),
            );
          }
          if (state is NoticeErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          final isPublishing = state is NoticePublishingState;
          final notices = state is NoticeLoadedState ? state.notices : [];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Executive Notice Authority Banner
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.adhyakshaColor, Color(0xFF9333EA)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.adhyakshaColor.withValues(alpha: 0.25),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.campaign_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Chairman Broadcast Portal',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Issued under signature of: ${widget.chairmanName}',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.85),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 2. Broadcast Notice Form
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Draft Circular (परिपत्रक तैयार करें)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Title
                        TextFormField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            labelText: 'Notice Title / Subject *',
                            hintText: 'e.g. Annual General Body Meeting (AGM) Notice',
                            prefixIcon: Icon(Icons.title_rounded),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter notice title';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        // Category Dropdown
                        DropdownButtonFormField<NoticeCategory>(
                          initialValue: _selectedCategory,
                          decoration: const InputDecoration(
                            labelText: 'Notice Category',
                            prefixIcon: Icon(Icons.category_rounded),
                          ),
                          items: NoticeCategory.values.map((cat) {
                            return DropdownMenuItem(
                              value: cat,
                              child: Text(cat.displayName),
                            );
                          }).toList(),
                          onChanged: (cat) {
                            if (cat != null) {
                              setState(() {
                                _selectedCategory = cat;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 14),

                        // Priority Radio Choice
                        const Text(
                          'Priority Level',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildPriorityChip(
                              label: 'Normal',
                              priority: NoticePriority.normal,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            _buildPriorityChip(
                              label: 'High Attention',
                              priority: NoticePriority.high,
                              color: AppColors.warning,
                            ),
                            const SizedBox(width: 8),
                            _buildPriorityChip(
                              label: 'Emergency Alert',
                              priority: NoticePriority.emergency,
                              color: AppColors.error,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Content
                        TextFormField(
                          controller: _contentController,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            labelText: 'Notice Content / Message Body *',
                            hintText:
                                'Write detailed message, meeting date, time, agenda or instructions for owners...',
                            alignLabelWithHint: true,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().length < 10) {
                              return 'Please enter detailed notice body (at least 10 chars)';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Target Recipients Card
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.15),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: const [
                                  Icon(Icons.group_rounded,
                                      size: 18, color: AppColors.primary),
                                  SizedBox(width: 8),
                                  Text(
                                    'Audience: All 40 Flat Owners & Residents',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              CheckboxListTile(
                                value: _sendViaPush,
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                controlAffinity: ListTileControlAffinity.leading,
                                title: const Text(
                                  'Instant Mobile Push Notification',
                                  style: TextStyle(fontSize: 12),
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    _sendViaPush = val ?? true;
                                  });
                                },
                              ),
                              CheckboxListTile(
                                value: _sendViaWhatsapp,
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                controlAffinity: ListTileControlAffinity.leading,
                                title: const Text(
                                  'Send WhatsApp Broadcast Copy',
                                  style: TextStyle(fontSize: 12),
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    _sendViaWhatsapp = val ?? true;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.adhyakshaColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: isPublishing
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Icon(Icons.send_rounded, size: 20),
                            label: Text(
                              isPublishing
                                  ? 'Broadcasting to Owners...'
                                  : 'Publish & Send to Every Owner',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            onPressed: isPublishing ? null : _submitNotice,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // 3. Previously Published Notices Feed
                  const Text(
                    'Published Circulars History',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (notices.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Text('No previous notices found'),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: notices.length,
                      itemBuilder: (context, index) {
                        final not = notices[index];
                        return _buildNoticeCard(not);
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPriorityChip({
    required String label,
    required NoticePriority priority,
    required Color color,
  }) {
    final isSelected = _selectedPriority == priority;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedPriority = priority;
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : color.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : color,
          ),
        ),
      ),
    );
  }

  Widget _buildNoticeCard(NoticeEntity notice) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  notice.category.displayName,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.done_all_rounded, size: 14, color: AppColors.success),
                  const SizedBox(width: 4),
                  Text(
                    'Sent to ${notice.totalRecipients} Owners',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            notice.title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            notice.content,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'By ${notice.publishedBy}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.adhyakshaColor,
                ),
              ),
              Text(
                '${notice.publishedAt.day}/${notice.publishedAt.month}/${notice.publishedAt.year}',
                style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
