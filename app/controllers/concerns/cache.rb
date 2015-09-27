#to be used for scan tests only
class Cache
  EXPIRY_TIME = 86400

  def self.get
    action = REDIS.hmget("action", :yes, :no)
  end

  def self.set(yes_action, no_action)
    REDIS.hmset("action", :yes, yes_action, :no, no_action)
  end


  def self.invalidate
    REDIS.hdel("action", :yes)
    REDIS.hdel("action", :no)
  end

end