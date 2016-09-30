function ASID(){
  this.writeCount = 0;
  this.midiOut = null;
  this.setMidiOut = function(midiOut){
    console.log(midiOut);
    this.midiOut = midiOut;
  };

  this.asidRegSize = 28;
  this.asidReg = [];
  for(var i = 0; i < this.asidRegSize; ++i){
    this.asidReg.push(0x100);
  }

  this.map = [
    0x00, 0x01, 0x02, 0x03, 0x16, 0x04, 0x05,
    0x06, 0x07, 0x08, 0x09, 0x17, 0x0a, 0x0b,
    0x0c, 0x0d, 0x0e, 0x0f, 0x18, 0x10, 0x11,
    0x12, 0x13, 0x14, 0x15, 0x19, 0x1a, 0x1b
  ]

  this.start = function(){
    this.asidReg[0x18-3] = (this.asidReg[0x18-3] & 0x0f) | 0x100
    this.flush()
  }

  this.stop = function(){
    this.asidReg[0x18-3] = (this.asidReg[0x18-3] & 0xf0) | 0x100
    this.flush()
  }

  this.flush = function(){
    var stream = [];
    var updateRequired = 0;

    for(var i = 0; i < this.asidRegSize; ++i) {
      if( this.asidReg[i] & 0x100 ) {
        updateRequired = 1;
      }
    }

    if(!updateRequired){
      return;
    }

    stream.push(0xf0);
    stream.push(0x2d);
    stream.push(0x4e);

    for(var maskByte = 0; maskByte < 4; ++maskByte){
      var reg = 0x00;
      for(var regOffset = 0; regOffset < 7; ++regOffset){
        if(this.asidReg[maskByte*7 + regOffset] & 0x100){
          reg |= (1 << regOffset);
        }
      }
      stream.push(reg);
    }

    for(var msbByte = 0; msbByte < 4; ++msbByte){
      var reg = 0x00;
      for(var regOffset = 0; regOffset < 7; ++regOffset){
        if(this.asidReg[msbByte * 7 + regOffset] & 0x80){
          reg |= (1 << regOffset);
        }
      }
      stream.push(reg);
    }

    for(var i = 0; i < this.asidRegSize; ++i){
      if(this.asidReg[i] & 0x100){
        stream.push(this.asidReg[i] & 0x7f);
      }
    }

    stream.push(0xf7);

    if(this.midiOut){
      this.midiOut.send(stream);
    }

    for(var i = 0; i < this.asidRegSize; ++i){
      this.asidReg[i] &= 0xff;
    }
  }

  this.write = function(addr, data){
    addr = addr - 0xd400;
    if(addr < 0 || addr >= this.asidRegSize) return;

    this.writeCount++;

    mappedAddr = this.map[addr];

    if(mappedAddr >= 0x16 && mappedAddr <= 0x18 && this.asidReg[mappedAddr] & 0x100){
      mappedAddr += 3;

      if(this.asidReg[mappedAddr] & 0x100){
        this.asidReg[mappedAddr - 3] = this.asidReg[mappedAddr];
      }
    }

    if(this.asidReg[mappedAddr] & 0x100) {
      this.writeCount = 0
      this.flush();
    }

    this.asidReg[mappedAddr] = data | 0x100;

    if(this.writeCount > 25){
      this.writeCount = 0
      this.flush();
    }
  }
}
