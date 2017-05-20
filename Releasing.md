# Releasing SourceKitten

For SourceKitten contributors, follow these steps to cut a release:

1. Update version number: `make set_version 0.6.2`
2. Come up with a witty feline themed release name. Past names include:
    * Objective-Cat
    * Cat-astrophic
    * SourceClangKitLibKitten
    * Grumpy Cat
3. Commit & push to the `master` branch.
4. Tag: `git tag -a 0.6.2 -m "0.6.2: Objective-Cat"; git push origin 0.6.2`
5. Make sure you have the latest stable Xcode version installed and
   `xcode-select`ed.
6. Create the pkg installer & framework zip: `make release`
7. Create a GitHub release: https://github.com/jpsim/SourceKitten/releases/new
    * Specify the tag you just pushed from the dropdown.
    * Set the release title to the new version number & release name.
    * Add the changelog section to the release description text box.
    * Upload the pkg installer and Carthage zip
      (`SourceKittenFramework.framework.zip`) you just built to the GitHub
      release binaries.
    * Click "Publish release".
8. Publish to Homebrew and CocoaPods trunk: `make publish`
