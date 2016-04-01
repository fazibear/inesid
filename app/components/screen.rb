class Screen
  include Inesita::Component

  def render
    ul id: :screen do
      component case store.current_screen
                when :welcome then Welcome
                when :play then Play
                when :list then List
                end
    end
  end
end
