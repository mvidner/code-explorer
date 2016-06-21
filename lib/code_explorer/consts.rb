require_relative "const_binding"

module CodeExplorer
  class Consts < Parser::AST::Processor
    include AST::Sexp

    # @return [ConstBinding]
    attr_reader :cb
    # @return [Hash{String => Array<String>}]
    attr_reader :superclasses

    def initialize
      @cb = ConstBinding.new("")
      @superclasses = {}
    end

    def report_modules(asts)
      Array(asts).each do |ast|
        process(ast)
      end
    end

    def const_name_from_sexp(node)
      case node.type
      when :self
        "self"
      when :cbase
        ""
      when :const, :casgn
        parent, name, _maybe_value = *node
        if parent
          const_name_from_sexp(parent) + "::#{name}"
        else
          name.to_s
        end
      else
        raise "Unexpected #{node.type}"
      end
    end

    def new_scope(name, &block)
      @cb = cb.open_namespace(name)
      block.call
      @cb = cb.close_namespace
    end

    def on_module(node)
      name, _body = *node
      name = cb.resolve_declared_const(const_name_from_sexp(name))
      #    puts "module #{name}"

      new_scope(name) do
        super
      end
    end

    def on_class(node)
      name, parent, _body = *node
      parent ||= s(:const, s(:cbase), :Object)

      name   = cb.resolve_declared_const(const_name_from_sexp(name))
      parent = cb.resolve_used_const(const_name_from_sexp(parent))
      #    puts "class #{name} < #{parent}"

      @superclasses[name] = [parent]

      new_scope(name) do
        super
      end
    end

    def on_sclass(node)
      parent, _body = *node

      parent = const_name_from_sexp(parent)
      name = "<< #{parent}" # cheating
      #    puts "class #{name}"

      new_scope(name) do
        super
      end
    end

    def on_casgn(node)
      name = cb.resolve_declared_const(const_name_from_sexp(node))
      cb.declare_const(name)
      #    puts "casgn #{name}"
    end

    def on_const(node)
      name = const_name_from_sexp(node)
      fqname = cb.resolve_used_const(name)
      #    puts "CONST #{fqname}"
    end
  end
end
