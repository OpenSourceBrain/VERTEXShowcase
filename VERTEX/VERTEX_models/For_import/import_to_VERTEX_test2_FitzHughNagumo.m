% Load in network structure from NeuroML/LEMS network...

[import_connections,positions,params,populations_ids_sizes_components,population_size_boundaries]=lems_import_to_VERTEX('Run_FitzHughNagumo.xml');

[import_connections,positions,TissueParams, NeuronParams,ConnectionParams, ...
 RecordingSettings, SimulationSettings]=neuroml_import_to_VERTEX('Run_FitzHughNagumo.xml',...
    import_connections,positions,params,populations_ids_sizes_components,population_size_boundaries);
% in this example no cell positions are specified, therefore VERTEX will
% establish cell locations putting a typical soma position array inside
% params.
[params, connections, electrodes] =initNetwork(TissueParams, NeuronParams,ConnectionParams,RecordingSettings, SimulationSettings);

% run simulation

runSimulation(params,import_connections,electrodes);



% load Results which later will be visualized


Results=loadResults(RecordingSettings.saveDir);
num_label=0:50:SimulationSettings.simulationTime;
label_array=cell(1,length(num_label));

for i=1:length(num_label)
    label_array{i}=num2str(num_label(i));
end
plot(Results.v_m(1, :), 'LineWidth', 2,'Color','b')
set(gcf,'color','w');
set(gca,'XTickLabel',label_array)
set(gca,'FontSize',16)
title('Membrane potential trace of the FitzHughNagumoCell', 'FontSize', 16)
xlabel('Time (ms)', 'FontSize', 16)
ylabel('Membrane potential (mV)', 'FontSize', 16)






