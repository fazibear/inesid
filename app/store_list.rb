module StoreList
  def fetch_list
    Bowser::HTTP.fetch(Store::LIST_JSON).then do |resp|
      @list = resp.json
      render!
    end
  end

  def list
    @list[@list_offset..@list_offset+17].each_with_index.map do |l, idx|
      " #{@list_offset + idx == @list_selected ? ">" : " "} #{l.first[0..34]}"
    end
  end

  def list_enter
    Inesita::Browser.push_state("/" + @list[@list_selected].last.gsub(Store::SID_POSTFIX, ''))
    @sid.load_and_play("#{Store::SID_PREFIX}/#{@list[@list_selected].last}", 0)
  end

  def list_down
    @list_selected += 1
    @list_selected = @list.length - 1 if @list_selected > @list.length - 1
    fix_list_offset(true)
    render!
  end

  def list_up
    @list_selected -= 1
    @list_selected = 0 if @list_selected < 0
    fix_list_offset(false)
    render!
  end

  def list_random
    @tree_offset = @list_selected = rand(@list.length)
    render!
  end

  def fix_list_offset(down)
    unless @list_selected >= @list_offset && @list_selected <= @list_offset + 17
      @list_offset += down ? 1 : -1
      @list_offset = 0 if @list_offset < 0
      @list_offset = @list.length - 17 if @list_offset > @list.length - 17
    end
  end
end
