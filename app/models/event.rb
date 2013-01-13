class Event < ActiveRecord::Base
  belongs_to :application

  validates :env, :generated_at, :klass, :message, :application, :presence => true

  after_create lambda {
    key, value = "applications:#{application_id}:events", "#{generated_at.to_i}:#{id}"

    Hat.pipelined {|r|
      r.hset(key, klass, value)
      r.hset("#{key}:#{env}", klass, value)
    }
  }
end
