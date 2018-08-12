class Welcome
  include Inesita::Component

  def render
    li {
      span(class: :yellow){ ' ██ ' }
      span(class: :purple){ '       MADE WITH ♥ BY FAZIBEAR ' }
    }
    li { '                                        ' }
    li { ' PRESS T/L FOR SONGS TREE / LIST        ' }
    li { ' PRESS 1-0 FOR PLAY TUNE                ' }
    li { ' PRESS P FOR PLAY SCREEN                ' }
    li { ' PRESS SPACE FOR PAUSE/PLAY             ' }
    li { ' PRESS H FOR HELP (this screen)         ' }
    li { ' ' }
    li { ' PRESS M TO CHANGE MIDI PORT FOR ASID   ' }
    li(class: :orange){
      case store.midi_out
      when false then ' MIDI: NOT SUPPORTED'
      when true then ' MIDI: DISABLED'
      else ' MIDI: ' + store.midi_out.name
      end
    }
    li { '                                        ' }
    li(class: :cyan) { '   https://www.patreon.com/fazibear' }
    li { '                                        ' }
    li { ' INESITA (web framework)                ' }
    li { ' https://github.com/inesita-rb/inesita  ' }
    li { '                                        ' }
    li { ' jsSID (play engine)                    ' }
    li { ' https://github.com/hermitsoft/jsSID    ' }
    li { '                                        ' }
    li { ' HVSC (sid collection)                  ' }
    li { ' http://www.hvsc.c64.org                ' }
  end
end
