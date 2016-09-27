class Store
  include Inesita::Store
  include StoreList
  include StoreTree
  attr_reader :current_screen, :current_song

  SID_PREFIX = '/static/C64Music'
  TREE_JSON = '/static/tree.json'
  LIST_JSON = '/static/list.json'

  SID_POSTFIX = '.sid'
  def init
    @current_screen = :welcome
    @current_song = nil
    @play = false

    @list = ['Loading ...']
    @list_offset = 0
    @list_selected = 0

    @tree = {"Loading ..." => nil}
    @tree_offset = 0
    @tree_selected = 0
    @tree_path = []

    setup_sid
    fetch_list
    fetch_tree
    hook_time_refresh
    hook_keys
  end

  def setup_sid
    @sid = SID.new
    @sid.on_load do |x|
      @current_song = {
        title: @sid.title,
        author: @sid.author,
        info: @sid.info,
        tunes: @sid.tunes
      }
      @current_screen = :play
      @play = true
      render!
    end
    unless router.params[:all].empty?
      @sid.load_and_play("#{SID_PREFIX}/#{router.params[:all]}#{SID_POSTFIX}", 0)
    end
  end

  def hook_time_refresh
    Bowser.window.interval(1) do
      if @current_screen == :play
        render!
      end
    end
  end

  def go_to_play
    if @current_song
      @current_screen = :play
    end
  end

  def play_pause
    if @play
      @play = false
      @sid.pause
    else
      @play = true
      @sid.unpause
    end
  end

  def play_time
    Time.at(@sid.play_time).utc.strftime("%H:%M:%S")
  end

  def hook_keys
    Bowser.window.on(:keydown) do |e|
      puts e.which
      case e.which
      when 72 then @current_screen = :welcome; render!
      when 80 then go_to_play; render!
      when 76 then @current_screen = :list; render!
      when 84 then @current_screen = :tree; render!
      when 38 then
        list_up if @current_screen == :list
        tree_up if @current_screen == :tree
      when 40 then
        list_down if @current_screen == :list
        tree_down if @current_screen == :tree
      when 13 then
        list_enter if @current_screen == :list
        tree_enter if @current_screen == :tree
      when 82 then
        if @current_screen == :list || @current_screen == :play
          @list_selected = rand(@list.length)
          @list_offset = @list_selected
          render!
          if @current_screen == :play
            Inesita::Browser.push_state("/" + @list[@list_selected].last.gsub(SID_POSTFIX, ''))
            @sid.load_and_play("#{Store::SID_PREFIX}/#{@list[@list_selected].last}", 0)
          end
        end
      when 32 then play_pause
      end
    end
  end
end
