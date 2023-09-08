close all
clear all

lims=[-65-30/60 -63 -65-30/60 -64-20/60];
%lims=[-64-45/60 -64 -65-0/60 -64-45/60];

%% zoom in
%lims=[-64-4/60 -64-2/60 -64-47/60 -64-46/60];

coastFileName = '/Users/hroarty/data/coast_files/Antarctica4.mat';
hold on
%figure
plotBasemap(lims(1:2),lims(3:4),coastFileName,'mercator','patch',[0.5 0.5 0.5]);

% m_proj('stereographic','lat',-90,'radius',40);
% %m_grid('xtick',12,'tickdir','out','ytick',[-60 -70 -80],'linest','-');
% m_grid('XaxisLocation', 'top','ytick',[-60 -70 -80],'linest','-');
% m_coast('patch',[.5 .5 .5],'edgecolor','k');
% m_elev('contour',[-5000:1000:-1000],'edgecolor','k');





%% plot_bathymetry

% bathy=load ('/Users/hroarty/data/bathymetry/antarctica/antarctic_bathy_3.mat');
% ind2= bathy.depthi==99999;
% bathy.depthi(ind2)=NaN;
% bathylines1=0:-10:-100;
% bathylines2=0:-200:-1400;
% bathylines=[ bathylines2];
% 
% [cs, h1] = m_contour(bathy.loni,bathy.lati, bathy.depthi,bathylines);
% clabel(cs,h1,'fontsize',8);
% set(h1,'LineColor','k')
% 
% [cs2, h2] = m_contour(bathy.loni,bathy.lati, bathy.depthi,[-6 -6]);
% set(h2,'LineColor','r')

%% -------------------------------------------------
%% Plot location of sites

%% read in the Antarctic sites
dir='/Users/hroarty/data/';
file='antarctic_codar_sites.txt';
[C]=read_in_maracoos_sites(dir,file);

sites=[5 6 7];

%% plot the location of the sites
for ii=5:7
    hdls.RadialSites=m_plot(C{3}(ii),C{4}(ii),'^r','markersize',8,'linewidth',2);
    m_text(C{3}(ii),C{4}(ii),C{2}(ii))
end



%m_plot(C{3},C{4},'^r','markersize',8,'linewidth',2);

%% -------------------------------------------------
%% Plot the grid
% try
% %% read in the MARACOOS sites
% dir='/Users/hroarty/data/grid_files/';
% file='Combine_ANTA.grd';
% [G]=read_in_CODAR_grid(dir,file);
% 
% sites=[1 2 3 4];
% 
% color={'k','r','m','c'};
% 
% %% plot the location of the grid
% 
%     %hdls.grid=m_plot(G{4},G{5},'.k','markersize',4);
%  
%     flags=unique(G{3});
%     
%     for ii=1:length(flags)
%         ind=find(G{3}==flags(ii));
%         m_plot(G{4}(ind),G{5}(ind),'.','markersize',4,'Color',color{ii});
%     end
% catch
% end


timestamp(1,'/Users/hroarty/Documents/MATLAB/Antarctic_map_Plot.m')
print(1,'-dpng','-r200','Antarctic_Map_v9.png')
