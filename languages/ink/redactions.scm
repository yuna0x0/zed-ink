; Text redactions for ink language
; These rules define what content should be redacted when sharing screens during collaboration

; Redact string values that might contain sensitive information
(string) @redact

; Redact variable assignments that might contain sensitive data
(var_line
  (value) @redact)

(const_line
  (value) @redact)

; Redact function arguments that might be sensitive
(arguments
  (argument
    (identifier) @redact))

; Redact identifiers in diverts that might reveal story structure
(divert
  (identifier_path) @redact)

; Redact tag content that might contain metadata
(tag
  (tag_remainder) @redact)

; Redact condition block content that might contain logic details
(condition_block_content) @redact

; Redact inline block content
(inline_block) @redact
