import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:notes/Components/NotesDetail/ReminderCheckDialog.dart';
import 'package:provider/provider.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/Models/NotesModel.dart';
import 'package:notes/ViewModels/NotesDetailViewModel.dart';
import 'package:notes/Components/NotesDetail/NotesDetailAppBar.dart';
import 'package:notes/Components/NotesDetail/NotesDetailToolbar.dart';
import 'package:notes/Components/NotesDetail/FontSelectionSheet.dart';
import 'package:notes/Components/NotesDetail/ReminderSetDialog.dart';
import 'package:image_picker/image_picker.dart';

class NotesDetailView extends StatefulWidget {
  final NotesModel? existingNote;

  const NotesDetailView({super.key, this.existingNote});

  @override
  State<NotesDetailView> createState() => _NotesDetailViewState();
}

class _NotesDetailViewState extends State<NotesDetailView> {
  final TextEditingController _titleController = TextEditingController();
  late QuillController _quillController;
  final FocusNode _editorFocusNode = FocusNode();

  bool _isFormattingMode = false;
  String _selectedFontFamily = "";
  int _charCount = 0;

  // Active styles state
  bool _isBold = false;
  bool _isItalic = false;
  bool _isUnderline = false;
  bool _isHighlighted = false;

  @override
  void initState() {
    super.initState();
    _quillController = QuillController.basic();

    _titleController.addListener(_updateCharCount);
    _quillController.addListener(_onEditorStateChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final viewModel = context.read<NotesDetailViewModel>();
      await viewModel.initNote(widget.existingNote);

      if (viewModel.currentNote != null) {
        _titleController.text = viewModel.currentNote!.title ?? "";

        var contentStr = viewModel.currentNote!.content ?? "";
        if (contentStr.isNotEmpty) {
          contentStr = viewModel.resolveImagePathsInContent(contentStr);
          try {
            final jsonContent = jsonDecode(contentStr);
            _quillController.document = Document.fromJson(jsonContent);
          } catch (e) {
            // Fallback to plain text if JSON parsing fails
            _quillController.document = Document()..insert(0, contentStr);
          }
        }
        _updateCharCount();
      }
    });
  }

  @override
  void dispose() {
    _titleController.removeListener(_updateCharCount);
    _quillController.removeListener(_onEditorStateChanged);
    _titleController.dispose();
    _quillController.dispose();
    _editorFocusNode.dispose();
    super.dispose();
  }

  void _updateCharCount() {
    // Document length always includes trailing newline (\n), so subtract 1
    final quillLength = _quillController.document.length - 1;
    setState(() {
      _charCount =
          _titleController.text.length + (quillLength < 0 ? 0 : quillLength);
    });
  }

  void _onEditorStateChanged() {
    _updateCharCount();

    // Update style highlights in toolbar based on cursor position/selection style
    final selectionStyle = _quillController.getSelectionStyle();
    setState(() {
      _isBold = selectionStyle.containsKey(Attribute.bold.key);
      _isItalic = selectionStyle.containsKey(Attribute.italic.key);
      _isUnderline = selectionStyle.containsKey(Attribute.underline.key);
      _isHighlighted = selectionStyle.containsKey(Attribute.background.key);
    });

    // Sync image list in VM with editor changes
    final deltaJson = _quillController.document.toDelta().toJson();
    context.read<NotesDetailViewModel>().syncImagesFromDelta(
      deltaJson.map((e) => Map<String, dynamic>.from(e)).toList(),
    );
  }

  void _formatBold() {
    final style = _quillController.getSelectionStyle();
    if (style.containsKey(Attribute.bold.key)) {
      _quillController.formatSelection(Attribute.clone(Attribute.bold, null));
    } else {
      _quillController.formatSelection(Attribute.bold);
    }
  }

  void _formatItalic() {
    final style = _quillController.getSelectionStyle();
    if (style.containsKey(Attribute.italic.key)) {
      _quillController.formatSelection(Attribute.clone(Attribute.italic, null));
    } else {
      _quillController.formatSelection(Attribute.italic);
    }
  }

  void _formatUnderline() {
    final style = _quillController.getSelectionStyle();
    if (style.containsKey(Attribute.underline.key)) {
      _quillController.formatSelection(
        Attribute.clone(Attribute.underline, null),
      );
    } else {
      _quillController.formatSelection(Attribute.underline);
    }
  }

  void _formatHighlight() {
    final style = _quillController.getSelectionStyle();
    if (style.containsKey(Attribute.background.key)) {
      _quillController.formatSelection(
        Attribute.clone(Attribute.background, null),
      );
    } else {
      // Apply yellow color highlight using hex string clone
      _quillController.formatSelection(
        Attribute.clone(Attribute.background, '#FFFFD54F'),
      );
    }
  }

  void _showFontSelectionSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return FontSelectionSheet(
          selectedFontFamily: _selectedFontFamily,
          onFontSelected: (font) {
            setState(() {
              _selectedFontFamily = font;
            });
          },
        );
      },
    );
  }

  Future<void> reviewReminder() async {
    showDialog(
      context: context,
      builder: (context) {
        return ReminderCheckDialog(
          noteTitle: _titleController.text.isEmpty
              ? "Untitled"
              : _titleController.text,
          reminderTime: context
              .read<NotesDetailViewModel>()
              .getCurrentReminder()!,
          onCancel: () async {
            final viewModel = context.read<NotesDetailViewModel>();
            await viewModel.updateReminder(null);
            if (context.mounted) {
              Navigator.pop(context);
            }
          },
          onBackPress: () => Navigator.pop(context),
        );
      },
    );
  }

  Future<void> _insertImage() async {
    final ImagePicker picker = ImagePicker();

    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: const Color(0xFF1E1B1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  "Select Image Source",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: Color(0xFFBE9375),
                ),
                title: const Text(
                  "Gallery",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFFBE9375)),
                title: const Text(
                  "Camera",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );

    if (!mounted) return;
    if (source == null) return;

    final List<XFile> images = [];
    if (source == ImageSource.gallery) {
      final List<XFile> pickedImages = await picker.pickMultiImage();
      if (!mounted) return;
      if (pickedImages.isNotEmpty) {
        images.addAll(pickedImages);
      }
    } else {
      final XFile? imageFile = await picker.pickImage(
        source: ImageSource.camera,
      );
      if (!mounted) return;
      if (imageFile != null) {
        images.add(imageFile);
      }
    }

    if (images.isEmpty) return;

    final viewModel = context.read<NotesDetailViewModel>();
    final List<String> filePaths = images.map((img) => img.path).toList();

    // Batch add to VM
    viewModel.addInsertedImages(filePaths);

    // Disable editor listener during batch insertion to prevent rebuild crashes
    _quillController.removeListener(_onEditorStateChanged);

    try {
      int insertIndex = _quillController.selection.baseOffset;
      if (insertIndex < 0) insertIndex = 0;

      for (final filePath in filePaths) {
        _quillController.document.insert(
          insertIndex,
          BlockEmbed.image(filePath),
        );
        _quillController.document.insert(insertIndex + 1, "\n");
        insertIndex += 2;
      }

      _quillController.updateSelection(
        TextSelection.collapsed(offset: insertIndex),
        ChangeSource.local,
      );
    } finally {
      // Re-enable listener and notify single state change
      _quillController.addListener(_onEditorStateChanged);
      _onEditorStateChanged();
    }
  }

  Future<void> _selectReminderTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFBE9375),
              onPrimary: Colors.black,
              surface: Color(0xFF282321),
              onSurface: Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFBE9375),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return;

    if (!mounted) return;
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFBE9375),
              onPrimary: Colors.black,
              surface: Color(0xFF282321),
              onSurface: Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFBE9375),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime == null) return;

    final reminderDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    if (reminderDateTime.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Select the Valid Date and Time"),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) {
        return ReminderSetDialog(
          noteTitle: _titleController.text.isEmpty
              ? "Untitled"
              : _titleController.text,
          reminderTime: reminderDateTime,
          onCancel: () => Navigator.pop(context),
          onConfirm: () async {
            final viewModel = context.read<NotesDetailViewModel>();
            await viewModel.updateReminder(reminderDateTime);
            if (context.mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Reminder scheduled for ${reminderDateTime.toString().split('.')[0]}",
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
        );
      },
    );
  }

  Future<void> _saveNote() async {
    final viewModel = context.read<NotesDetailViewModel>();
    final contentJson = jsonEncode(
      _quillController.document.toDelta().toJson(),
    );
    await viewModel.saveNote(
      title: _titleController.text.trim(),
      content: contentJson,
    );
    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NotesDetailViewModel>();

    if (viewModel.isLoading && viewModel.currentNote == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF131110),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFBE9375)),
        ),
      );
    }

    final currentBlockId = viewModel.currentNote?.blockId;

    // Build Custom Styles for QuillEditor typography customization
    final defaultTextStyle = TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontFamily: _selectedFontFamily.isNotEmpty ? _selectedFontFamily : null,
      height: 1.5,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF131110), // Warm dark background
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            NotesDetailAppBar(
              currentBlockId: currentBlockId,
              blocks: viewModel.blocks,
              onBack: () => Navigator.pop(context),
              onSave: _saveNote,
              onBlockChanged: (blockId) {
                // If dummy pinned value was selected, treat it as null for now
                viewModel.updateBlockAssociation(blockId);
              },
            ),

            // Character Count Banner
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                "$_charCount chars",
                style: const TextStyle(
                  color: Color(0xFFBE9375),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Title input
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 8.0,
              ),
              child: TextField(
                controller: _titleController,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
                cursorColor: const Color(0xFFBE9375),
                decoration: const InputDecoration(
                  hintText: "Title",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),

            // Editor
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: DefaultTextStyle(
                  style: defaultTextStyle,
                  child: QuillEditor.basic(
                    controller: _quillController,
                    focusNode: _editorFocusNode,
                    config: QuillEditorConfig(
                      placeholder: "Start writing...",
                      embedBuilders: [NotesImageEmbedBuilder()],
                    ),
                  ),
                ),
              ),
            ),

            // Bottom Toolbar
            NotesDetailToolbar(
              hasReminder: viewModel.hasReminder,
              isFormattingMode: _isFormattingMode,
              isBold: _isBold,
              isItalic: _isItalic,
              isUnderline: _isUnderline,
              isHighlighted: _isHighlighted,
              onToggleFormatting: () {
                setState(() {
                  _isFormattingMode = !_isFormattingMode;
                });
              },
              onBoldTap: _formatBold,
              onItalicTap: _formatItalic,
              onUnderlineTap: _formatUnderline,
              onHighlightTap: _formatHighlight,
              onFontTap: _showFontSelectionSheet,
              onReminderTap: () => (viewModel.hasReminder
                  ? reviewReminder()
                  : _selectReminderTime()),
              onInsertImageTap: _insertImage,
            ),
          ],
        ),
      ),
    );
  }
}

class NotesImageEmbedBuilder extends EmbedBuilder {
  @override
  String get key => BlockEmbed.imageType;

  @override
  bool get expanded => false;

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    final imageUrl = embedContext.node.value.data;
    if (imageUrl is! String || imageUrl.isEmpty) {
      return const SizedBox.shrink();
    }

    Widget imageWidget;
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      imageWidget = Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image, color: Colors.redAccent, size: 60),
      );
    } else {
      final file = File(imageUrl);
      if (file.existsSync()) {
        imageWidget = Image.file(
          file,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.broken_image, color: Colors.redAccent, size: 60),
        );
      } else {
        imageWidget = const Icon(
          Icons.broken_image,
          color: Colors.grey,
          size: 60,
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: imageWidget,
      ),
    );
  }
}
