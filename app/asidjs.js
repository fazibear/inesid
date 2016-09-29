function interval(duration, fn){
  this.baseline = undefined

  this.run = function(){
    if(this.baseline === undefined){
      this.baseline = new Date().getTime()
    }
    fn()
    var end = new Date().getTime()
    this.baseline += duration

    var nextTick = duration - (end - this.baseline)
    if(nextTick<0){
      nextTick = 0
    }
    (function(i){
        i.timer = setTimeout(function(){
        i.run(end)
      }, nextTick)
    })(this)
  }
}

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

  this.oldMemory = [];

  // this.tick = function(memory){
  //   for(var i = 0; i < this.asidRegSize; ++i){
  //     if(memory[i] != this.oldMemory[i]){
  //       this.write(i, memory[i]);
  //     }
  //   }
  //   this.oldMemory = memory;
  // }

  this.flush = function(sth){
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
      this.midiOut.send(stream, 0, 0);
    }

    for(var i = 0; i < this.asidRegSize; ++i){
      this.asidReg[i] &= 0xff;
    }
  }

  this.write = function(addr, data){
    this.writeCount++;
    addr = addr - 0xd400;

    if(addr < 0 || addr >= this.asidRegSize) return;

    mappedAddr = this.map[addr];

    if(mappedAddr >= 0x16 && mappedAddr <= 0x18 && this.asidReg[mappedAddr] & 0x100){
      mappedAddr += 3;

      if(this.asidReg[mappedAddr] & 0x100){
        this.asidReg[mappedAddr - 3] = this.asidReg[mappedAddr];
      }
    }

    if(this.asidReg[mappedAddr] & 0x100) {
      if(mappedAddr >= 0x16) {
        this.flush();
      }
    }

    this.asidReg[mappedAddr] = data | 0x100;

    if(this.writeCount > 15){
      this.writeCount = 0
      this.flush();
    }
  }

  // this.periodic = new interval(20, function(){
  //   this.flush(1);
  // }.bind(this));
  // this.periodic.run();

}
