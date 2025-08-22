#!/bin/bash

FILES=(
    .bashrc
    .npmrc
    .tmux.conf
    .clang-format
)

for file in "${FILES[@]}"; do
    ln -sf "$HOME/.config/$file" "$HOME/$file"
done
