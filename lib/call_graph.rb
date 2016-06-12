
require "parser/current"
require "pp"

require_relative "dot"

# filename_rb [String] file with a ruby program
# @return a dot graph string
def call_graph(filename_rb)
  ruby = File.read(filename_rb)
  ast = Parser::CurrentRuby.parse(ruby, filename_rb)
  defs = defs_from_ast(ast)
  def_names = defs.map {|d| def_name(d) }
  defs_to_hrefs = defs.map {|d| [def_name(d), "/files/" + def_location(d)] }.to_h

  defs_to_calls = {}
  defs.each do |d|
    calls = calls_from_def(d)
    call_names = calls.map {|c| send_name(c)}
    call_names = call_names.find_all{ |cn| def_names.include?(cn) }
    defs_to_calls[def_name(d)] = call_names
  end

  dot_from_hash(defs_to_calls, defs_to_hrefs)
end

def def_name(node)
  name, _args, _body = *node
  name
end

def def_location(node)
  range = node.loc.expression
  file = range.source_buffer.name
  line = range.line
  "#{file}#line=#{line}"
end

def send_name(node)
  _receiver, name, *_args = *node
  name
end

class Defs < Parser::AST::Processor
  def initialize
    @defs = []
    @sends = []
  end

  def defs_from_ast(ast)
    @defs = []
    process(ast)
    @defs
  end

  def sends_from_ast(ast)
    @sends = []
    process(ast)
    @sends
  end

  def on_def(node)
    @defs << node
    super
  end

  def on_send(node)
    @sends << node
    super
  end
end

def defs_from_ast(ast)
  Defs.new.defs_from_ast(ast)
end

def calls_from_def(ast)
  Defs.new.sends_from_ast(ast)
end
