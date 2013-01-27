class Event < ActiveRecord::Base
  belongs_to :application

  serialize_all :user, :extra, :server, ActiveRecord::Coders::Hstore

  validates :env, :generated_at, :klass, :message, :application, :presence => true
  validates :status, :inclusion => { :in => %w(open resolved), :message => lambda {|_,_| I18n.t("events.status.inclusion") } }

  after_create -> {
    key, value = "applications:#{application_id}:events", "#{generated_at.to_i}:#{id}"

    Hat.pipelined {|r|
      r.hset(key, klass, value)
      r.hset("#{key}:#{env}", klass, value)
    }
  }

  def resolved?
    status == 'resolved'
  end
end
