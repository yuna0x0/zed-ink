; Language injections for ink language

; Inject ink content into inline blocks and condition blocks
; This allows proper syntax highlighting of ink code within these constructs
(inline_block
  (#set! injection.language "ink"))

(condition_block
  (#set! injection.language "ink"))

; Inject ink content into condition block content
(condition_block_content
  (#set! injection.language "ink"))

; Code text blocks (prefixed with ~) could contain expressions
(code_text
  (text) @injection.content
  (#set! injection.language "ink"))

; Block remainder in inline contexts
(block_remainder
  (#set! injection.language "ink"))
