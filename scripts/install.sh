#!/usr/bin/env sh
set -eu

repo="alexmengoli/u-spec"
destination="${1:-.agents/skills}"
skills="propose change apply archive"

temporary_directory="$(mktemp -d)"
trap 'rm -rf "$temporary_directory"' EXIT HUP INT TERM

latest_url="$(curl -fsSL -o /dev/null -w '%{url_effective}' "https://github.com/$repo/releases/latest")"
version="${latest_url##*/}"

case "$version" in
  v[0-9]*.[0-9]*.[0-9]*) ;;
  *)
    echo "Could not determine the latest u-spec version from $latest_url" >&2
    exit 1
    ;;
esac

archive="$temporary_directory/skills.zip"
curl -fsSL "https://github.com/$repo/releases/download/$version/skills-$version.zip" -o "$archive"
unzip -q "$archive" -d "$temporary_directory/package"

for skill in $skills; do
  test -f "$temporary_directory/package/skills/$skill/SKILL.md" || {
    echo "The $version release is missing skills/$skill/SKILL.md" >&2
    exit 1
  }
done

mkdir -p "$destination"
for skill in $skills; do
  rm -rf "$destination/$skill"
  cp -R "$temporary_directory/package/skills/$skill" "$destination/$skill"
done

echo "Installed u-spec $version in $destination"
