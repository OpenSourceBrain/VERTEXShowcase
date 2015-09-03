% Load in network structure from NeuroML/LEMS network...

[import_connections,positions,params,populations_ids_sizes_components,population_size_boundaries]=lems_import_to_VERTEX('pointIzhikevichCell_stepI_test2.xml');

[import_connections,positions,TissueParams, NeuronParams,ConnectionParams, ...
 RecordingSettings, SimulationSettings]=neuroml_import_to_VERTEX('pointIzhikevichCell_stepI_test2.net.nml',...
    import_connections,positions,params,populations_ids_sizes_components,population_size_boundaries);
% in this example no cell positions are specified, therefore VERTEX will
% establish cell locations putting a typical soma position array inside
% params.
[params, connections, electrodes] =initNetwork(TissueParams, NeuronParams,ConnectionParams,RecordingSettings, SimulationSettings);

% run simulation

runSimulation(params,import_connections,electrodes);



% load Results which later will be visualized


Results=loadResults(RecordingSettings.saveDir);

plot(Results.v_m(1, :), 'LineWidth', 2,'Color','b') 
hold on
plot(Results.v_m(2,:),'LineWidth',2,'Color','r')
set(gcf,'color','w');
set(gca,'FontSize',16)
title('Membrane potential traces of the IzhikevichCells ID=1 and ID=2', 'FontSize', 16)
xlabel('Time (ms)', 'FontSize', 16)
ylabel('Membrane potential (mV)', 'FontSize', 16)






