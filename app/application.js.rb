# require Inesita
require 'inesita'
require 'sid'
require 'web-midi'

require 'bowser/window'
require 'bowser/http'

require 'router'
require 'asid'
require 'store_list'
require 'store_tree'
require 'store'

require_tree './components'

# when document is ready render application to <body>
Inesita::Browser.ready? do
  # setup Inesita application
  Inesita::Application.new(
    store: Store,
    router: Router,
  ).mount_to(Inesita::Browser.body)
end
