clear all
close all
clc

addpath(genpath('/Projects/CONVERGE/antarcticaPlotting/'));

%fileDir = '/Volumes/Ocean Home/palamara/codar_antarctica/'; %Location of files
fileDir = '/Volumes/Ocean Home/palamara/codar_antarctica/'; %Location of files
%fileDir = '/Projects/CONVERGE/Year2Processing/Totals/1km/nc/measured/';

saveDir = '/Projects/CONVERGE/Year2Processing/Images/'; % where to save images

filePrefix = 'OI_PLDP_'; %prefix of totals in nc format

t0 = datenum(2014, 12, 20, 1, 0, 0);
%t0 = datenum(2014, 12, 16, 14, 0, 0);
t1 = []; %datenum(2014, 11, 18, 4, 0, 0);

if isempty(t1)
    dTimes = t0;
else
    dTimes = [t0:1/24:t1];
end

% tNow = floor(epoch2datenum(java.lang.System.currentTimeMillis*.001));
% tStart = tNow - 1;
% dTimes = [tNow:-1/24:tStart];
% 
for r = 1:length(dTimes)
    fNames{r} = [filePrefix datestr(dTimes(r), 'yyyy_mm_dd_HH00')];
    fLocs{r} = [fileDir fNames{r} '.totals.nc'];
end

for p= 1:length(fLocs)
    yy = fLocs{p};
    
    if ~exist(yy, 'file');
        disp('File does not exist yet. Continuing...');
        continue
    end
    
    lon = ncread(yy, 'lon'); %grab lons
    lat = ncread(yy, 'lat'); %grab lats
    u = ncread(yy, 'u'); %grab raw u
    v = ncread(yy, 'v'); %grab raw v
    div = ncread(yy, 'div'); %grab divergence
    u_err = ncread(yy, 'u_err');
    v_err = ncread(yy, 'v_err');
    
    [X,Y] = meshgrid(lon, lat); %create grid from lons lats
    X = X'; %rotate grid
    Y = Y'; %rotate grid

    %% find -999 and turn into NaN
    u(u == -999) = NaN; v(v == -999) = NaN;
    X(isnan(u)) = NaN; Y(isnan(u)) = NaN;
    
    %% Find errors for u + v greater than 0.6 and filter out
    indUErr = find(u_err > 0.6); % find u errors greater than 0.6
    indVErr = find(v_err > 0.6); % find v errors greater than 0.6
   
    u(indUErr) = NaN; v(indUErr) = NaN; 
    u(indVErr) = NaN; v(indVErr) = NaN;
 
    %% Make sure the grid has nans in place of actual numbers (for plotting purposes)
    X(isnan(u)) = NaN; Y(isnan(u)) = NaN;
    
    mag = sqrt(u.^2 + v.^2); % current year magnitude
    
    %% plot pcolor map of chosen variable
    t = pcolor(X,Y,mag);
    hold on
    shading flat
%     shading interp
    load('parula-mod.mat');
    cmap = colormap(cmap);
    c = colorbar;
    caxis([0 35])
    c.Label.String = 'Current Speed (cm/s)';
    c.Label.FontSize = 18;   
 
    %% plot antarctic bathymetry    
	bathy=load ('antarctic_bathy_2.mat');
	ind2= bathy.depthi==99999;
	bathy.depthi(ind2)=[];
	bathylines1=0:-10:-100;
	bathylines2=0:-200:-1400;
	bathylines=[bathylines2];
	
	[cs, h1] = contour(bathy.loni,bathy.lati, bathy.depthi,bathylines, 'linewidth', .25);
	clabel(cs,h1,'fontsize',6);
	set(h1,'LineColor','black')
	hold on
    
    streakarrow(X,Y, u, v, 1.5, 1, 4);
    hold on

    tanLand = [240,230,140]./255;
    S1 = shaperead('cst00_polygon_wgs84.shp');
    mapshow([S1.X], [S1.Y], 'DisplayType', 'polygon', 'facecolor', tanLand)
    hold on
    
    s(1) = plot(-64.0554167, -64.7741833, 'g^',...
        'markersize', 12,...
        'markerfacecolor', 'green',...
        'markeredgecolor', 'black');
    s(2) = plot(-64.3604167, -64.7871667, 'gs',...
        'markersize', 12,...
        'markerfacecolor', 'green',...
        'markeredgecolor', 'black');
    s(3) = plot(-64.0446333, -64.9183167, 'gd',...
        'markersize', 12,...
        'markerfacecolor', 'green',...
        'markeredgecolor', 'black');
   
    ylim([-65.1 -64.64])
    xlim([-64.6 -63.6])
    a=narrow(-63.6928384831366,-64.683125,.3); % place north facing arrow on upper right corner of map
    l = legend(s, 'Palmer Station', 'Wauwermans Islands', 'Joubin Islands', 'Location', 'SouthEast');

    project_mercator;
    ind = find(yy == '/');
    file = yy(ind(end)+1:end);
    indA = find(file == '_');
    indB = find(file == '.');
    fileStr = file(indA(2)+1:indB(1)-1);
    
    yearStr = fileStr(1:4); %year
    monthStr = fileStr(6:7);%month
    dayStr = fileStr(1:10);%year_month_day
    hourStr = fileStr(12:13);%hour
    
    dirListing = [saveDir yearStr '_' monthStr '/']; 
    
    if ~exist(dirListing, 'dir')
        mkdir(dirListing)
    end

    fileStr = {'Project Converge Totals';...
        '0.5km Grid Spacing - Measured Pattern';...
        datestr(datenum([dayStr ' ' hourStr], 'yyyy_mm_dd HH'), 31)};
    title(fileStr);
    
    set(gcf, 'paperposition', [0 0 11 8.5]);
%     set(gcf, 'paperorientation', 'landscape');
    print('-dpng', [dirListing fNames{p} '.png'], '-r150')


    close all

end