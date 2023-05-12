# require Inesita
require 'inesita'
require 'inesita-router'

require 'sid'
require 'web-midi'

require 'promise'
require 'browser'
require 'browser/interval'
require 'browser/http'

require 'router'
require 'asid'
require 'store_list'
require 'store_tree'
require 'store'

require_tree './components'

class Application
  include Inesita::Component

  inject Store
  inject Router

  def render
    div id: 'screen' do
      component router
    end
  end
end

Inesita::Browser.ready? do
  Application.mount_to(Inesita::Browser.body)
end
