clear all
close all
clc

seasons = {'Winter', 'Autumn', 'Spring', 'Summer'};
years={'2013','2012','2011','2010','2009','2008','2007'};

% years = {'Fall_2007_09_01_0000',...
%     'Spring_2007_03_01_0000',...
%     'Summer_2007_06_01_0000',...
%     'Winter_2006_12_01_0000'};

% years2 = {'Fall - September 1 - December 1',...
%     'Spring - March 1 - June 1',...
%     'Summer - June 1 - September 1',...
%     'Winter - December 1 - March 1'};

for p= 1:length(years)
    yy = years{p};
    
    lon = nc_varget(['/Volumes/home/michaesm/Codar/codar_means/seasonal_means/RU_5MHz_7yearMean_' yy '.nc'], 'lon');
    lat = nc_varget(['/Volumes/home/michaesm/Codar/codar_means/seasonal_means/RU_5MHz_7yearMean_' yy '.nc'], 'lat');
    [Lon,Lat] = meshgrid(lon, lat); % for plotting totals

    u = nc_varget(['/Volumes/home/michaesm/Codar/codar_means/seasonal_means/RU_5MHz_7yearMean_' yy '.nc'], 'u');
    v = nc_varget(['/Volumes/home/michaesm/Codar/codar_means/seasonal_means/RU_5MHz_7yearMean_' yy '.nc'], 'v');

    coast = load('/Users/rucool/Documents/MATLAB/Mapping/MARACOOS_Complete_Coast.mat');
    coast = coast.ncst;
    e = plot(coast(:,1), coast(:,2), 'k', 'linewidth', 2);
    hold on
    plot_bathymetry;
    hold on
    
    mag = sqrt(u.^2 + v.^2); % current year magnitude
        
    t = pcolor(Lon,Lat,mag);
    hold on
    shading flat
    caxis([0 30]);
    cmap = colormap('autumn');
    cmap = cmap(end:-1:1,:);
    cmap = colormap(cmap);
    colorbar
    
    indNaN = isnan(u+v);
    u(indNaN) = [];
    v(indNaN) = [];
    Lon(indNaN) = [];
    Lat(indNaN) = [];

%     L = sqrt(u.^2 + v.^2); % vector length
%     L = L(1:6:end);
%     i = quivers(Lon(1:6:end), Lat(1:6:end), u(1:6:end), v(1:6:end),2, 4, 'cm/s', 'k');
    
    L = sqrt(u.^2 + v.^2); % vector length
    L = L(1:6:end);
    i = quivers(Lon(1:6:end), Lat(1:6:end), u(1:6:end)./L, v(1:6:end)./L,.4, 4, 'cm/s', 'k');
    hold on
   
    mapxlim = [-76 -67.8];
    mapylim = [35 43];

    xlim(mapxlim);
    ylim(mapylim);
%     daspect([4 3 1])
    project_mercator;
    grid on
    
    title({'Seven Year (2007-2013) Mean';['Season: ' years2{p}]});
    
    print('-dpng', ['7yearSeasonalAnomaly-' yy '-totals-magnitude'])


    close all

end