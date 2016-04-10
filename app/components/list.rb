class List
  include Inesita::Component

  def after_render
    puts "after list"
  end

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
