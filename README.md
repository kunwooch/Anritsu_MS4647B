# Anritsu_MS4647B

VNA (Anritsu) Instruction

Files:

	Matlab File 	- VNACollect.m
	LabView File 	- exchangeData_VNA.vi
			- Refer: http://dl.cdn-anritsu.com/en-us/test-measurement/ohs/10450-00008L-MS4640A-VectorStar-HELP/index.html#page/Programming_Commands%2FPM_ApA_ProgrammingBasics_LabView.07.12.html%23

Calibration:

	- Set frequency range on Anritsu first before starting the calibration. It cannot be changed after calibration.	
	- Set up LabView VI ethernet connection before starting the calibration. After controlling Anritsu through LabView, the screen is not adjustable.
	- Connect each port with a mmWave cable and 2.92 mm (K) F to SMA F adapter
	- Port 1 (Open, Short, 50 ohm Impedance), Port 1 (Open, Short, 50 ohm Impedance), Thru
	- Capture the baseline measurement before collecting traces.

Preparation:

	- Connect Anritsu with the computer via Ethernet
	- Order of execution: VNACollect.m --> exchangeData_VNA.vi
	- In the Labview file, the directory where you want to save your file should be added. 
	  The way to change the directory is Openning exchangeData_VNA.vi -> Window -> Show Block Diagram -> replace "C:\Users\lakwe\Dropbox (Princeton)\mmWall2\code\VNAData\081023\prototype2_0.2V_test6\txt\" to your own.
	  Also, change ":SENSE:SWEEP:POINTS 81" under data point number to your own number of frequency sample points.

Troubleshooting the Ethernet connection between LabView and Anritsu (error code 0xBFFF0011):

	- Read http://dl.cdn-anritsu.com/en-us/test-measurement/ohs/10450-00008L-MS4640A-VectorStar-HELP/index.html#page/Programming_Commands%2FPM_ApA_ProgrammingBasics_LabView.07.05.html
	- Open VISA Test Panel as a quick test


Code for KeySight VNA is also included.
