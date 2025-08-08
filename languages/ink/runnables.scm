; Runnable code detection for ink language

; Detect knots as runnable sections
(knot_header
  (identifier) @run
  (#set! tag ink-knot))

; Detect functions as runnable sections
(function_header
  (identifier) @run
  (#set! tag ink-function))

; Detect the main program content as runnable
(program
  (#set! tag ink-story))
