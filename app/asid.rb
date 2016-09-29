require 'asidjs'
require 'native'

class ASID
  include Native

  alias_native :tick
  alias_native :write
  alias_native :setMidiOut

  def initialize(midi_out)
    @native = `new ASID(#{midi_out})`
  end
end
