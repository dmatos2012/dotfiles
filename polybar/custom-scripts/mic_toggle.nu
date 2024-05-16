#!/usr/bin/env nu
def "main show_mute_icon" [] {
    let index_muted = pacmd list-sources | lines | find "* index" "muted" | enumerate | where {$in.item =~ 'index'} | $in.index | $in.0 + 1
    let is_muted = pacmd list-sources | lines | find "* index" "muted" | get 2 | split words -l 2 | last

    let icon = if $is_muted == "yes" {""} else {""}

    $icon
}

def "main toggle_mute" [] {
    let index_muted = pacmd list-sources | lines | find "* index" "muted" | enumerate | where {$in.item =~ 'index'} | $in.index | $in.0 + 1
    let toggle_mute = pacmd list-sources | lines | find "* index" "muted" | get 2 | split words -l 2 | last | if $in == "no" {1} else {0}
    # index 3 is hardcoded, will it always be the same?
    pacmd set-source-mute 3 $toggle_mute

}

def main [] {
}

