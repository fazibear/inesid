class Store
  include Inesita::Store

  def initialize
    @screen = " " * 40 + " ♥ Welcome to Inesid - Web SID Player ♥ "
  end

  def screen
    @screen.scan(/.{1,40}/)
  end
end
