;;;; extends
; Somehow this below works in expanding the original syntax tree
; But if you remove one set of parenthesis, it doesnt work
; meaning ((struct_entry).... vs (struct_entry)....
;; Check content onto offset why it makes difference or not
;; BELOW CODE IS WORKING!!
;
((struct_entry
  (identifier) @name (#eq? @name "query")
  (string
    (raw_string) @injection.content)
    ;;remove the opening r#" and any whitespace up to the first non-empty line.
    (#gsub! @injection.content "^r#\"\\s*\n\\s*" "") ;;
    ;;remove the closing "# and any preceding whitespace.
    (#gsub! @injection.content "\\s*\"#$" "")
    ;; Removed offset since it wasnt very robust
    ;(#offset! @injection.content 1 -7 0 0)
    (#set! injection.language "graphql")))
;;;

