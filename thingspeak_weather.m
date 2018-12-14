%% Clear vars
clearvars 'humidity' 'temp';

%% Access parameters
readChannelID = 648344;
readAPIKey   = 'C6YFHEP08CPAPN4R';
thingSpeakAuthenticate(readChannelID, 'ReadKey', readAPIKey);

%% Read Data %%
fieldID1 = 1;
[temp, time_temp] = thingSpeakRead(readChannelID, 'Field', fieldID1, ...%     'NumPoints', 600,...
    'NumDays', 5,...
    'ReadKey', readAPIKey);

fieldID2 = 2;
[humidity, time_hum] = thingSpeakRead(readChannelID, 'Field', fieldID2,...% 'NumPoints', 600,...
    'NumDays', 5,...
    'ReadKey', readAPIKey);

%% Clean-up possible wrong readings
valid_temp = [-40 150];
valid_hum = [0 100];
bad_ind_temp = ~and(temp>=valid_temp(1),temp<=valid_temp(2));
bad_time_temp = time_temp(bad_ind_temp);
bad_ind_hum = ~and(humidity>=valid_hum(1),humidity<=valid_hum(2));
bad_time_hum = time_hum(bad_ind_hum);
bad_time = unique([bad_time_temp;bad_time_hum]);
valid_ind_temp = ~ismember(time_temp,bad_time);
valid_ind_hum = ~ismember(time_hum,bad_time);
time_temp = time_temp(valid_ind_temp);
temp = temp(valid_ind_temp);
time_hum = time_hum(valid_ind_hum);
humidity = humidity(valid_ind_hum);

%% Visualize Data %%
close all;
scrnsize = get( groot, 'Screensize' );
wdth = 560;
hght = 420;
% Temperature
spec_temp_lo = [18,18];
spec_temp_hi = [22,22];
figure('Name','Temperature','NumberTitle','off','OuterPosition',[scrnsize(3)/2-wdth scrnsize(4)*0.95-hght wdth hght]);
plot(time_temp, temp,'gd-');hold on;
a = get(gca);
plot(a.XLim,spec_temp_lo,'r-',a.XLim,spec_temp_hi,'r-');hold off;
% axis([a.XLim floor(a.YLim(1))-0.5 floor(a.YLim(2))+1]);
title('Temperature (°C)');
% Humidity
spec_hum_lo = [40,40];
spec_hum_hi = [60,60];
figure('Name','Humidity','NumberTitle','off','OuterPosition',[scrnsize(3)/2 scrnsize(4)*0.95-hght wdth hght]);
plot(time_hum,humidity,'bo-');hold on;
a = get(gca);
plot(a.XLim,spec_hum_lo,'r-',a.XLim,spec_hum_hi,'r-');hold off;
% axis([a.XLim (floor(a.YLim(1)/3)-1)*3 (floor(a.YLim(2)/3)+1)*3]);
title('Humidity (%rH)');