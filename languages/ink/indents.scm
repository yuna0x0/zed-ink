; Auto-indentation rules for ink language

; Indent choices and their content
(option_text) @indent

; Indent gather points and their content
(gather_text) @indent

; Indent weave body content
; (weave_body_line) @indent

; Indent conditional blocks
(condition_block) @indent

; Indent inline blocks
(inline_block) @indent

; Indent function bodies
(function
  (weave_body) @indent)

; Indent knot bodies
(knot
  (weave_body) @indent)

; Indent stitch bodies
(stitch
  (weave_body) @indent)
