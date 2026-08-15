#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

swift_files="$(rg --files "$PROJECT_DIR/Telivu" -g '*.swift' | sort)"
swiftc -parse $swift_files

ruby -e '
  require "yaml"
  project = YAML.load_file(ARGV.fetch(0))
  abort("Telivu application target is missing") unless project.dig("targets", "Telivu")
' "$PROJECT_DIR/project.yml"

ruby -rjson -e '
  ARGV.each { |path| JSON.parse(File.read(path)) }
' \
  "$PROJECT_DIR/Telivu/Assets.xcassets/Contents.json" \
  "$PROJECT_DIR/Telivu/Assets.xcassets/LaunchBackground.colorset/Contents.json"

if rg -n \
  'Color\.(red|blue|green|orange|yellow|purple|pink)|cornerRadius|shadow\(|blur\(|LinearGradient|RadialGradient|Material' \
  "$PROJECT_DIR/Telivu" -g '*.swift'; then
  echo "Found a visual-system violation." >&2
  exit 1
fi

test -f "$PROJECT_DIR/Telivu/Screens/TelivuHomeView.swift"
test "$(find "$PROJECT_DIR/Telivu/Screens" -name '*.swift' -type f | wc -l | tr -d ' ')" = "1"

rg -q 'static let ink = Color\(red: 0, green: 0, blue: 0\)' \
  "$PROJECT_DIR/Telivu/DesignSystem/TelivuDesignSystem.swift"
rg -q 'static let graphite = Color\(red: 94 / 255, green: 94 / 255, blue: 94 / 255\)' \
  "$PROJECT_DIR/Telivu/DesignSystem/TelivuDesignSystem.swift"
rg -q 'static let paper = Color\(red: 247 / 255, green: 247 / 255, blue: 247 / 255\)' \
  "$PROJECT_DIR/Telivu/DesignSystem/TelivuDesignSystem.swift"
rg -q 'PhotosPicker' "$PROJECT_DIR/Telivu/Screens/TelivuHomeView.swift"
rg -q '\.fileImporter' "$PROJECT_DIR/Telivu/Screens/TelivuHomeView.swift"
rg -q 'TelivuTalkButton' "$PROJECT_DIR/Telivu/Screens/TelivuHomeView.swift"

echo "Telivu UI structural validation passed."
