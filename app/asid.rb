class ASID
  def initialize
    @asid_reg = Array.new(28, 0x100)
    @oldmemory = []
    @update = false
    WebMidi.new(sysex: true) do |midi|
      $console.log midi.outputs
      @midi = midi.outputs[8]
    end
    #`setInterval(#{->{send_to_midi}}, 15)`
  end

  def process_memory(memory)
    `
      MAP = [
        0x00, 0x01, 0x02, 0x03, 0x16, 0x04, 0x05,
        0x06, 0x07, 0x08, 0x09, 0x17, 0x0a, 0x0b,
        0x0c, 0x0d, 0x0e, 0x0f, 0x18, 0x10, 0x11,
        0x12, 0x13, 0x14, 0x15, 0x19, 0x1a, 0x1b
      ]

      for(i=0; i<28; ++i){
        if(memory[i] != this.oldmemory[i]){
          this.update = true;
          this.asid_reg[MAP[i]] = 0x100 | memory[i]
        }
      }
      this.oldmemory = memory

    `
  end

  def reset_dirty
    `
    for(i=0; i<28; ++i){
      this.asid_reg[MAP[i]] &= 0xff
    }
    `
  end

  def convert_to_midi
    @midi_msg = []
    @midi_msg << 0xf0
    @midi_msg << 0x2d
    @midi_msg << 0x4e
    `
      for(mask_byte=0; mask_byte<4; ++mask_byte) {
        var reg = 0x00;
        for(var reg_offset=0; reg_offset<7; ++reg_offset) {
          if( this.asid_reg[mask_byte*7 + reg_offset] & 0x100 ) {
            reg |= (1 << reg_offset);
          }
        }
        this.midi_msg.push(reg)
      }

      for(var msb_byte=0; msb_byte<4; ++msb_byte) {
        var reg = 0x00;
        for(var reg_offset=0; reg_offset<7; ++reg_offset) {
          if( this.asid_reg[msb_byte*7 + reg_offset] & 0x80 ) {
            reg |= (1 << reg_offset);
          }
        }
        this.midi_msg.push(reg)
      }

      for(var i=0; i<28; ++i){
        if( this.asid_reg[i] & 0x100 ) {
            this.midi_msg.push(this.asid_reg[i] & 0x7f);
        }
      }

    `
    @midi_msg << 0xf7
  end

  def send_to_midi
    if @midi
      @midi.send(@midi_msg)
      reset_dirty
    end
  end

  def tick(memory)
    process_memory(memory)
    if @update
      convert_to_midi
      send_to_midi
      @update = false
    else
      #puts "nie"
    end
  end
end
