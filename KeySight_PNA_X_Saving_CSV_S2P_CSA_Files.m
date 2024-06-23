function PNA_X_Saving_CSV_S2P_CSA_Files(dirname, filename)
% Keysight Technical Contact Center
% 
% December 1, 2014
% 
% Example SCPI command sequence to illustrate one way to save .csv, .s2p, and .csa files.  See comments for command usage details.  Example was tested with PNA firmware revision A.10.20.03.  
% 
% Offered as-is, without warranty, or technical support.  Use this strictly for instructional purposes.
% 
% TJA
% 
% 
% 
%

% % Variable declarations
% 
% Connect steps
N5242A = visa('agilent', 'USB0::0x0957::0x0118::US51370439::0::INSTR');
N5242A.InputBufferSize = 8388608;
N5242A.ByteOrder = 'littleEndian';
fopen(N5242A);

% Unable to generate code for step : (SET DefaultTimeout to 5000)
% Commands
% % Preset PNA-X, send ID query, and check for existing errors...
% fprintf(N5242A, ':SYSTem:PRESet');
% string = query(N5242A, '*IDN?');
% C = textscan(query(N5242A, ':SYSTem:ERRor?'), '%d%q', 'Delimiter', ',');
% errorid = C{1};
% errorString = C{2}{1};

% Define S21 trace named "my_fwd_xmission" centered at 10GHz with span of 4GHz and 5 measurement points; push it to display...
fprintf(N5242A, ':CALCulate:PARameter:DELete:ALL');
fprintf(N5242A, sprintf(':CALCulate1:PARameter:DEFine:EXTended "%s","%s"', 'my_fwd_xmission', 'S21'));
C = textscan(query(N5242A, ':CALCulate1:PARameter:CATalog?'), '%q', 'Delimiter', ',');
data = C{1}{1};

fprintf(N5242A, sprintf(':DISPlay:WINDow1:TRACe1:FEED "%s"', 'my_fwd_xmission'));
fprintf(N5242A, sprintf(':SENSe1:FREQuency:CENTer %g GHZ', 24.0));
fprintf(N5242A, sprintf(':SENSe1:FREQuency:SPAN %g GHZ', 8.0));
fprintf(N5242A, sprintf(':SENSe1:SWEep:POINts %d', 5001));
% Command PNA to do a single sweep before transferring data...
fprintf(N5242A, sprintf(':INITiate1:CONTinuous %d', 0));
fprintf(N5242A, ':INITiate1:IMMediate');
% You need to select the measurement for which you want to save data.
fprintf(N5242A, sprintf(':CALCulate1:PARameter:SELect "%s"', 'my_fwd_xmission'));
% #
% SETTING UP A DIRECTORY FOLDER AND MAKING IT THE CURRENT DIRECTORY
% Create a new subfolder named "Landfill" in an existing folder named "Ted" on the PNA-X's SSD D-Partition; verify folder was created via *OPC?
fprintf(N5242A, sprintf(':MMEMory:MDIRectory "%s"', strcat('D:\\KC\\',dirname)));
opc = sscanf(query(N5242A, '*OPC?'), '%d');
% Change the current directory to one in which the saved data file is stored in the "Landfill" folder and verify with *OPC? query.
fprintf(N5242A, sprintf(':MMEMory:CDIRectory "%s"', strcat('D:\\KC\\',dirname)));
opc1 = sscanf(query(N5242A, '*OPC?'), '%d');
% Query PNA-X for the "Measurement Number" of the selected measurement; use Calc:Par:MNUM? to read the measurement number of the selected trace.
n = sscanf(query(N5242A, ':CALCulate1:PARameter:MNUMber:SELect?'), '%d');
% Command below references Measurement Number = 1, for which we queried using CALC:PAR:MNUM:SEL? and this is used for the "selector" paremeter below.
% Use MMEMory:STORe:DATA <filename>,<type>,<scope>,<format>,<selector> command to save the desired file for a particular trace.
%
% This command stores trace data to the following file types: *.prn, *.cti, *.csv, *.mdf   
%
% The parameters for this command are as follows with the data type in parentheses:
% <filename with extension> (String); <type> (String); <scope> (String); <format> (String); <selector> (Numeric)
% The MMEM:STOR:DATA command below uses the following parameters in this example:
% "my_DUT_data.csv" is the filename string.
% "CSV Formatted Data" is the type string.
% "Trace" is the scope string.
% "Displayed" is the format string.
% "1" is the selector numeric value that that corresponds to the measurement number.

% fprintf(N5242A, sprintf(':MMEMory:STORe:DATA "%s","%s","%s","%s",%d', strcat(filename, '.csv'), 'CSV Formatted Data', 'Trace', 'Displayed', 1));
% opc2 = sscanf(query(N5242A, '*OPC?'), '%d');

% #
% SAVING A TWO-PORT TOUCHSTONE FILE
% To save Touchstone (a.k.a. snp) files, use the Calc:Data:SNP:PORTs:SAVE command.
% Before saving the Touchstone file, we need to tell PNA-X the file format using MMEMory:STORe:TRACe:FORMat:SNP <char> where parameters are:
% MA - Linear Magnitude / degrees
% DB - Log Magnitude / degrees
% RI - Real / Imaginary
% AUTO - data is output in currently selected trace format. If other than LogMag, LinMag, or Real/Imag, then output is in Real/Imag.
% In this case, I choose to save the snp data in Real Imaginary format.
fprintf(N5242A, sprintf(':MMEMory:STORe:TRACe:FORMat:SNP %s', 'RI'));
% The command that actually saves the Touchstone file uses one parameter to specify the ports involved and the other to specify storage path as well as file name.
% For the S21 measurement in this example, test ports 1 and 2 are specified as "1,2" for the first parameter.
% I save the two-port Touchstone file using the second parameter using "D:\Ted\Landfill\my_DUT_data.s2p" in this example.
fprintf(N5242A, sprintf(':CALCulate1:DATA:SNP:PORTs:SAVE "%s","%s"', '1,2', strcat('D:\\KC\\',dirname,filename,'.s2p')));
opc3 = sscanf(query(N5242A, '*OPC?'), '%d');

% % #
% % SAVING A CALIBRATION AND/OR STATE FILE
% % To save state and calibration files, we use MMEMory:STORe[:<char>] <file> where:
% % <char> is an optional argument that sets the type of file to store. Choose from:
% % STATe - Instrument states (.sta)
% % CORRection - Calibration Data (.cal)
% % CSARchive - Instrument state and calibration data (.csa)
% % CSTate - Instrument state and link to Calibration data (.cst)
% % In this case I choose to save a .csa file for the existing state with a file name of my_DUT_test.csa located at D:\Ted\Landfill\ as shown here:
% fprintf(N5242A, sprintf(':MMEMory:STORe:CSARchive "%s"', 'D:\\KC\\my_DUT_test2.csa'));
% opc4 = sscanf(query(N5242A, '*OPC?'), '%d');
% % Check for errors after executing entire sequence.
% C = textscan(query(N5242A, ':SYSTem:ERRor?'), '%d%q', 'Delimiter', ',');
% errorid1 = C{1};
% errorString1 = C{2}{1};


% Cleanup
fclose(N5242A);
delete(N5242A);
clear N5242A;

end
