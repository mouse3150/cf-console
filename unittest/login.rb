require 'cloudfoundry'
#local environment of cloudfoundry 168.1.42.138
client = CloudFoundry::Client.new({:target_url => "http://api.tongtech"})
token = client.login("chengfj@tongtech.com","root")
##
##api.cloudfoundry.com
##
#client = CloudFoundry::Client.new({:target_url => "http://api.cloudfoundry.com"})
#token = client.login("mouse3150@163.com","root")
puts token
info = client.cloud_info
puts info