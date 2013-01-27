class Api::ErrorDecorator
  attr_reader :code, :messages

  def initialize(code, messages)
    @code = code
    @messages = messages
  end

  def as_json(*)
    {
      :error => {
        :code => @code,
        :messages => @messages
      }
    }
  end
end
