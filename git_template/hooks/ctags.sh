#!/bin/sh
set -e
PATH="/usr/local/bin:$PATH"
dir="`git rev-parse --git-dir`"
trap 'rm -f "$dir/$$.tags"' EXIT
git ls-files | \
  ctags --tag-relative --fields=+l -L - -f"$dir/$$.tags" --languages=-javascript,sql,tex
mv "$dir/$$.tags" "$dir/tags"
