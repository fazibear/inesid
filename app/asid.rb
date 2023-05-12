require 'asidjs'
require 'native'

class ASID
  include Native::Wrapper

  alias_native :tick
  alias_native :write
  alias_native :setMidiOut
  alias_native :flush
  alias_native :start
  alias_native :stop

  def initialize(midi_out)
    @native = `new ASID(#{midi_out})`
  end
end
