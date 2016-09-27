class Tree
  include Inesita::Component

  def render
    li(class: :yellow){ ' ████████ ' }
    li { '                                         ' }
    li(class: :yellow){ ' /                                        ' }
    li { '                                         ' }
    store.list.each do |list|
      li { list }
    end
  end
end
