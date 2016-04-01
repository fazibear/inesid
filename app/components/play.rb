class Play
  include Inesita::Component

  def render
    li(class: :cyan){ '████████████████████████████████████████' }
    li(class: :cyan){ '████████████████' }
    li(class: :cyan){ '████████████████████████████████████████' }
    li { '                                        ' }
    li(class: :yellow){ " ██" }
    li { '                                        ' }
    li { ' ' + store.current_song[:title][0..38] }
    li { '                                        ' }
    li(class: :yellow){ " ██" }
    li { '                                        ' }
    li { ' ' + store.current_song[:author][0..38] }
    li { '                                        ' }
    li(class: :yellow){ " ██" }
    li { '                                        ' }
    li { ' ' + store.current_song[:info][0..38] }
    li { '                                        ' }
    li(class: :yellow){ " ██" }
    li { '                                        ' }
    li { ' ' + store.play_time }
    li { '                                        ' }
    li(class: :yellow){ " ██" }
    li { '                                        ' }
    li { ' ' + store.current_song[:tunes].to_s[0..38] }
    li { '                                        ' }
	end
end
