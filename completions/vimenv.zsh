if [[ ! -o interactive ]]; then
    return
fi

compctl -K _vimenv vimenv

_vimenv() {
  local words completions
  read -cA words

  if [ "${#words}" -eq 2 ]; then
    completions="$(vimenv commands)"
  else
    completions="$(vimenv completions ${words[2,-2]})"
  fi

  reply=("${(ps:\n:)completions}")
}
