; Text objects for ink language (Vim mode navigation)

; Functions - entire function definitions
(function) @function.around

; Function body content (inside the function)
(function
  (weave_body) @function.inside)

; Knots as class-like structures (large sections)
(knot) @class.around

; Knot body content
(knot
  (weave_body) @class.inside)

; Stitches as method-like structures
(stitch) @function.around

; Stitch body content
(stitch
  (weave_body) @function.inside)

; Comments
(line_comment) @comment.around
(block_comment) @comment.around

; Comment content (inside comments)
(block_comment
  ((_)*) @comment.inside)

; Conditional blocks as functions
(condition_block) @function.around

; Conditional block content
(condition_block
  (condition_block_content) @function.inside)

; Inline blocks
(inline_block) @function.around
