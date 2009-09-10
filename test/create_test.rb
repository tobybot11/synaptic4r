##############################################################################################################
require 'helper'
 
##############################################################################################################
class CreateTest < Test::Unit::TestCase
 
  #.........................................................................................................
  def setup
    @args = {:key=>'thesecret', :site=>'https://nowhere.com', :subtenant=>'abcdef1245', :uid=>'noone'}
    @client = Synaptic4r::Client.new(@args)
  end
 
  #.........................................................................................................
  should "build request to create directory with specified name" do
    a = @args.merge({:rpath=>'newdir'})
    @client.create_dir(a).should send_request(HttpMessages.create_dir_request(a))
  end
  
  
end
