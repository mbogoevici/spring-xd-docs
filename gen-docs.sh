#!/bin/sh
mkdir -p target/docs
asciidoctor --destination-dir target/docs -a toc -a theme=flask -a copycss ./guide/fullGuide.adoc 
