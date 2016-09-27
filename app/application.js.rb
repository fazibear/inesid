# require Inesita
require 'inesita'
require 'sid'

require 'bowser/window'
require 'bowser/http'

require 'router'
require 'store_list'
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
