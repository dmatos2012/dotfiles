;;;; extends
; Somehow this below works in expanding the original syntax tree
; But if you remove one set of parenthesis, it doesnt work
; meaning ((struct_entry).... vs (struct_entry)....
;
((struct_entry
  (identifier) @name (#eq? @name "query")
  (string
    (raw_string) @injection.content)
    (#offset! @injection.content 1 -7 0 -2)
    (#set! injection.language "graphql")))
;;;

