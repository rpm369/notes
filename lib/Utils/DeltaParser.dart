import 'dart:convert';

class DeltaParser {
  /// Parses the raw Quill Delta JSON string into clean, readable plain text.
  /// If the string is not valid JSON, it returns the string as-is.
  static String parseToPlainText(String? content) {
    if (content == null || content.isEmpty) return "";
    
    final trimmed = content.trim();
    if (!trimmed.startsWith('[') || !trimmed.endsWith(']')) {
      return content;
    }

    try {
      final decoded = jsonDecode(content);
      if (decoded is List) {
        final buffer = StringBuffer();
        for (final op in decoded) {
          if (op is Map && op.containsKey('insert')) {
            final insert = op['insert'];
            if (insert is String) {
              buffer.write(insert);
            }
          }
        }
        return buffer.toString().trim();
      }
    } catch (_) {
      // Fallback to original content
    }
    return content;
  }
}
