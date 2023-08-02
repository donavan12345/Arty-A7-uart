// TODO: Create generic rx and tx and then modport for direction
interface itf_rx #(parameter PACK_SIZE = 8) (input clk);
    logic rx_bit;
    logic rx_byte_valid;
    logic [PACK_SIZE - 1 : 0] rx_byte_data;
    logic rx_active;

modport routing (input rx_bit, 
             output rx_byte_valid,
             output rx_byte_data,
             output rx_active
);

modport proc (output rx_bit,
              input rx_byte_valid,
              input rx_byte_data,
              input rx_active
);


endinterface