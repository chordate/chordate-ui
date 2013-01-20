public

def tap_if(meth, &block)
  self.tap(&block) if self.send(meth)
end
