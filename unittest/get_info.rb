require 'cloudfoundry'
#client = CloudFoundry::Client.new({:target_url => "http://api.tongtech"})
#token = client.login("chengfj@tongtech.com","root")
client = CloudFoundry::Client.new({:target_url => "http://api.cloudfoundry.com"})
token = client.login("mouse3150@163.com","root")
#puts token
#CloudFoundry::Client.new
#get normal information
#{:name=>"vcap", :build=>2222, :support=>"http://support.cloudfoundry.com", 
# :version=>"0.999", :description=>"VMware's Cloud Application Platform", 
#:allow_debug=>true, :authorization_endpoint=>"http://uaa.tongtech"}

#info = client.cloud_info
#puts info

#get cloud services information
#{:database=>{:postgresql=>{:"9.0"=>{:id=>6, :vendor=>"postgresql", :version=>"9.0", :tiers=>{:free=>{:options=>{}, :order=>1}}, :type=>"database", :description=>"PostgreSQL database service (vFabric)", :provider=>nil, :default_plan=>"free", :alias=>"current"}}, :mysql=>{:"5.1"=>{:id=>1, :vendor=>"mysql", :version=>"5.1", :tiers=>{:free=>{:options=>{}, :order=>1}}, :type=>"database", :description=>"MySQL database service", :provider=>nil, :default_plan=>"free", :alias=>"current"}}}, :generic=>{:rabbitmq=>{:"2.4"=>{:id=>7, :vendor=>"rabbitmq", :version=>"2.4", :tiers=>{:free=>{:options=>{}, :order=>1}}, :type=>"generic", :description=>"RabbitMQ message queue", :provider=>nil, :default_plan=>"free", :alias=>"current"}}}, :document=>{:mongodb=>{:"2.0"=>{:id=>3, :vendor=>"mongodb", :version=>"2.0", :tiers=>{:free=>{:options=>{}, :order=>1}}, :type=>"document", :description=>"MongoDB NoSQL store", :provider=>nil, :default_plan=>"free", :alias=>"current"}}}, :"key-value"=>{:redis=>{:"2.2"=>{:id=>2, :vendor=>"redis", :version=>"2.2", :tiers=>{:free=>{:options=>{}, :order=>1}}, :type=>"key-value", :description=>"Redis key-value store service", :provider=>nil, :default_plan=>"free", :alias=>"current"}}}}
css_info = client.cloud_services_info
puts css_info

