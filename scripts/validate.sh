#!/usr/bin/env bash
set -euo pipefail

command -v jq >/dev/null || { echo "jq is required" >&2; exit 1; }

repo_root=$(cd "$(dirname "$0")/.." && pwd)
manifest="$repo_root/.claude-plugin/marketplace.json"
status=0

fail() {
  echo "FAIL: $1" >&2
  status=1
}

jq -e . "$manifest" >/dev/null || { echo "FAIL: $manifest is not valid JSON" >&2; exit 1; }

while IFS=$'\t' read -r name source; do
  # Remote sources are resolved by the CLIs, not from this worktree.
  case "$source" in
    ./*) ;;
    *) continue ;;
  esac

  dir="$repo_root/${source#./}"
  if [ ! -d "$dir" ]; then
    fail "$name: source directory $source does not exist"
    continue
  fi
  [ "$(basename "$dir")" = "$name" ] || fail "$name: directory is named $(basename "$dir")"

  plugin_manifest="$dir/.claude-plugin/plugin.json"
  if ! jq -e . "$plugin_manifest" >/dev/null 2>&1; then
    fail "$name: $plugin_manifest is missing or not valid JSON"
    continue
  fi
  declared=$(jq -r '.name // ""' "$plugin_manifest")
  [ "$declared" = "$name" ] || fail "$name: plugin.json declares name \"$declared\""
done < <(jq -r '.plugins[] | [.name, (if (.source | type) == "string" then .source else "" end)] | @tsv' "$manifest")

if command -v claude >/dev/null 2>&1; then
  claude plugin validate "$repo_root" || status=1
fi

[ "$status" -eq 0 ] && echo "OK: $(jq -r '.plugins | length' "$manifest") plugin(s) validated"
exit "$status"
