# config.nu
#
# Installed by:
# version = "0.102.1"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# This file is loaded after env.nu and before login.nu
#
# You can open this file in your default editor using:
# config nu
#
# See `help config nu` for more options
#
# You can remove these comments if you want or leave
# them for future reference.

# Remove the banner
$env.config.show_banner = false
$env.config.edit_mode = "vi"
$env.PROMPT_INDICATOR_VI_INSERT = {|| "" }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "" }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

# Env variables
$env.config.buffer_editor = "nvim"
$env.EDITOR = 'nvim'
$env.VISUAL = 'nvim'
$env.BROWSER = 'firefox'
$env.PIP_REQUIRE_VIRTUALENV = 1

$env.config.keybindings = [
{
    name: "move_right_or_take_history_hint"
    modifier: control
    keycode: char_n
    mode: [vi_insert, vi_normal]
    event: { until : [{send: historyhintcomplete}] }
      }
 {
    name: "move_one_word_right_or_take_history_hint"
    modifier: alt
    keycode: char_N
    mode: [vi_normal, vi_insert]
    event: {
        until: [
            { send: historyhintwordcomplete }
        ]
    }
}

]

$env.config.history = {
  file_format: sqlite
  max_size: 1_000_000
  sync_on_enter: true
  isolation: true
}
$env.config.cursor_shape = {
  vi_insert: "block"
  vi_normal: "underscore"
}

# Source things needed for my startup things

# Source zoxide
source ~/.zoxide.nu

# Source carapace
source ~/.cache/carapace/init.nu


#Source atuin
source ~/.local/share/atuin/init.nu

# My aliases
# Aliases
alias gs = git status
alias gc = git checkout
alias xo = xdg-open
# alias gl = git log --oneline
alias gl = git lg
alias ssh = kitty +kitten ssh


# Clean dangling docker images
def docker-clean () {

    let dangling_images = docker images -a --filter=dangling=true -q --no-trunc | lines;
    let is_empty = $dangling_images | is-empty;
    if not $is_empty {
        $dangling_images | docker rmi ...$in -f
        docker ps --filter=status=exited --filter=status=created -q | lines | docker rm ...$in
    }
}
# Delete local branches except specified
def git-del-branches-except (
    excepts:list   # don't delete branch in the list
) {
    let branches = (git branch | lines | str trim)
    let remote_branches = (git branch -r | lines | str replace '^.+?/' '' | uniq)
    $branches | each {|it|
        # if ($it not-in $excepts) and ($it not-in $remote_branches) and (not ($it | str starts-with "*")) {
        if ($it not-in $excepts)  and (not ($it | str starts-with "*")) {
            git branch -D $it
        }
    }
}

# Number commits since `HEAD` was branched from `main`
def git-commits-since-creation (main: string) {
    git rev-list --count --first-parent $"($main)..HEAD"
}

# Source the work nufile that SHOULD NOT BE COMMITED
source work.nu

# Add deno to path(For peek.nvim)
$env.PATH = ($env.PATH | split row (char esep) | prepend '/home/david/.deno/bin')

# Add fzf to path

$env.PATH = ($env.PATH | split row (char esep) | prepend '/home/david/.fzf/bin')

# Add rbenv to path

$env.PATH = ($env.PATH | split row (char esep) | prepend '/home/david/.rbenv/bin')
$env.PATH = ($env.PATH | split row (char esep) | prepend '/home/david/.rbenv/shims')

# Add lua-language-server to path
$env.PATH = ($env.PATH | split row (char esep) | prepend '/home/david/build/lua-language-server/bin/')




# ADD Cuda related ENV variables (Cuda is symlink to cuda 11.3 for me)
$env.PATH = ($env.PATH | split row (char esep) | prepend '/usr/local/cuda/bin')
$env.LD_LIBRARY_PATH = '/usr/local/cuda/lib64'

# ADD zig to path
$env.PATH = ($env.PATH | split row (char esep) | prepend '/home/david/.local/zig-linux-x86_64-0.14.0/')

# Add flutter to path

$env.PATH = ($env.PATH | split row (char esep) | prepend '/home/david/build/flutter-dev/flutter/bin')


# Add opencode to path
$env.PATH = ($env.PATH | split row (char esep) | prepend '/home/david/.opencode/bin')


# Add support for FNM
# Taken from https://github.com/Schniz/fnm/issues/463
use std "path add"
if not (which fnm | is-empty) {
  ^fnm env --json | from json | load-env
  let node_path = match $nu.os-info.name {
    "windows" => $"($env.FNM_MULTISHELL_PATH)",
    _ => $"($env.FNM_MULTISHELL_PATH)/bin",
  }
  path add $node_path
}

# SSH agent

do --env {
    let ssh_agent_file = (
        $nu.temp-path | path join $"ssh-agent-($env.USER? | default $env.USERNAME).nuon"
    )

    if ($ssh_agent_file | path exists) {
        let ssh_agent_env = open ($ssh_agent_file)
        if ($"/proc/($ssh_agent_env.SSH_AGENT_PID)" | path exists) {
            load-env $ssh_agent_env
            return
        } else {
            rm $ssh_agent_file
        }
    }

    let ssh_agent_env = ^ssh-agent -c
        | lines
        | first 2
        | parse "setenv {name} {value};"
        | transpose --header-row
        | into record
    load-env $ssh_agent_env
    $ssh_agent_env | save --force $ssh_agent_file
}
# OPAM env variables for OCAML usage
do --env {
    let opam_env_vars = ^opam env
        | lines
        | where $it != is-empty
        | split column "=" name value
        | update value {split column ";" path | get path.0 | str trim -c "'"}
        | reduce -f {} {|it acc| $acc | insert $it.name $it.value }
    load-env $opam_env_vars

}

$env.ENV_CONVERSIONS = {
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}
