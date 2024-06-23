dirname = 'C:\Users\username\txt\';

%Labview connection settings
number_of_retries = -1; % set to -1 for infinite
port=2057; % This code use for communication "port" and "port+1"
host='localhost';   
samplingrate=1000; %in ms
loop = true;
data_to_send='filename';
data_received = exchangeData(port,host,number_of_retries,samplingrate,data_to_send);
while loop
    if(numel(data_received)>0) && (exist([dirname data_to_send '.txt'], 'file') == 2)
        fprintf(['VNA saved: ', data_to_send, '\n'])
        loop = false;
    end
end


