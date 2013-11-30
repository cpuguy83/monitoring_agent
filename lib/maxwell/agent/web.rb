require 'erb'
require 'sinatra'
require 'agent/web_helpers'
module Maxwell
  module Agent
    class Web < Sinatra::Base
      helpers WebHelpers

      set :root, File.expand_path(File.dirname(__FILE__) + "/../../web")
      set :public_folder, Proc.new { "#{root}/assets" }
      set :views, Proc.new { "#{root}/views" }

      get '/' do
        erb :index
      end
    end
  end
end
