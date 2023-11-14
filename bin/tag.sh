#!/bin/bash

# File path of the text file containing the version number
VERSION_FILE="version"

# Ensure a valid version component is provided as an argument
if [ -z "$1" ] || [ "$1" != "patch" ] && [ "$1" != "minor" ] && [ "$1" != "major" ]; then
  echo "Usage: $0 <patch|minor|major>"
  exit 1
fi

# Read the current version number from the file
current_version=$(cat $VERSION_FILE)

# Parse major, minor, and patch components of the version
IFS='.' read -ra version_parts <<< "$current_version"
major=${version_parts[0]}
minor=${version_parts[1]}
patch=${version_parts[2]}

# Increment the appropriate version component
case "$1" in
  "patch")
    patch=$((patch + 1))
    ;;
  "minor")
    minor=$((minor + 1))
    patch=0
    ;;
  "major")
    major=$((major + 1))
    minor=0
    patch=0
    ;;
esac

# Create the new version string
new_version="$major.$minor.$patch"

# Update the version number in the file
echo $new_version > $VERSION_FILE

# Commit the change to Git
git add $VERSION_FILE
git commit -m "Bump version to $new_version"

# Create a Git tag
git tag -a "$new_version" -m "Version $new_version"

# Push the changes and tags to the remote repository
git push origin master
git push origin --tags

echo "Version $new_version updated, committed, and tagged."
