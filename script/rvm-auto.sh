#!/usr/bin/env sh

rvm_fail()
{
  echo "$1" >&2
  exit "${2:-1}"
}

if test -z "${1:-}"
then rvm_fail "No ruby versions given." 101
fi

# the first parameter is usually ruby version to use,
# can be "." for reading current directory ruby
ruby_string="$1"
shift

# if rvm_path not set autodetect it
if
  test -z "${rvm_path:-}"
then
  export rvm_path
  if   test -x  "$HOME/.rvm/bin/rvm"
  then rvm_path="$HOME/.rvm"
  elif test -x  "/usr/local/rvm/bin/rvm"
  then rvm_path="/usr/local/rvm"
  else rvm_path="$HOME/.rvm"
  fi
fi

# make sure rvm is installed
if test -x "${rvm_path:-}/bin/rvm"
then true
else rvm_fail "Can not find rvm in '${rvm_path:-}'." 102
fi

if
  # just rvm
  test "$ruby_string" = "rvm"
then
  exec "${rvm_path}/bin/$ruby_string" "$@"

else
  # find and load ruby, execute the command
  if
    source_file="`"${rvm_path}/bin/rvm" "$ruby_string" --create do rvm env --path`" &&
    test -n "${source_file:-}" &&
    test -r "${source_file:-}"
  then
    \. "${source_file:-}" &&
    exec "$@"
  else
    rvm_fail "Can not find ruby for '$ruby_string'." 103
  fi
fi
