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
    @asid = ASID.new
    @sid = SID.new(1024)
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
    WebMidi.new(sysex: true) do |midi|
      $console.log midi.outputs
      @asid.setMidiOut(
        midi.outputs[6].to_n
      )
      @sid.on_memory_write do |addr, val|
        @asid.write(addr, val)
      end
    end

    unless router.params[:all].empty?
      play_sid("#{router.params[:all]}#{SID_POSTFIX}")
    end
  end

  def play_sid(path)
    @asid.start if @asid
    @sid.load_and_play("#{SID_PREFIX}/#{path}", 0)
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
      @asid.stop if @asid
      @sid.pause
    else
      @play = true
      @asid.start if @asid
      @sid.unpause
    end
  end

  def play_time
    Time.at(@sid.play_time).utc.strftime("%H:%M:%S")
  end

  def play_random
    rand = rand(@list.length)
    Inesita::Browser.push_state("/" + @list[rand].last.gsub(SID_POSTFIX, ''))
    play_sid(@list[rand].last)
  end

  def hook_keys
    Bowser.window.on(:keydown) do |e|
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
        list_random if @current_screen == :list
        tree_random if @current_screen == :tree
        play_random if @current_screen == :play
      when 32 then play_pause
      end
    end
  end
end
