; tags and labels
(label) @label
(tag (identifier) @comment)
(tag) @comment

; values
(identifier) @variable
(string) @string
(boolean) @constant
(number) @constant.numeric

; headers
(knot_header) @keyword
(stitch_header) @keyword
(function_header) @keyword

; marks (ink)
(option_mark) @keyword.directive
(gather_mark) @operator
(glue) @operator

; flow control
(divert_or_thread) @function
(arrow) @operator
(double_arrow) @operator
(back_arrow) @operator

; operators
(assignment) @operator
(dot) @punctuation

; brackets and delimiters
(mark_start) @punctuation.bracket
(mark_end) @punctuation.bracket
(hide_start) @punctuation.bracket
(hide_end) @punctuation.bracket

; declarations
(var_line (identifier) @variable.special)
(const_line (identifier) @constant)
(list_line (identifier) @type)

; comments
(line_comment) @comment
(block_comment) @comment

; code blocks
(inline_block) @string.special
(condition_block) @string.special
(code_text) @string.special
