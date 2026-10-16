# shellcheck disable=SC2034
# Monochrome theme: uses the terminal's default foreground/background.
# fzf background is set to -1 (terminal default) so there is no color panel.
if $CLI_SUPPORTS_TRUE_COLOR && $CONFIG_ENABLE_COLORS; then
  THEME_FG="$(printf '\033[39m')"
  THEME_BOLD="$(printf '\033[1m')"
  THEME_RESET="$(printf '\033[0m')"

  THEME_FZF_ICON_COLOR_PRIMARY="$THEME_FG"
  THEME_FZF_ICON_COLOR_SECONDARY="$THEME_FG"
  THEME_FZF_ICON_COLOR_ACCENT="$THEME_FG"
  THEME_FZF_ICON_COLOR_ERROR="$THEME_FG"
  THEME_FZF_PREVIEW_TITLE="$THEME_FG"
  THEME_FZF_PREVIEW_KEY="$THEME_FG"
  THEME_FZF_PREVIEW_VALUE="$THEME_FG"
  THEME_FZF_PREVIEW_DIVIDER="$THEME_FG"
  THEME_PLAYER_START="$THEME_FG"

  CONFIG_GUM_FILTER_OPTS="--prompt  > --indicator ◆ --selected-prefix  ◉  --unselected-prefix  ○  --placeholder こんにちは..."
  CONFIG_GUM_INPUT_OPTS="--placeholder こんにちは... --cursor.mode blink"
  CONFIG_GUM_PAGER_OPTS="--show-line-numbers --soft-wrap"
  CONFIG_GUM_SPIN_OPTS="--spinner dot --align left"
  CONFIG_GUM_CONFIRM_OPTS=""

  CONFIG_FZF_OPTS="$CONFIG_FZF_OPTS
--color=bg:-1
--color=bg+:-1
--color=gutter:-1
--color=fg:-1
--color=fg+:-1:bold
--color=header:-1:bold
--color=hl:-1:bold
--color=hl+:-1:bold:underline
--color=info:-1:dim
--color=marker:-1
--color=pointer:-1:bold
--color=prompt:-1:bold
--color=query:-1
--color=scrollbar:-1:dim
--color=separator:-1:dim
--color=spinner:-1
--color=border:-1:dim
--color=label:-1:dim"
  export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $CONFIG_FZF_OPTS"
fi
