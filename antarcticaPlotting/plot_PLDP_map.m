% function to plot map of Palmer Deep
% created Jackie Veatch 3Nov22

function plot_PLDP_map(ylimit, xlimit, bathymetry, location)

    addpath '/Users/jveatch/Documents/MATLAB/Particle_Track_Code/Matlab_Code/antarcticaPlotting'
    addpath '/Users/jveatch/Documents/MATLAB/Particle_Track_Code/Matlab_Code/antarcticaPlotting/functions/'

    
    if bathymetry == 1
        bathy=load ('antarctic_bathy_2.mat');
        ind2= bathy.depthi==99999;
        bathy.depthi(ind2)=[];
        bathylines1=0:-10:-100;
        bathylines2=0:-200:-1400;
        bathylines=[bathylines2];

        [cs, h1] = contour(bathy.loni,bathy.lati, bathy.depthi,bathylines, 'linewidth', .25);
        clabel(cs,h1,'fontsize',6);
        set(h1,'LineColor','black')
        hold on;
    else
    end
    
    
            % the shape file used for this code is split into three different
        % segments, seperated by NaNs. Older versions of MATLAB do not have a
        % problem with this, newer versions (like MATLAB_R2019) do not like
        % this. The code below splits the shape file into three readable
        % pieces.
        tanLand = [240,230,140]./255;
        S1 = shaperead('/Users/jveatch/Documents/MATLAB/Particle_Track_Code/Matlab_Code/antarcticaPlotting/mapping/antarctica_shape/cst00_polygon_wgs84.shp');
%         S1 = shaperead('cst00_polygon_wgs84.shp');
        S2=S1(1:1174);
        ind=[0,find(isnan(S1(1175).X))];
        for x=1:length(ind)-1
            S2(1174+x)=S1(1175);
            S2(1174+x).X=S2(1174+x).X(ind(x)+1:ind(x+1));
            S2(1174+x).Y=S2(1174+x).Y(ind(x)+1:ind(x+1));
        end
        mapshow(S2,'facecolor', tanLand)
    %     set(gca,'color',[ .21, .50, .85]);
        hold on

        %marking location of CODAR stations
        s(1) = plot(-64.0554167, -64.7741833, 'g^',...
            'markersize', 12,...
            'markerfacecolor', [ 0.5843 0.8157 0.9882],...
            'markeredgecolor', 'black');
        s(2) = plot(-64.3604167, -64.7871667, 'gs',...
            'markersize', 12,...
            'markerfacecolor', [ 0.5843 0.8157 0.9882],...
            'markeredgecolor', 'black');
        s(3) = plot(-64.0446333, -64.9183167, 'gd',...
            'markersize', 12,...
            'markerfacecolor', [ 0.5843 0.8157 0.9882],...
            'markeredgecolor', 'black');

        ylim(ylimit)
        xlim(xlimit)

    %     a=narrow(-63.6928384831366,-64.683125,.3); % place north facing arrow on upper right corner of map
    if location == 'none'
    else
        l = legend([s], 'Palmer Station', 'Joubin Islands', 'Wauwermans Islands','Location', location);
    end
    
        project_mercator;
        hold on;