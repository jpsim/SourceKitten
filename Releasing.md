# Releasing SourceKitten

For SourceKitten contributors, follow these steps to cut a release:

1. Come up with a witty feline themed release name. Past names include:
    * Objective-Cat
    * Cat-astrophic
    * SourceClangKitLibKitten
    * Grumpy Cat
    * Yarn Ball
2. Make sure you have the latest stable Xcode version installed and
   `xcode-select`ed.
3. Run `make release <version> <name>`, e.g.:
   ```
   make release 0.37.3 Yarn Ball
   ```
   This will:
    * Update the version in `CHANGELOG.md`, `Version.swift`, and
      `MODULE.bazel`.
    * Commit and push to `main`.
    * Create and push an annotated tag.
    * Build the pkg installer.
    * Download the source tarball and upload it as a release asset
      (required by the Bazel Central Registry for a stable URL).
    * Create the GitHub release with the changelog, pkg, and source
      tarball attached.
    * Add an empty changelog section and push to `main`.
4. Homebrew will be updated automatically by BrewTestBot within ~3
   hours. The BCR GitHub app will open a PR to update the Bazel
   Central Registry.
