#!/bin/sh
# Creates a single target/docs/FullGuide.html file
#
# Requires asciidoctor version 0.1.3.pre gem
#
# Until this pre-release or a released version is available on rubygems.org, you must:
### 1) git clone git://github.com/asciidoctor/asciidoctor.git
### 2) Run "gem build" from master
### #) Run "gem install asciidoctor-0.1.3.pre.gem"
#
# Ensure you have the change from this pull request before building the gem:
# https://github.com/asciidoctor/asciidoctor/pull/383
mkdir -p target/docs
asciidoctor --destination-dir target/docs -a toc2 -a theme=flask -a copycss -a source-highlighter=highlightjs ./guide/FullGuide.adoc