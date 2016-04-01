class Welcome
  include Inesita::Component

  def render
    li(class: :cyan){ '████████████████████████████████████████' }
    li(class: :cyan){ '████████████████' }
    li(class: :cyan){ '████████████████████████████████████████' }
    li { '                                        ' }
    li(class: :yellow){ '                  USAGE                 ' }
    li { '                                        ' }
    li { ' PRESS L FOR SONGS LIST                 ' }
    li { ' PRESS P FOR PLAY SCREEN                ' }
    li { ' PRESS H FOR HELP (this screen)         ' }
    li { '                                        ' }
    li { '                                        ' }
    li { '                                        ' }
    li(class: :purple){ '         MADE WITH ♥ BY FAZIBEAR        ' }
    li { '                                        ' }
    li(class: :orange){ '                 CREDITS                ' }
    li { '                                        ' }
    li { ' INESITA (web framework)                ' }
    li { ' https://github.com/inesita-rb/inesita  ' }
    li { '                                        ' }
    li { ' jsSID (play engine)                    ' }
    li { ' https://github.com/hermitsoft/jsSID    ' }
    li { '                                        ' }
    li { ' HVSC (sid collection)                  ' }
    li { ' http://www.hvsc.c64.org                ' }
    li { '                                        ' }
	end
end
