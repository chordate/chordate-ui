require "redis"

module Hat
  mattr_accessor :size, :timeout, :config

  def self.redis
    pool.with do |r|
      yield r
    end
  end

  def self.pipelined
    redis do |r|
      r.pipelined do
        yield r
      end
    end
  end

  private

  def self.pool
    @@pool ||= ConnectionPool.new(:size => size, :timeout => timeout) { Redis.connect(config) }
  end
end
