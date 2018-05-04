#########################################################################
#
#  Octave script to extract form the Cordin images traces the radial expansion as function of time.
#
# It uses the functions:
#	 timeframe						To adjust the Cordin frames into microseconds.
#	 display_rounded_matrix			To write correctly the final output files.



#   This script will work ONLY in the folder with all the Cordin shots AND a folder called RAW-good with the CSV files.

more off; %To make the lines display when they appear in the script, not at the end of it.

clear; %Just in case there is some data in memory.

tic; %Total time of the script.



um = 60; #m/px (Cordin calibration for this MALENA experiment only)

mm = um*1e-3; #mm/px

main_folder = pwd

addpath(main_folder);#to add the path to some functions stored in the main folder.

carpetas_disp = readdir('./'); #Read all files and folders on the main folder.

%~ for i=3: 
for i=3:numel(carpetas_disp) #For every file/folder in the main folder:
  if (isdir(carpetas_disp{i})==1) #łhen there is a folder with data in them,
     disp(horzcat("Working on shot ",carpetas_disp{i})); #Identification of the shot
     cd(carpetas_disp{i}); #Entering folder of the shot
     cd("RAW-good");#Entering folder with the Cording data
     frames = dir("*.csv"); #List of CSV files from frames with traces
     rad = [];
     for j=1:numel(frames)
     	str = frames(j).name; #Filename of the frame CSV data
     	fra_numb = str2num(str(regexp(str,'_')(1)+1:regexp(str,'_')(2)-1)); #Finding the frame number
     	trace = dlmread(frames(j).name, ',',1,0); #reading the CSV file
     	peak =find(trace(:,2)>max(trace(:,2))*0.75); #Peak positions
     	radius = ( abs(peak(1)-peak(end))/2 )*mm; #mm. Radial value from this trace.
     	rad = [rad; timeframe(fra_numb), radius];
     endfor;
    archivo = horzcat(main_folder,'/',carpetas_disp{i},"-rad.txt");
    #Saving data as a pro:
    redond = [2 6];
	output = fopen(archivo,"w"); #Opening the file.
	fdisp(output,"time(µs)	plasma_rad(mm)"); #First line.
	display_rounded_matrix(rad, redond, output); 
	fclose(output);
  endif;
     
  cd ..;
  cd ..;#Return to the general folder

endfor;

rmpath(main_folder); #to remove the path to some functions stored in the main folder.

toc;


#That's...that's all, folks! 
