TissueParams.X=250; % dimensions of the model (X,Y,Z) are given in mm
TissueParams.Y=80;  % X,Y,Z values are chosen so that total number of neurons in 
TissueParams.Z=20;  % the model is 10.
TissueParams.neuronDensity=25000;
TissueParams.numLayers=1;
TissueParams.layerBoundaryArr=[20, 0]; 
TissueParams.numStrips=10;
TissueParams.maxZOverlap=[-1, -1];

%Cell population 1
NeuronParams(1).modelProportion = 0.50;
NeuronParams(1).somaLayer = 1;
NeuronParams(1).neuronModel='adex';
NeuronParams(1).V_t = -50;
NeuronParams(1).delta_t = 2;
NeuronParams(1).a = 2.6;
NeuronParams(1).tau_w = 65;
NeuronParams(1).b = 220;
NeuronParams(1).v_reset = -60;
NeuronParams(1).v_cutoff = -45;
NeuronParams(1).numCompartments=2;
NeuronParams(1).somaID=1;
NeuronParams(1).compartmentParentArr = [0, 1];
NeuronParams(1).compartmentLengthArr = [13 48];
NeuronParams(1).compartmentDiameterArr = ...
  [29.8, 3.75];
NeuronParams(1).compartmentXPositionMat = ...
[   0,    0;
    0,    0];
NeuronParams(1).compartmentYPositionMat = ...
[   0,    0;
    0    ,0];
NeuronParams(1).compartmentZPositionMat = ...
[ -13,    0;
    0,   48];
NeuronParams(1).axisAligned = 'z';
NeuronParams(1).C = 1.0*2.96;
NeuronParams(1).R_M = 20000/2.96;
NeuronParams(1).R_A = 150;
NeuronParams(1).E_leak = -70;
NeuronParams(1).dendritesID=2;
NeuronParams(1).Input(1).inputType = 'i_ou';
NeuronParams(1).Input(1).meanInput = 330;
NeuronParams(1).Input(1).stdInput = 90;
NeuronParams(1).Input(1).tau = 2;

%Cell population 2
NeuronParams(2).modelProportion = 0.50;
NeuronParams(2).somaLayer = 1;
NeuronParams(2).neuronModel='adex';
NeuronParams(2).V_t = -50;
NeuronParams(2).delta_t = 2;
NeuronParams(2).a = 0.04;
NeuronParams(2).tau_w = 10;
NeuronParams(2).b = 40;
NeuronParams(2).v_reset = -65;
NeuronParams(2).v_cutoff = -45;
NeuronParams(2).numCompartments = 2;
NeuronParams(2).somaID=1;
NeuronParams(2).compartmentParentArr = [0 1];
NeuronParams(2).compartmentLengthArr = [10 56];
NeuronParams(2).compartmentDiameterArr = ...
  [24 1.93];
NeuronParams(2).compartmentXPositionMat = ...
[   0,    0;
    0,    0];
NeuronParams(2).compartmentYPositionMat = ...
[   0,    0;
    0,    0];
NeuronParams(2).compartmentZPositionMat = ...
[ -10,    0;
    0,   56;];
NeuronParams(2).axisAligned = 'z';
NeuronParams(2).C = 1.0*2.93;
NeuronParams(2).R_M = 15000/2.93;
NeuronParams(2).R_A = 150;
NeuronParams(2).E_leak = -70;
NeuronParams(2).dendritesID=2;
NeuronParams(2).Input(1).inputType = 'i_ou';
NeuronParams(2).Input(1).meanInput = 190;
NeuronParams(2).Input(1).tau = 0.8;
NeuronParams(2).Input(1).stdInput = 50;

