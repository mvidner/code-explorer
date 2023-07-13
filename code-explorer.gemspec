# -*- ruby -*-

require File.expand_path("../lib/code_explorer/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "code-explorer"
  s.version     = CodeExplorer::VERSION
  s.summary     = "Explore Ruby code"
  s.description = "Find your way around source code written in Ruby"

  s.author      = "Martin Vidner"
  s.email       = "martin@vidner.net"
  s.homepage    = "https://github.com/mvidner/code-explorer"
  s.license     = "MIT"

  s.files       = [
    "CHANGELOG.md",
    "README.md",
    "VERSION",

    "bin/call-graph",
    "bin/class-dependencies",
    "bin/code-explorer",
    "bin/required-files",

    "lib/code_explorer/call_graph.rb",
    "lib/code_explorer/const_binding.rb",
    "lib/code_explorer/consts.rb",
    "lib/code_explorer/dot.rb",
    "lib/code_explorer/numbered_lines.rb",
    "lib/code_explorer/version.rb"
  ]

  s.executables = s.files.grep(/^bin\//) { |f| File.basename(f) }

  s.add_dependency "parser", "~> 3"
  s.add_dependency "sinatra", "~> 1"
  s.add_dependency "webrick", "~> 1"
  s.add_dependency "cheetah", "~> 0" # for calling dot (graphviz.rpm)
  s.add_dependency "coderay", "~> 1" # syntax highlighting
end
