class Tree
  include Inesita::Component

  def render
    li(class: :yellow){ ' ████████ ' }
    li { '                                         ' }
    li(class: :yellow){ store.tree_path }
    li { '                                         ' }
    store.tree.each do |element|
      li { element }
    end
  end
end
