require 'obsapi/test_sphinx'

class TestController < ApplicationController
  skip_before_action :extract_user
  before_action do
    return true if Rails.env.test? || Rails.env.development?
    render_error  message: "This is only accessible for testing environments", :status => 403
    return false
  end

  @@started = false

  # we need a way so the API sings killing me softly
  def killme
    Process.kill('INT', Process.pid)
    @@started = false
    render_ok
  end
  
  # we need a way so the API uprises fully
  def startme
     if @@started
       render_ok
       return
     end
     @@started = true
     WebMock.disable_net_connect!(allow_localhost: true)
     CONFIG['global_write_through'] = true
     backend.direct_http(URI("/"))
     render_ok
  end
  
end
