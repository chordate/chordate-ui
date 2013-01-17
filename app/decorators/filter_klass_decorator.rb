class FilterKlassDecorator
  include Decorator

  def as_json(*)
    {
      :name => @item.first,
      :count => @item.second
    }
  end
end
