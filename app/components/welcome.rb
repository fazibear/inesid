class Welcome
  include Inesita::Component

  def render
    li(class: :yellow){ '                                  ' }
    li { '                                        ' }
    li { ' PRESS T/L FOR SONGS TREE / LIST        ' }
    li { ' PRESS P FOR PLAY SCREEN                ' }
    li { ' PRESS SPACE FOR PAUSE/PLAY             ' }
    li { ' PRESS H FOR HELP (this screen)         ' }
    li { ' PRESS M TO CHANGE MIDI PORT FOR ASID   ' }
    li { ' ' }
    li(class: :orange){
      case store.midi_out
      when false then ' MIDI: NOT SUPPORTED'
      when true then ' MIDI: DISABLED'
      else ' MIDI: ' + store.midi_out.name
      end
    }
    li { '                                        ' }
    li(class: :purple){ '        MADE WITH ♥ BY FAZIBEAR    ' }
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
