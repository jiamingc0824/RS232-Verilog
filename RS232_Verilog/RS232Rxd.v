`timescale 1ns / 1ps

module RS232Rxd(
    input Reset,
    input Clock16x,
    input Rxd,
    output [7:0] DataOut1,
    output [7:0] DataOut2
    );
    
parameter stIdle = 2'b00, stData = 2'b01, stStop = 2'b11;
    
reg [1:0] presState, nextState;
reg iReset, iRxd1, iRxd2, iClock1xEnable;
reg iClock1x = 1'b1;
reg iEnableDataOut;
reg [3:0] iClockDiv       = 4'b1010;
reg [7:0] iDataOut1       = 8'b00000000;
reg [7:0] iDataOut2       = 8'b00000000;
reg [7:0] iShiftRegister  = 8'b00000000;
reg [3:0] iNoBitsReceived = 4'b0000;
    
always@(posedge Clock16x)
begin
    if (Reset == 1'b1 || iReset == 1'b1) begin
        iRxd1          <= 1'b1;
        iRxd2          <= 1'b1;
        iClock1xEnable <= 1'b0;
        iClockDiv      <= 4'b1010;
    end else begin
        iRxd1 <= Rxd;
        iRxd2 <= iRxd1;
    end

    if (iRxd1 == 1'b0 && iRxd2 == 1'b1) 
        iClock1xEnable <= 1'b1;
    else if (iClock1xEnable == 1'b1) begin
        iClockDiv <= iClockDiv + 1'b1;
        iClock1x <= iClockDiv[3];
    end
end

always@(iClock1x or iClock1xEnable)
begin
    if (iClock1xEnable == 1'b0) begin
        iNoBitsReceived <= 4'h0;
        presState <= stIdle;
    end else if(iClock1x == 1'b1) begin
        iNoBitsReceived <= iNoBitsReceived + 1'b1;
        presState <= nextState;
    end

    if (iClock1x == 1'b1) begin
        if (iEnableDataOut == 1'b1) begin
            iDataOut2 <= iDataOut1;
            iDataOut1 <= iShiftRegister;            
        end else begin
            iShiftRegister <= {Rxd, iShiftRegister[7:1]};
        end
    end
end


assign DataOut1 = iDataOut1;
assign DataOut2 = iDataOut2;

always@(presState, iClock1xEnable, iNoBitsReceived)
begin
    iReset <= 1'b0;
    iEnableDataOut <= 1'b0;
    case (presState)
        stIdle : begin
            if(iClock1xEnable == 1'b1)
                nextState <= stData;
            else
                nextState <= stIdle;
        end 
        stData : begin
            if(iNoBitsReceived == 4'b1000) begin
                iEnableDataOut <= 1'b1;
                nextState <= stStop;
            end else begin
                iEnableDataOut <= 1'b0;
                nextState <= stData;
            end
        end
        stStop : begin
            nextState <= stIdle;
            iReset <= 1'b1;
        end
    endcase
end
endmodule