# Nushell Config File
# version = 0.80.1

# For more information on defining custom themes, see
# https://www.nushell.sh/book/coloring_and_theming.html
# And here is the theme collection
# https://github.com/nushell/nu_scripts/tree/main/themes
let theme = {
    separator: "#6e7781"
    leading_trailing_space_bg: { attr: "n" }
    header: { fg: "#116329" attr: "b" }
    empty: "#0969da"
    bool: {|| if $in { "#3192aa" } else { "light_gray" } }
    int: "#6e7781"
    filesize: {|e|
        if $e == 0b {
            "#6e7781"
        } else if $e < 1mb {
            "#1b7c83"
        } else {{ fg: "#0969da" }}
    }
    duration: "#6e7781"
    date: {|| (date now) - $in |
        if $in < 1hr {
            { fg: "#cf222e" attr: "b" }
        } else if $in < 6hr {
            "#cf222e"
        } else if $in < 1day {
            "#4d2d00"
        } else if $in < 3day {
            "#116329"
        } else if $in < 1wk {
            { fg: "#116329" attr: "b" }
        } else if $in < 6wk {
            "#1b7c83"
        } else if $in < 52wk {
            "#0969da"
        } else { "dark_gray" }
    }
    range: "#6e7781"
    float: "#6e7781"
    string: "#6e7781"
    nothing: "#6e7781"
    binary: "#6e7781"
    cellpath: "#6e7781"
    row_index: { fg: "#116329" attr: "b" }
    record: "#6e7781"
    list: "#6e7781"
    block: "#6e7781"
    hints: "dark_gray"
    search_result: { fg: "#cf222e" bg: "#6e7781" }

    shape_and: { fg: "#8250df" attr: "b" }
    shape_binary: { fg: "#8250df" attr: "b" }
    shape_block: { fg: "#0969da" attr: "b" }
    shape_bool: "#3192aa"
    shape_custom: "#116329"
    shape_datetime: { fg: "#1b7c83" attr: "b" }
    shape_directory: "#1b7c83"
    shape_external: "#1b7c83"
    shape_externalarg: { fg: "#116329" attr: "b" }
    shape_filepath: "#1b7c83"
    shape_flag: { fg: "#0969da" attr: "b" }
    shape_float: { fg: "#8250df" attr: "b" }
    shape_garbage: { fg: "#FFFFFF" bg: "#FF0000" attr: "b" }
    shape_globpattern: { fg: "#1b7c83" attr: "b" }
    shape_int: { fg: "#8250df" attr: "b" }
    shape_internalcall: { fg: "#1b7c83" attr: "b" }
    shape_list: { fg: "#1b7c83" attr: "b" }
    shape_literal: "#0969da"
    shape_match_pattern: "#116329"
    shape_matching_brackets: { attr: "u" }
    shape_nothing: "#3192aa"
    shape_operator: "#4d2d00"
    shape_or: { fg: "#8250df" attr: "b" }
    shape_pipe: { fg: "#8250df" attr: "b" }
    shape_range: { fg: "#4d2d00" attr: "b" }
    shape_record: { fg: "#1b7c83" attr: "b" }
    shape_redirection: { fg: "#8250df" attr: "b" }
    shape_signature: { fg: "#116329" attr: "b" }
    shape_string: "#116329"
    shape_string_interpolation: { fg: "#1b7c83" attr: "b" }
    shape_table: { fg: "#0969da" attr: "b" }
    shape_variable: "#8250df"

    background: "#ffffff"
    foreground: "#0E1116"
    cursor: "#0969da"
}

