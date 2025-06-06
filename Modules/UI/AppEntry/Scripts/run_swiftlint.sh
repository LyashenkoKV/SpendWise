#
//  run_swiftlint.sh
//  SpendWise
//
//  Created by Konstantin Lyashenko on 06.06.2025.
//


if which swiftlint >/dev/null; then
  swiftlint lint --config "${SRCROOT}/.swiftlint.yml" --quiet
else
  echo "warning: SwiftLint not installed. Download from https://github.com/realm/SwiftLint"
fi
