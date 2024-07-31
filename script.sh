#!/bin/bash

# Exit on error
set -e

# Remove mmark references from content
find content -type f -name "*.md" -exec sed -i '' '/markup: mmark/d' {} +

# Remove mmark references from theme example content
find themes -type f -name "*.md" -exec sed -i '' '/markup: mmark/d' {} +

# Create necessary directories
mkdir -p content/post/demo

# Copy math demo post from theme to content
cp themes/jane/exampleSite/content/post/demo/5-math.md content/post/demo/

# Update the math demo post
sed -i '' '/markup: mmark/d' content/post/demo/5-math.md
sed -i '' '1,/---/c\
---\
title: "Math"\
date: 2024-07-31T00:00:00Z\
draft: false\
math: true\
---' content/post/demo/5-math.md

# Function to check if a configuration exists
config_exists() {
    grep -q "^\[$1\]" hugo.toml
}

# Function to add or update configuration
update_config() {
    if config_exists "$1"; then
        sed -i '' "/^\[$1\]/,/^\[/c\\
[$1]\\
  $2\\
" hugo.toml
    else
        echo -e "\n[$1]\n  $2" >> hugo.toml
    fi
}

# Update hugo.toml
update_config "markup" "defaultMarkdownHandler = \"goldmark\""
update_config "markup.goldmark.renderer" "unsafe = true"
update_config "params" "math = true\n  mathEngine = \"katex\"  # or \"mathjax\""

echo "Script completed. Please review changes and run 'hugo' to build your site."
