class Store
  include Inesita::Injection
  include StoreList
  include StoreTree
  attr_reader :current_screen, :current_song, :midi_out

  SID_PREFIX = '/static/C64Music'
  TREE_JSON = '/static/tree.json'
  LIST_JSON = '/static/list.json'

  SID_POSTFIX = '.sid'

  def init
    @current_screen = :welcome
    @current_path = nil
    @current_song = nil
    @current_tune = 0

    @play = false

    @list = ['Loading ...']
    @list_offset = 0
    @list_selected = 0

    @tree = {"Loading ..." => nil}
    @tree_offset = 0
    @tree_selected = 0
    @tree_path = []

    @midi_out = WebMidi.support?
    @midi_out_index = -1

    unless router.params[:all].empty?
      set_sid("#{router.params[:all]}#{SID_POSTFIX}")
      play_sid
    end

    fetch_list
    fetch_tree
    hook_time_refresh
    hook_keys
  end

  def setup_sid
    p "setup sid..."

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
    @sid.on_memory_write do |addr, val|
      @asid.write(addr, val)
    end

  end

  def set_sid(path)
    @current_path = "#{SID_PREFIX}/#{path}"
    @current_tune = 0
  end

  def play_sid
    @asid.start if @asid
    if @current_tune >= @sid.tunes
      @current_tune = 0
    end
    @sid.load_and_play(@current_path, @current_tune)
  end

  def hook_time_refresh
    $window.every(1) do
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
      @asid.start(@current_tune) if @asid
      @sid.unpause
    end
  end

  def play_tune
    @play = true
    @asid.start(@current_tune) if @asid
  end

  def play_time
    Time.at(@sid.play_time).utc.strftime("%H:%M:%S")
  end

  def play_random
    rand = rand(@list.length)
    Inesita::Browser.push_state("/" + @list[rand].last.gsub(SID_POSTFIX, ''))
    set_sid(@list[rand].last)
    play_sid
  end

  def change_midi
    WebMidi.new(sysex: true) do |midi|
      @midi_out_index += 1
      @midi_out_index = 0 if midi.outputs.length <= @midi_out_index
      @asid.setMidiOut(
        @midi_out = midi.outputs[@midi_out_index]
      )
      render!
    end
  end

  def hook_keys
    $document.on(:keydown) do |e|
      setup_sid unless @sid
      case e.code
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
      when 77 then change_midi
      when 49 then @current_tune = 0; play_sid
      when 50 then @current_tune = 1; play_sid
      when 51 then @current_tune = 2; play_sid
      when 52 then @current_tune = 3; play_sid
      when 53 then @current_tune = 4; play_sid
      when 54 then @current_tune = 5; play_sid
      when 55 then @current_tune = 6; play_sid
      when 56 then @current_tune = 7; play_sid
      when 57 then @current_tune = 8; play_sid
      when 58 then @current_tune = 9; play_sid
      when 48 then @current_tune = 10; play_sid
      end
    end
  end
end
