class Layout
  include Inesita::Layout

  def render
    div id: 'screen' do
      component router
    end
  end
end
