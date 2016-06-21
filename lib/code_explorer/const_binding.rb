module CodeExplorer
  # tracks what constants are resolvable
  class ConstBinding
    def initialize(fqname, parent = nil)
      @fqname = fqname
      @parent = parent
      @known = {}
    end

    # @return [ConstBinding] the new scope
    def open_namespace(fqname)
      ns = @known[fqname]
      if ns.is_a? ConstBinding
        # puts "(reopening #{fqname})"
      else
        ns = self.class.new(fqname, self)
        @known[fqname] = ns
      end
      ns
    end

    # @return [ConstBinding] the parent scope
    def close_namespace
      @parent
    end

    def declare_const(fqname)
      if @known[fqname]
        #      puts "warning: #{fqname} already declared"
      end
      @known[fqname] = :const
    end

    def resolve_declared_const(name)
      if @fqname.empty?
        name
      else
        "#{@fqname}::#{name}"
      end
    end

    def resolve_used_const(name)
      #    puts "resolving #{name} in #{@fqname}, known #{@known.inspect}"
      candidate = resolve_declared_const(name)
      if @known.include?(candidate)
        candidate
      elsif @parent
        @parent.resolve_used_const(name)
      else
        name
      end
    end
  end
end
