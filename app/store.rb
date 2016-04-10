class Store
  include Inesita::Store

  attr_reader :current_screen, :current_song

  FLAT_INDEX = '/static/music/flat.json'

  def init
    @current_screen = :welcome
    @current_song = nil
    @play = false

    @list = []
    @list_offset = 0
    @list_selected = 0

    setup_sid
    fetch_list
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
      @sid.load_and_play("/static/music/#{router.params[:all]}", 0)
    end
  end

  def hook_time_refresh
    Bowser.window.interval(1) do
      if @current_screen == :play
        render!
      end
    end
  end

  def hook_keys
    Bowser.window.on(:keydown) do |e|
      case e.which
      when 72 then @current_screen = :welcome; render!
      when 80 then
        if @current_song
          @current_screen = :play
          render!
        end
      when 76 then @current_screen = :list; render!
      when 68 then #dir
      when 38 then
        if @current_screen == :list
          @list_selected -= 1
          @list_selected = 0 if @list_selected < 0
          fix_list_offset(false)
          render!
        end
      when 40 then
        if @current_screen == :list
          @list_selected += 1
          @list_selected = @list.length - 1 if @list_selected > @list.length - 1
          fix_list_offset(true)
          render!
        end
      when 13 then
        if @current_screen == :list
          Inesita::Browser.push_state(@list[@list_selected].last.gsub('/static/music',''))
          @sid.load_and_play(@list[@list_selected].last, 0)
        end
      when 82 then
        if @current_screen == :list
          @list_selected = rand(@list.length)
          @list_offset = @list_selected
          render!
          #@sid.load_and_play(@list[@list_selected].last, 0)
        end
      when 32 then
        if @play
          @play = false
          @sid.pause
        else
          @play = true
          @sid.unpause
        end
      end
    end
  end

  def fix_list_offset(down)
    unless @list_selected >= @list_offset && @list_selected <= @list_offset + 17
      @list_offset += down ? 1 : -1
      @list_offset = 0 if @list_offset < 0
      @list_offset = @list.length - 17 if @list_offset > @list.length - 17
    end
  end

  def play_time
    Time.at(@sid.play_time).utc.strftime("%H:%M:%S")
  end

  def fetch_list
    @flat = Bowser::HTTP.fetch(FLAT_INDEX).then do |resp|
      @list = resp.json
      render!
    end
  end

  def list
    @list[@list_offset..@list_offset+17].each_with_index.map do |l, idx|
      " #{@list_offset + idx == @list_selected ? ">" : " "} #{l.first[0..34]}"
    end
  end
end
