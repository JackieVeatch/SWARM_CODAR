# SWARM_CODAR

FILL GAPS in CODAR

scripts will interpolate gaps in data surrounded by quality controlled data with minimal smoothing. This is a published technique: 
Fredj, E., Roarty, H., Kohut, J., Smith, M., and Glenn, S. 2016. Gap Filling of the Coastal Ocean Surface Currents from HFR Data: Application to the Mid-Atlantic Bight HFR Network. Journal of atmospheric and oceanic technology, 33: 1097-1111.

fillgaps scripts are two versions of similar code: "add_edges" will put the quality controlled data that is outside of the domain back into the data structure to increase residence time of particles. The domain was defined as every grid point that contains data at least 80% of the time.

PLOT CODAR

function used to plot HFR data from project SWARM (three HFRs deployed around Palmer Deep Canyon from Jan-March 2020). plotting dependencies are located in "antarcticaPlotting" folder. Many thanks to the Rutgers Uiversity Center for Ocean Observing Leadership for the building of a lot of this code, especially Hugh Roarty and Laura Nazarro.
