class Screen
  include Inesita::Component

  def render
    ul id: :screen do
      li(class: :cyan){ '████████████████████████████████████████' }
      li(class: :cyan){ '████████████████' }
      li(class: :cyan){ '████████████████████████████████████████' }
      li { '                                        ' }
      component case store.current_screen
                when :welcome then Welcome
                when :play then Play
                when :list then List
                when :tree then Tree
                end
    end
  end
end
