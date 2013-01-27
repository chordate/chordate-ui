module ArWorld
  def transact
    ActiveRecord::Base.transaction do
      yield
    end if block_given?
  end
end

Object.send(:include, ArWorld)
