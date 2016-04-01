class Router
  include Inesita::Router

  def routes
    route '/', to: Screen
  end
end
