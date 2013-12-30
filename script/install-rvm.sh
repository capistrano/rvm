#!/usr/bin/env sh

# silence curl via configuration
export CURL_HOME="${TMP_DIR:-/tmp}/.rvm-curl-config.$$"
mkdir "${CURL_HOME}/" &&
{
  test -r "${HOME}/.curlrc" && cat "${HOME}/.curlrc"
  echo "silent"
  echo "show-error"
} > "$CURL_HOME/.curlrc" ||
exit $?

# run the installer
if \curl -L https://get.rvm.io -o rvm-installer.sh && bash rvm-installer.sh stable
then __LAST_STATUS=0
else __LAST_STATUS=$?
fi
rm -f rvm-installer.sh

# cleanup curl
rm -rf "$CURL_HOME"

# return installer status
exit ${__LAST_STATUS}
