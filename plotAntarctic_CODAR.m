function plotAntarctic_CODAR(X,Y,mag,u_avg,v_avg, min, max, title_string)

    addpath(genpath('/Users/jveatch/Documents/MATLAB/Particle_Track_Code/Matlab_Code/antarcticaPlotting'));
    %the above path must point to a folder with 'parula-mod.mat' and 'cst00_polygon_wgs84.shp'
    
    
    % plot pcolor map of chosen variable

%     t = pcolor(X,Y,mag);
%     hold on
%     shading flat
%     load('parula-mod.mat');
%     cmap = colormap(cmap);
%     c = colorbar;
%     caxis([min max])
%     c.Label.String = 'Current Speed (cm/s)';
%     c.Label.FontSize = 10;
%     title(title_string);
%     
% 	bathy=load ('antarctic_bathy_2.mat');
% 	ind2= bathy.depthi==99999;
% 	bathy.depthi(ind2)=[];
% 	bathylines1=0:-10:-100;
% 	bathylines2=0:-200:-1400;
% 	bathylines=[bathylines2];
% 	
% 	[cs, h1] = contour(bathy.loni,bathy.lati, bathy.depthi,bathylines, 'linewidth', .25);
% 	clabel(cs,h1,'fontsize',6);
% 	set(h1,'LineColor','black')
	hold on
    
    %curvvec(X,Y,u_avg,v_avg);
    %streakarrow(X,Y, u_avg, v_avg, 1.5, 1, 4);
    %%Plot using Quiver
%     lon_test=reshape(X, 101*101,1);
%     lat_test=reshape(Y, 101*101,1);
%     u_test=reshape(u_avg, 101*101,1);
%     v_test=reshape(v_avg, 101*101,1);
    lon_test=reshape(X, length(u_avg)*length(u_avg),1);
    lat_test=reshape(Y, length(u_avg)*length(u_avg),1);
    u_test=reshape(u_avg, length(u_avg)*length(u_avg),1);
    v_test=reshape(v_avg, length(u_avg)*length(u_avg),1);
    
    vec = quiver(lon_test, lat_test, u_test, v_test,2, 'k-');
    set(vec,'linewidth',[1])
    
    
    % the shape file used for this code is split into three different
    % segments, seperated by NaNs. Older versions of MATLAB do not have a
    % problem with this, newer versions (like MATLAB_R2019) do not like
    % this. The code below splits the shape file into three readable
    % pieces.
    tanLand = [240,230,140]./255;
    S1 = shaperead('cst00_polygon_wgs84.shp');
    S2=S1(1:1174);
    ind=[0,find(isnan(S1(1175).X))];
    for x=1:length(ind)-1
        S2(1174+x)=S1(1175);
        S2(1174+x).X=S2(1174+x).X(ind(x)+1:ind(x+1));
        S2(1174+x).Y=S2(1174+x).Y(ind(x)+1:ind(x+1));
    end
    mapshow(S2,'facecolor', tanLand)
    hold on
    
    %marking location of CODAR stations
    s(1) = plot(-64.0554167, -64.7741833, 'b^',...
        'markersize', 12,...
        'markerfacecolor', 'blue',...
        'markeredgecolor', 'black');
    s(2) = plot(-64.3604167, -64.7871667, 'bs',...
        'markersize', 12,...
        'markerfacecolor', 'blue',...
        'markeredgecolor', 'black');
    s(3) = plot(-64.0446333, -64.9183167, 'bd',...
        'markersize', 12,...
        'markerfacecolor', 'blue',...
        'markeredgecolor', 'black');
   
    %Plot the Survey Grid
%     adgr=plot(adelie_lon, adelie_lat, 'r-','linewidth',[2]);
%     gegr=plot(gentoo_lon, gentoo_lat, 'g-','linewidth',[2]);

    
%     ylim([-65.1 -64.64])
%     xlim([-64.6 -63.6])
    ylim([-65.0 -64.7])
    xlim([-64.6 -63.8])
    a=narrow(-63.6928384831366,-64.683125,.3); % place north facing arrow on upper right corner of map
    %l = legend([s,adgr,gegr], 'Palmer Station', 'Wauwermans Islands', 'Joubin Islands', 'Adelie Transect', 'Gentoo Transect','Location', 'SouthEast');
%     l = legend([s], 'Palmer Station',  'Joubin Islands','Wauwermans Islands', 'Station E', 'Location', 'SouthEast');

    project_mercator;
   
   %will save figure as png to current directory
   %change first argument to desired name of figure
   print(title_string,'-dpng')


end