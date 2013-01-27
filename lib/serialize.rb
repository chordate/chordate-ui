module Serialize
  def serialize_all(*names)
    names.tap { @_serialized_type = names.pop }.each do |name|
      serialize name, @_serialized_type
    end
  end
end

Object.send(:include, Serialize)
