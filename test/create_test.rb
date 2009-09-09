##############################################################################################################
require 'helper'
 
##############################################################################################################
class CreateTest < Test::Unit::TestCase
 
  #.........................................................................................................
  def setup
    @client = Synaptic4r::Client.new(:key=>'thesecret', :site=>'https://nowhere.com', 
                                      :subtenant=>'abcdef1245', :uid=>'noone')
  end
 
  #.........................................................................................................
  should "build request to create directory with specified name" do
    @client.create_dir(:rpath=>'newdir').should send_request("request")
  end
  
  
end
