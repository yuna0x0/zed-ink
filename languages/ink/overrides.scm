; Syntax overrides for ink language
; These define scopes that can override editor settings within specific language constructs

; String contexts - for when cursor is inside strings
(string) @string

; Comment contexts - for when cursor is inside comments
(line_comment) @comment
(block_comment) @comment

; Code contexts - for when cursor is inside code blocks
(code_text) @code
(inline_block) @code
(condition_block) @code

; Choice contexts - for when editing choice text
(option_text) @choice
(option_words) @choice

; Gather contexts - for when editing gather points
(gather_text) @gather

; Dialog contexts - for when editing dialog/story text
(dialog_text) @dialog
(text) @dialog

; Label contexts - for when editing labels
(label) @label

; Tag contexts - for when editing tags
(tag) @tag

; Function contexts - for when inside function definitions
(function
  (weave_body)) @function_body

; Knot contexts - for when inside knot definitions
(knot
  (weave_body)) @knot_body

; Variable declaration contexts
(var_line) @variable_declaration
(const_line) @constant_declaration
(list_line) @list_declaration
