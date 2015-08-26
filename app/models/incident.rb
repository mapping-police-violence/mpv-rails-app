class Incident < ActiveRecord::Base
  after_update :expire_cache

  def expire_cache
    print "expiring cache!"
    ActionController::Base.expire_page('api/v1/incidents.json')
  end
end