class Router
  include Inesita::Router

  def routes
    route '/*url', to: Screen
  end
end
