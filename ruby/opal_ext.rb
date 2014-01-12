# Redefine Opal compiler, such that it do not specially handle require
# this is requried for our custom objective-c require method.
Opal::Nodes::CallNode.instance_eval do
  alias_method :__before_objc_handle_special, :handle_special
  define_method :handle_special do
    if meth == :require
      false
    else
      __before_objc_handle_special
    end
  end
end