let-env config = {
  show_banner: false
  ls: {
    use_ls_colors: true
    clickable_links: true
  }
  rm: {
    always_trash: false
  }
  cd: {
    abbreviations: false
  }
  table: {
    mode: rounded
    index_mode: always
    show_empty: true
    trim: {
      methodology: wrapping
      wrapping_try_keep_words: true
      truncating_suffix: "..."
    }
  }

  explore: {
    help_banner: true
    exit_esc: true

    command_bar_text: '#C4C9C6'
    status_bar_background: {fg: '#1D1F21' bg: '#C4C9C6' }
    highlight: {bg: 'yellow' fg: 'black' }

    table: {
      split_line: '#404040'
      cursor: true
      line_index: true
      line_shift: true
      line_head_top: true
      line_head_bottom: true
      show_head: true
      show_index: true
    }

    config: {
      cursor_color: {bg: 'yellow' fg: 'black' }
    }
  }

  history: {
    max_size: 10000
    sync_on_enter: true
    file_format: "plaintext"
  }
  completions: {
    case_sensitive: false
    quick: true
    partial: true
    algorithm: "prefix"
    external: {
      enable: true
      max_results: 100
      completer: null
    }
  }
  filesize: {
    metric: true
    format: "auto"
  }
  cursor_shape: {
    emacs: line
    vi_insert: block
    vi_normal: underscore
  }
  color_config: $theme
  use_grid_icons: true
  footer_mode: "25"
  float_precision: 2
  # buffer_editor: "emacs"
  use_ansi_coloring: true
  bracketed_paste: true
  edit_mode: vi
  shell_integration: true
  render_right_prompt_on_last_line: false

  hooks: {
    pre_prompt: [{||
      null
    }]
    pre_execution: [{||
      null
    }]
    env_change: {
      PWD: [{|before, after|
        null
      }]
    }
    display_output: {||
      if (term size).columns >= 100 { table -e } else { table }
    }
    command_not_found: {||
      null
    }
  }
  menus: [
      # Configuration for default nushell menus
      # Note the lack of source parameter
      {
        name: completion_menu
        only_buffer_difference: false
        marker: "| "
        type: {
            layout: columnar
            columns: 4
            col_width: 20   # Optional value. If missing all the screen width is used to calculate column width
            col_padding: 2
        }
        style: {
            text: green
            selected_text: green_reverse
            description_text: yellow
        }
      }
      {
        name: history_menu
        only_buffer_difference: true
        marker: "? "
        type: {
            layout: list
            page_size: 10
        }
        style: {
            text: green
            selected_text: green_reverse
            description_text: yellow
        }
      }
      {
        name: help_menu
        only_buffer_difference: true
        marker: "? "
        type: {
            layout: description
            columns: 4
            col_width: 20
            col_padding: 2
            selection_rows: 4
            description_rows: 10
        }
        style: {
            text: green
            selected_text: green_reverse
            description_text: yellow
        }
      }
      # Example of extra menus created using a nushell source
      # Use the source field to create a list of records that populates
      # the menu
      {
        name: commands_menu
        only_buffer_difference: false
        marker: "# "
        type: {
            layout: columnar
            columns: 4
            col_width: 20
            col_padding: 2
        }
        style: {
            text: green
            selected_text: green_reverse
            description_text: yellow
        }
        source: { |buffer, position|
            $nu.scope.commands
            | where name =~ $buffer
            | each { |it| {value: $it.name description: $it.usage} }
        }
      }
      {
        name: vars_menu
        only_buffer_difference: true
        marker: "# "
        type: {
            layout: list
            page_size: 10
        }
        style: {
            text: green
            selected_text: green_reverse
            description_text: yellow
        }
        source: { |buffer, position|
            $nu.scope.vars
            | where name =~ $buffer
            | sort-by name
            | each { |it| {value: $it.name description: $it.type} }
        }
      }
      {
        name: commands_with_description
        only_buffer_difference: true
        marker: "# "
        type: {
            layout: description
            columns: 4
            col_width: 20
            col_padding: 2
            selection_rows: 4
            description_rows: 10
        }
        style: {
            text: green
            selected_text: green_reverse
            description_text: yellow
        }
        source: { |buffer, position|
            $nu.scope.commands
            | where name =~ $buffer
            | each { |it| {value: $it.name description: $it.usage} }
        }
      }
  ]
  keybindings: [
    {
      name: completion_menu
      modifier: none
      keycode: tab
      mode: [emacs vi_normal vi_insert]
      event: {
        until: [
          { send: menu name: completion_menu }
          { send: menunext }
        ]
      }
    }
    {
      name: completion_previous
      modifier: shift
      keycode: backtab
      mode: [emacs, vi_normal, vi_insert]
      event: { send: menuprevious }
    }
    {
      name: history_menu
      modifier: control
      keycode: char_r
      mode: emacs
      event: { send: menu name: history_menu }
    }
    {
      name: next_page
      modifier: control
      keycode: char_x
      mode: emacs
      event: { send: menupagenext }
    }
    {
      name: undo_or_previous_page
      modifier: control
      keycode: char_z
      mode: emacs
      event: {
        until: [
          { send: menupageprevious }
          { edit: undo }
        ]
       }
    }
    {
      name: yank
      modifier: control
      keycode: char_y
      mode: emacs
      event: {
        until: [
          {edit: pastecutbufferafter}
        ]
      }
    }
    {
      name: unix-line-discard
      modifier: control
      keycode: char_u
      mode: [emacs, vi_normal, vi_insert]
      event: {
        until: [
          {edit: cutfromlinestart}
        ]
      }
    }
    {
      name: kill-line
      modifier: control
      keycode: char_k
      mode: [emacs, vi_normal, vi_insert]
      event: {
        until: [
          {edit: cuttolineend}
        ]
      }
    }
    # Keybindings used to trigger the user defined menus
    {
      name: commands_menu
      modifier: control
      keycode: char_t
      mode: [emacs, vi_normal, vi_insert]
      event: { send: menu name: commands_menu }
    }
    {
      name: vars_menu
      modifier: alt
      keycode: char_o
      mode: [emacs, vi_normal, vi_insert]
      event: { send: menu name: vars_menu }
    }
    {
      name: commands_with_description
      modifier: control
      keycode: char_s
      mode: [emacs, vi_normal, vi_insert]
      event: { send: menu name: commands_with_description }
    }
  ]
}

source ~/.cache/zoxide/init.nu
source ~/.cache/starship/init.nu
