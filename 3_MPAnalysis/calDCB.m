function [DCBCorC1C_to_C1W,DCBCorC1W_to_C2W,DCBCorC1C_to_C5Q,DCBCorC2I_to_C6I] = calDCB(input)
%Calculate the DCB correction number of each satellite at each frequency

%INPUT:
%inut:A structure containing bias information, specifically the DSB
% (Differential Signal Bias) data

%OUTPUT:
%DCBCorC1C_to_C1W: DCB corrections for C1C to C1W frequencies (114x1 array)
%DCBCorC1W_to_C2W: DCB corrections for C1W to C2W frequencies (114x1 array)
%DCBCorC1C_to_C5Q: DCB corrections for C1C to C5Q frequencies (114x1 array)
%DCBCorC2I_to_C6I: DCB corrections for C2I to C6I frequencies (114x1 array)

%Copyright (C) GCC Group
%--------------------------------------------------------------------------
% Extract the DSB data from the input structure
SinexDSB=input.bias.DSB;
% Initialize output arrays to store DCB corrections for all 114 satellites
DCBCorC1C_to_C1W=zeros(114,1);
DCBCorC1W_to_C2W=zeros(114,1);
DCBCorC1C_to_C5Q=zeros(114,1);
DCBCorC2I_to_C6I=zeros(114,1);
for i=1:114
    if i<=32  
        % GPS satellites (G01 to G32)
        C1C_to_C1W = 'C1CC1W';
        C1W_to_C2W = 'C1WC2W';
        formattedStr = sprintf('%02d', i);
        DCBsv=['G' formattedStr];

         % Check if the field exists and assign the DCB correction value
        if isfield(SinexDSB.(DCBsv), C1C_to_C1W)
            DCBCorC1C_to_C1W(i)=input.bias.DSB.(DCBsv).(C1C_to_C1W).value;
        end
        if isfield(SinexDSB.(DCBsv), C1W_to_C2W)
            DCBCorC1W_to_C2W(i)=input.bias.DSB.(DCBsv).(C1W_to_C2W).value;
        end            
    elseif i>32&&i<=68
        % Galileo satellites (E01 to E36)
        C1C_to_C5Q = 'C1CC5Q';
        formattedStr = sprintf('%02d', (i-32));
        DCBsv=['E' formattedStr];
        if isfield(SinexDSB.(DCBsv), C1C_to_C5Q)
            DCBCorC1C_to_C5Q(i)=input.bias.DSB.(DCBsv).(C1C_to_C5Q).value;
        end
    else
        % BeiDou satellites (C01 to C46)
        C2I_to_C6I = 'C2IC6I';
        formattedStr = sprintf('%02d', (i-68));
        DCBsv=['C' formattedStr];
        if isfield(SinexDSB.(DCBsv), C2I_to_C6I)
            DCBCorC2I_to_C6I(i)=input.bias.DSB.(DCBsv).(C2I_to_C6I).value;
        end
    end
end
end