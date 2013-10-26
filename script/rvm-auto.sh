#!/usr/bin/env bash

rvm_fail()
{
  echo "$1" >&2
  exit "${2:-1}"
}

if test -z "${1:-}"
then rvm_fail "No ruby specification given." 101
fi

ruby_string="$1"
shift

if test -n "${rvm_path:-}"
then true
else
  export rvm_path
  if   test -x  "$HOME/.rvm/bin/rvm"
  then rvm_path="$HOME/.rvm"
  elif test -x  "/usr/local/rvm/bin/rvm"
  then rvm_path="/usr/local/rvm"
  else rvm_path="$HOME/.rvm"
  fi
fi

if test -x "${rvm_path:-}/bin/rvm"
then true
else rvm_fail "Can not find RVM in '${rvm_path:-}'." 102
fi

if
  source_file="`"${rvm_path}/bin/rvm" --create "$ruby_string" do rvm env --path`" &&
  test -n "${source_file:-}" &&
  test -r "${source_file:-}"
then
  \. "${source_file:-}"
  if test -f "${BUNDLE_GEMFILE:-Gemfile}"
  then exec bundle exec "$@"
  else exec "$@"
  fi
else
  rvm_fail "Can not find ruby for '$ruby_string'." 103
fi
