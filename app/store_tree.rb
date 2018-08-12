module StoreTree
  def fetch_tree
    Bowser::HTTP.fetch(Store::TREE_JSON).then do |resp|
      @tree = resp.json
      render!
    end
  end

  def tree
    (['..'] + nested_tree.keys)[@tree_offset..@tree_offset+15].each_with_index.map do |l, idx|
      " #{@tree_offset + idx == @tree_selected ? ">" : " "} #{l[0..34]}"
    end
  end

  def tree_path
    '   /' + @tree_path.join('/')
  end

  def tree_enter
    if @tree_selected == 0
      @tree_path.pop
    elsif nested_tree[nested_tree.keys[@tree_selected - 1]]
      @tree_path << nested_tree.keys[@tree_selected - 1]
      @tree_selected = 0
      @tree_offset = 0
    else
      path = "#{@tree_path.join('/')}/#{nested_tree.keys[@tree_selected - 1]}"
      Inesita::Browser.push_state('/' + path.gsub(Store::SID_POSTFIX, ''))
      set_sid(path)
      play_sid
    end
    render!
  end

  def nested_tree
    @tree_path.inject(@tree) do |h, k|
      h[k]
    end
  end

  def tree_down
    @tree_selected += 1
    @tree_selected = nested_tree.length  if @tree_selected > nested_tree.length
    fix_tree_offset(true)
    render!
  end

  def tree_up
    @tree_selected -= 1
    @tree_selected = 0 if @tree_selected < 0
    fix_tree_offset(false)
    render!
  end

  def tree_random
    @tree_offset = @tree_selected = rand(nested_tree.length)
    render!
  end

  def fix_tree_offset(down)
    unless @tree_selected >= @tree_offset && @tree_selected <= @tree_offset + 15
      @tree_offset += down ? 1 : -1
      @tree_offset = 0 if @tree_offset < 0
      @tree_offset = nested_tree.length - 15 if @tree_offset > nested_tree.length - 15
    end
  end
end
