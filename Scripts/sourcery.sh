#!/bin/zsh
MODULE_PATH="Tools/Sourcery"

cd "$(dirname "$0")/.."

"${MODULE_PATH}/Binary/bin/sourcery" --config "${MODULE_PATH}/.sourcery.yml" --verbose