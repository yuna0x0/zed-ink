; Code outline for ink language

; Knots (main story sections)
(knot_header
  (identifier) @name) @item

; Stitches (subsections within knots)
(stitch_header
  (identifier) @name) @item

; Functions
(function_header
  (identifier) @name) @item

; Labeled gather points and options for context
(label
  (identifier) @context)

; Variable declarations
(var_line
  (identifier) @name) @item

; Constant declarations
(const_line
  (identifier) @name) @item

; List declarations
(list_line
  (identifier) @name) @item
