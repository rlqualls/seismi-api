def time_method(obj, method, args = {})
  beginning_time = Time.now
  obj.send(method, args)
  end_time = Time.now
  end_time - beginning_time
end

def cached_is_faster(method, args1 = {}, args2 = {})
  cached_client = Seismi::API::Client.new
  uncached_time = time_method(cached_client, method, args1)
  cached_time = time_method(cached_client, method, args2)
  return cached_time < uncached_time
end
