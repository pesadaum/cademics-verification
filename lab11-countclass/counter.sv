///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : counter.sv
// Title       : Simple class
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Simple counter class
// Notes       :
//
///////////////////////////////////////////////////////////////////////////

module counterclass ();

  class counter;
    int count, min, max;

    function new(input int cnt=0, min=0, max=100);
      check_lim(min, max);
      check_set(cnt);
    endfunction

    function int getcount();
      return this.count;
    endfunction

    function void load(input int val);
      check_set(val);
    endfunction

    function void check_lim(input int a, b);
      if(a > b) begin
        this.min = b;
        this.max = a;
      end
      else if (a < b) begin
        this.min = a;
        this.max = b;
      end
      else begin
        $display("Limits are equal. Assigning zero to both");
        this.min = 0;
        this.max = 0;
      end
    endfunction

    function void check_set(set);
      if ((this.min > set) || (set > this.max)) begin
        $display("Set (%0d) is out of bounds (%0d, %0d)", set, this.min, this.max);
        this.count = this.min;
      end
      else this.count = set;
    endfunction

  endclass

  class downCounter extends counter;
    bit borrow;
    static int down_n = 0;

    function new(input int cnt, min, max);
      super.new(cnt, min, max);
      this.borrow = 0;
      this.down_n++;
    endfunction

    function int get_n_instances();
      return this.down_n;
    endfunction

    function void next();
      if (this.count == this.min) begin
        this.borrow = 1;
        this.count = this.max;
      end
      else begin
        this.borrow = 0;
        this.count--;
        $display("downCounter decremented. Current value is: %0d", this.count);
      end
    endfunction

  endclass //downCounter extends counter

  class upCounter extends counter;
    bit carry;
    static int up_n = 0;

    function new(input int cnt, min, max);
      super.new(cnt, min, max);
      this.carry = 0;
      this.up_n++;
    endfunction

    function int get_n_instances();
      return this.up_n;
    endfunction

    function void next(debug=0);
      if (this.count == this.max) begin
        this.carry = 1;
        this.count = this.min;
      end
      else begin
        this.carry = 0;
        this.count++;
        if (debug)
          $display("upCounter incremented. Current value is: %0d", this.count);
      end
    endfunction

  endclass //downCounter extends counter

  class timer;
    upCounter hours, mins, secs;

    function new(input int h=0, m=0, s=0);
      hours = new(h, 0, 23);
      mins = new(m, 0, 59);
      secs = new(s,0,59);
      $display(hours.count, mins.count, secs.count);
    endfunction //new()

    function void load(input int h, m, s);
      hours.load(h);
      mins.load(m);
      secs.load(s);
    endfunction

    function void showval();
      $display("Time is (24hr format): %0d:%0d:%0d", hours.count, mins.count, secs.count);
    endfunction

    function void next();
      secs.next();
      if(secs.carry) mins.next();
      if(mins.carry) hours.next();
    endfunction

  endclass //timer


  // downCounter down  = new(0, 0, 10);
  // downCounter down2 = new(0, 0, 10);
  // upCounter   up    = new(0, 0, 10);
  // upCounter   up2   = new(0, 0, 10);
  // upCounter   up3   = new(0, 0, 10);

  timer t = new(23, 58, 00);


  initial begin

    repeat(10) begin
      #1 t.next();
      t.showval();
    end

    $display("Loading values to timer");
    t.load(23, 59, 00);

    repeat (65) begin
      #1 t.next();
      t.showval();
    end






    // $display("testing upCounter");
    // for (int i = 0; i < 25  ; i++) begin
    //   up.next();
    //   if (up.carry) $display("|-> Carry happened");
    // end

    // $display("testing downCounter");
    // for (int i = 0; i < 25  ; i++) begin
    //   down.next();
    //   if (down.borrow) $display("|-> borrow happened");
    // end

    // $display("\nThere are %0d upcounters and %0d downcounters", up.get_n_instances(), down.get_n_instances());

  end

endmodule
