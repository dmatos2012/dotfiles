;;;; extends
; Somehow this below works in expanding the original syntax tree
; But if you remove one set of parenthesis, it doesnt work
; meaning ((struct_entry).... vs (struct_entry)....
;; Check content onto offset why it makes difference or not
;; BELOW CODE IS WORKING!!
;
;((struct_entry
;  (identifier) @name (#eq? @name "query")
;  (string
;    (raw_string) @injection.content)
;    (#offset! @injection.content 1 -7 0 -2)
;    (#set! injection.language "graphql")))
;;;

