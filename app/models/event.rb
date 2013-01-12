class Event < ActiveRecord::Base
  belongs_to :application

  validates :env, :generated_at, :klass, :message, :application, :presence => true
end
