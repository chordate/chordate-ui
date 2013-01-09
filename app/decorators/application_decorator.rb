class ApplicationDecorator
  include Decorator

  allow :name

  def save
    application.save
  end
end