ConnectionParams(1).numConnectionsToAllFromOne{1} = 4;
ConnectionParams(1).synapseType{1} = 'i_exp';
ConnectionParams(1).targetCompartments{1} =NeuronParams(1).dendritesID;
ConnectionParams(1).weights{1} = 1;
ConnectionParams(1).tau{1} = 2;
ConnectionParams(1).numConnectionsToAllFromOne{2} = 5;
ConnectionParams(1).synapseType{2} = 'i_exp';
ConnectionParams(1).targetCompartments{2} =NeuronParams(2).dendritesID;
ConnectionParams(1).weights{2} = 28;
ConnectionParams(1).tau{2} = 1;
ConnectionParams(1).axonArborSpatialModel = 'gaussian';
ConnectionParams(1).sliceSynapses = false;
ConnectionParams(1).axonArborRadius = 100;
ConnectionParams(1).axonArborLimit = 200;
ConnectionParams(1).axonConductionSpeed = 0.3;
ConnectionParams(1).synapseReleaseDelay = 0.5;
ConnectionParams(2).numConnectionsToAllFromOne{1} = 5;
ConnectionParams(2).synapseType{1} = 'i_exp';
ConnectionParams(2).targetCompartments{1} = NeuronParams(1).somaID;
ConnectionParams(2).weights{1} = -5;
ConnectionParams(2).tau{1} = 6;
ConnectionParams(2).numConnectionsToAllFromOne{2} = 4;
ConnectionParams(2).synapseType{2} = 'i_exp';
ConnectionParams(2).targetCompartments{2} =NeuronParams(2).dendritesID;
ConnectionParams(2).weights{2} = -4;
ConnectionParams(2).tau{2} = 3;
ConnectionParams(2).axonArborSpatialModel = 'gaussian';
ConnectionParams(2).sliceSynapses = false;
ConnectionParams(2).axonArborRadius = 100;
ConnectionParams(2).axonArborLimit = 200;
ConnectionParams(2).axonConductionSpeed = 0.3;
ConnectionParams(2).synapseReleaseDelay = 0.5;
RecordingSettings.saveDir='results\';
RecordingSettings.LFP=false;
RecordingSettings.v_m = 1:1:10;
RecordingSettings.maxRecTime = 100;
RecordingSettings.sampleRate = 1000;
SimulationSettings.simulationTime = 200;
SimulationSettings.timeStep = 0.03125;
SimulationSettings.parallelSim = false;
% initialize 
[params, connections, electrodes] =initNetwork(TissueParams, NeuronParams,ConnectionParams,RecordingSettings, SimulationSettings);
% run simulation
runSimulation(params,connections,electrodes);

% Visualize results
Results=loadResults(RecordingSettings.saveDir);
subplot(1,2,1)
plot(Results.spikes(:, 2), Results.spikes(:, 1), 'k.')
axis([0 200 0 15])
set(gcf,'color','w');
set(gca,'YDir','reverse');
set(gca,'FontSize',16)
title('Spike raster', 'FontSize', 16)
xlabel('Time (ms)', 'FontSize', 16)
ylabel('Neuron ID', 'FontSize', 16)
subplot(1,2,2)
plot(Results.v_m(3, :), 'LineWidth', 2) 
set(gcf,'color','w');
set(gca,'FontSize',16)
title('Membrane potential for neuron ID=3', 'FontSize', 16)
xlabel('Time (ms)', 'FontSize', 16)
ylabel('Membrane potential (mV)', 'FontSize', 16)
% create txt files containing cell positions and cellconnectivity
cellpositions(params,RecordingSettings.saveDir,'Adex2pop_2comp_cellpositions'); 
cellpositions_tags(params,RecordingSettings.saveDir,'Adex2pop_2comp_cellpositions_tags');
[ID_Matrix, group_boundaries]=cellconnectivity(connections,params,'all',RecordingSettings.saveDir,'Adex2pop_2comp_cellconnectivity');
cellconnectivity_tags(params,ID_Matrix,group_boundaries,RecordingSettings.saveDir,'Adex2pop_2comp_cellconnectivity_tags');