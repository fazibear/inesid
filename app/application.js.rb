# require Inesita
require 'inesita'

# require main parts of application
require 'router'
require 'store'
require 'screen'

# when document is ready render application to <body>
Inesita::Browser.ready? do
  # setup Inesita application
  Inesita::Application.new(
    store: Store,
    router: Router,
  ).mount_to(Inesita::Browser.query_element('body'))
end
