VIMENV_TEST_DIR="${BATS_TMPDIR}/vimenv"
export VIMENV_ROOT="${VIMENV_TEST_DIR}/root"
export HOME="${VIMENV_TEST_DIR}/home"

unset VIMENV_VERSION
unset VIMENV_DIR

export PATH="${VIMENV_TEST_DIR}/bin:$PATH"
export PATH="${BATS_TEST_DIRNAME}/../libexec:$PATH"
export PATH="${BATS_TEST_DIRNAME}/libexec:$PATH"
export PATH="${VIMENV_ROOT}/shims:$PATH"

teardown() {
  rm -rf "$VIMENV_TEST_DIR"
}

flunk() {
  { if [ "$#" -eq 0 ]; then cat -
    else echo "$@"
    fi
  } | sed "s:${VIMENV_TEST_DIR}:TEST_DIR:" >&2
  return 1
}

assert_success() {
  if [ "$status" -ne 0 ]; then
    flunk "command failed with exit status $status"
  elif [ "$#" -gt 0 ]; then
    assert_output "$1"
  fi
}

assert_failure() {
  if [ "$status" -eq 0 ]; then
    flunk "expected failed exit status"
  elif [ "$#" -gt 0 ]; then
    assert_output "$1"
  fi
}

assert_equal() {
  if [ "$1" != "$2" ]; then
    { echo "expected: $1"
      echo "actual:   $2"
    } | flunk
  fi
}

assert_output() {
  assert_equal "$1" "$output"
}

assert_line() {
  if [ "$1" -ge 0 ] 2>/dev/null; then
    assert_equal "$2" "${lines[$1]}"
  else
    for line in "${lines[@]}"; do
      if [ "$line" = "$1" ]; then return 0; fi
    done
    flunk "expected line \`$1'"
  fi
}

refute_line() {
  for line in "${lines[@]}"; do
    if [ "$line" = "$1" ]; then flunk "expected to not find line \`$line'"; fi
  done
}

assert() {
  if ! "$@"; then
    flunk "failed: $@"
  fi
}
