class List
  include Inesita::Component

  def render
    li(class: :cyan){ '████████████████████████████████████████' }
    li(class: :cyan){ '████████████████' }
    li(class: :cyan){ '████████████████████████████████████████' }
    li { '                                        ' }
    li(class: :yellow){ ' ████████ ' }
    li { '                                        ' }
    store.list.each do |list|
      li { list }
    end
	end
end
