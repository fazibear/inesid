class Router
  include Inesita::Router

  def routes
    route '/*all', to: Screen
  end
end
