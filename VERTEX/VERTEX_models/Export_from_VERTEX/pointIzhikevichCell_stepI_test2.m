TissueParams.X=1000; % dimensions of the soma layer of the model (X,Y,Z) in micro m
                      % and neuronDensity in neurons per cubic mm
TissueParams.Y=1000;  % are chosen so that total number of neurons in 
TissueParams.Z=1000;  % the model is 1.
TissueParams.neuronDensity=2;
TissueParams.numLayers=1;
TissueParams.layerBoundaryArr=[1000, 0]; 
TissueParams.numStrips=1;
TissueParams.maxZOverlap=[-1, -1];


NeuronParams(1).modelProportion = 0.5;
NeuronParams(1).somaLayer = 1;
NeuronParams(1).neuronModel='izhikevichCell';
NeuronParams(1).v0 = -70;
NeuronParams(1).thresh = 30;
NeuronParams(1).a = 0.02;
NeuronParams(1).b = 0.2;
NeuronParams(1).c = -50;
NeuronParams(1).d = 2;
NeuronParams(1).numCompartments=1;
NeuronParams(1).somaID=1;
NeuronParams(1).axisAligned = 'z';
NeuronParams(1).Input(1).amplitude=15; 
NeuronParams(1).Input(1).timeOn=20;
NeuronParams(1).Input(1).timeOff=200;
NeuronParams(1).Input(1).inputType='i_step';

NeuronParams(2).modelProportion = 0.5;
NeuronParams(2).somaLayer = 1;
NeuronParams(2).neuronModel='izhikevichCell';
NeuronParams(2).v0 = -70;
NeuronParams(2).thresh = 30;
NeuronParams(2).a = 0.02;
NeuronParams(2).b = 0.2;
NeuronParams(2).c = -55;
NeuronParams(2).d = 4;
NeuronParams(2).numCompartments=1;
NeuronParams(2).somaID=1;
NeuronParams(2).axisAligned = 'z';
NeuronParams(2).Input(1).amplitude=0; 
NeuronParams(2).Input(1).timeOn=20;
NeuronParams(2).Input(1).timeOff=200;
NeuronParams(2).Input(1).inputType='i_step';


ConnectionParams(1).numConnectionsToAllFromOne{1} = 0; % although no connections, VERTEX requires to specify the parameters below,
ConnectionParams(1).targetCompartments{1}=NeuronParams(1).somaID;
ConnectionParams(1).synapseType{1} = 'g_exp'; % otherwise error messages are generated.
ConnectionParams(1).weights{1} = 10; % for current-based - in pA, for conductance-based - in nS.
ConnectionParams(1).tau{1} = 2;
ConnectionParams(1).E_reversal{1}=0;
ConnectionParams(1).numConnectionsToAllFromOne{2} = 1;
ConnectionParams(1).synapseType{2} = 'g_exp';
ConnectionParams(1).targetCompartments{2} =NeuronParams(2).somaID;
ConnectionParams(1).weights{2} = 3;
ConnectionParams(1).tau{2} = 1;
ConnectionParams(1).E_reversal{2}=0;
ConnectionParams(1).axonArborSpatialModel = 'gaussian';
ConnectionParams(1).sliceSynapses = false;
ConnectionParams(1).axonArborRadius = 100;
ConnectionParams(1).axonArborLimit = 200;
ConnectionParams(1).axonConductionSpeed = 0.3;
ConnectionParams(1).synapseReleaseDelay = 0.5;

ConnectionParams(2).numConnectionsToAllFromOne{1} = 0;
ConnectionParams(2).synapseType{1} = 'g_exp';
ConnectionParams(2).targetCompartments{1} = NeuronParams(1).somaID;
ConnectionParams(2).weights{1} = -5;
ConnectionParams(2).tau{1} = 6;
ConnectionParams(2).E_reversal{1}=-75;
ConnectionParams(2).numConnectionsToAllFromOne{2} = 0;
ConnectionParams(2).synapseType{2} = 'g_exp';
ConnectionParams(2).targetCompartments{2} =NeuronParams(2).somaID;
ConnectionParams(2).weights{2} = -4;
ConnectionParams(2).tau{2} = 3;
ConnectionParams(2).E_reversal{2}=-75;
ConnectionParams(2).axonArborSpatialModel = 'gaussian';
ConnectionParams(2).sliceSynapses = false;
ConnectionParams(2).axonArborRadius = 100;
ConnectionParams(2).axonArborLimit = 200;
ConnectionParams(2).axonConductionSpeed = 0.3;
ConnectionParams(2).synapseReleaseDelay = 0.5;



RecordingSettings.saveDir=['pointIzhikevichCell_stepI_test2', filesep];
RecordingSettings.LFP=false;
RecordingSettings.v_m = 1:2;
RecordingSettings.maxRecTime = 100;
RecordingSettings.sampleRate = 1000;
SimulationSettings.simulationTime = 300;
SimulationSettings.timeStep = 0.03125;
SimulationSettings.parallelSim = false;
% initialize 
[params, connections, electrodes] =initNetwork(TissueParams, NeuronParams,ConnectionParams,RecordingSettings, SimulationSettings);
% run simulation
runSimulation(params,connections,electrodes);

% conversion to LEMS
cells_to_display={0,0};
VERTEX_IzhikevichCell_to_LEMS(params,connections,0.01,['..' filesep '..' filesep 'test_LEMS' filesep],'pointIzhikevichCell_stepI_test2',cells_to_display);

% load Results which later will be visualized
Results=loadResults(RecordingSettings.saveDir);
subplot(1,2,1)
plot(Results.spikes(:, 2), Results.spikes(:, 1), 'k.')
axis([0 500 0 5])
set(gcf,'color','w');
set(gca,'YDir','reverse');
set(gca,'FontSize',16)
title('Spike raster', 'FontSize', 16)
xlabel('Time (ms)', 'FontSize', 16)
ylabel('Neuron ID', 'FontSize', 16)
subplot(1,2,2)
plot(Results.v_m(1, :), 'LineWidth', 2,'Color','b') 
hold on
plot(Results.v_m(2,:),'LineWidth',2,'Color','r')
set(gcf,'color','w');
set(gca,'FontSize',16)
title('Membrane potential for the Izhikevich neuron', 'FontSize', 16)
xlabel('Time (ms)', 'FontSize', 16)
ylabel('Membrane potential (mV)', 'FontSize', 16)
% run LEMS model through the command line using jNeuroML