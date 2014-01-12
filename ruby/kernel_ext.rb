# Objective-C Kernel extension
module Kernel
  def puts(*strs)
    string = strs.collect {|str| str.to_s }.join(' ')
    `OpalCore.puts(string)`
  end

  def require(name)
    `OpalCore.require(name)`
  end
end