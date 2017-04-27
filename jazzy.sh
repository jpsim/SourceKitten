#!/bin/sh

jazzy -m SourceKittenFramework \
  -a "JP Simard" \
  -u https://github.com/jpsim/SourceKitten \
  -g https://github.com/jpsim/SourceKitten \
  --github-file-prefix https://github.com/jpsim/SourceKitten/blob/$(make get_version) \
  --module-version $(make get_version) \
  -r http://www.jpsim.com/SourceKitten/ \
  -x -workspace,SourceKitten.xcworkspace,-scheme,SourceKittenFramework \
  -c
