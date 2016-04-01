class Screen
  include Inesita::Component

  def render
    ul id: :screen do
      store.screen.each do |line|
        li { line }
      end
    end
  end
end
