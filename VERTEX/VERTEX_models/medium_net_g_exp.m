TissueParams.X = 2000;
TissueParams.Y = 400;
TissueParams.Z = 650;
TissueParams.neuronDensity = 200;
TissueParams.numStrips = 50;
TissueParams.tissueConductivity = 0.3;
TissueParams.maxZOverlap = [-1 , -1];
TissueParams.numLayers = 3;
TissueParams.layerBoundaryArr = [650, 450, 150, 0];
NeuronParams(1).somaLayer = 1; % Pyramidal cells in layer 3
NeuronParams(1).modelProportion = 0.4;
NeuronParams(1).neuronModel = 'adex';
NeuronParams(1).V_t = -50;
NeuronParams(1).delta_t = 2;
NeuronParams(1).a = 2.6;
NeuronParams(1).tau_w = 65;
NeuronParams(1).b = 220;
NeuronParams(1).v_reset = -60;
NeuronParams(1).v_cutoff = -45;
NeuronParams(1).numCompartments = 8;
NeuronParams(1).compartmentParentArr = [0, 1, 2, 2, 4, 1, 6, 6];
NeuronParams(1).compartmentLengthArr = [13 48 124 145 137 40 143 143];
NeuronParams(1).compartmentDiameterArr = ...
  [29.8, 3.75, 1.91, 2.81, 2.69, 2.62, 1.69, 1.69];
NeuronParams(1).compartmentXPositionMat = ...
[   0,    0;
    0,    0;
    0,  124;
    0,    0;
    0,    0;
    0,    0;
    0, -139;
    0,  139];
NeuronParams(1).compartmentYPositionMat = ...
[   0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0];
NeuronParams(1).compartmentZPositionMat = ...
[ -13,    0;
    0,   48;
   48,   48;
   48,  193;
  193,  330;
  -13,  -53;
  -53, -139;
  -53, -139];
NeuronParams(1).axisAligned = 'z';
NeuronParams(1).C = 1.0*2.96;
NeuronParams(1).R_M = 20000/2.96;
NeuronParams(1).R_A = 150;
NeuronParams(1).E_leak = -70;
NeuronParams(1).somaID = 1;
NeuronParams(1).basalID = [6, 7, 8];
NeuronParams(1).apicalID = [2 3 4 5];

NeuronParams(2).somaLayer = 1; % Basket cells in layer 3
NeuronParams(2).modelProportion = 0.08;
NeuronParams(2).axisAligned = '';
NeuronParams(2).neuronModel = 'adex';
NeuronParams(2).V_t = -50;
NeuronParams(2).delta_t = 2;
NeuronParams(2).a = 0.04;
NeuronParams(2).tau_w = 10;
NeuronParams(2).b = 40;
NeuronParams(2).v_reset = -65;
NeuronParams(2).v_cutoff = -45;
NeuronParams(2).numCompartments = 7;
NeuronParams(2).compartmentParentArr = [0 1 2 2 1 5 5];
NeuronParams(2).compartmentLengthArr = [10 56 151 151 56 151 151];
NeuronParams(2).compartmentDiameterArr = ...
  [24 1.93 1.95 1.95 1.93 1.95 1.95];
NeuronParams(2).compartmentXPositionMat = ...
[   0,    0;
    0,    0;
    0,  107;
    0, -107;
    0,    0;
    0, -107;
    0,  107];
NeuronParams(2).compartmentYPositionMat = ...
[   0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0];
NeuronParams(2).compartmentZPositionMat = ...
[ -10,    0;
    0,   56;
   56,  163;
   56,  163;
  -10,  -66;
  -66, -173;
  -66, -173];
NeuronParams(2).C = 1.0*2.93;
NeuronParams(2).R_M = 15000/2.93;
NeuronParams(2).R_A = 150;
NeuronParams(2).E_leak = -70;
NeuronParams(2).dendritesID = [2 3 4 5 6 7];


NeuronParams(3) = NeuronParams(2); % spiny stellates same morphology as basket
NeuronParams(3).somaLayer = 2;     % but in layer 4
NeuronParams(3).modelProportion = 0.3;
NeuronParams(3).V_t = -50;         % and different AdEx parameters
NeuronParams(3).delta_t = 2.2;
NeuronParams(3).a = 0.35;
NeuronParams(3).tau_w = 150;
NeuronParams(3).b = 40;
NeuronParams(3).v_reset = -70;
NeuronParams(3).v_cutoff = -45;

NeuronParams(4) = NeuronParams(2); % basket cells same in every layer
NeuronParams(4).somaLayer = 2;     % these are in layer 4
NeuronParams(4).modelProportion = 0.1;

NeuronParams(5).somaLayer = 3; % Pyramidal cells in layer 5
NeuronParams(5).modelProportion = 0.1;
NeuronParams(5).axisAligned = 'z';
NeuronParams(5).neuronModel = 'adex';
NeuronParams(5).V_t = -52;
NeuronParams(5).delta_t = 2;
NeuronParams(5).a = 10;
NeuronParams(5).tau_w = 75;
NeuronParams(5).b = 345;
NeuronParams(5).v_reset = -60;
NeuronParams(5).v_cutoff = -47;
NeuronParams(5).numCompartments = 9;
NeuronParams(5).compartmentParentArr = [0 1 2 2 4 5 1 7 7];
NeuronParams(5).compartmentLengthArr = [35 65 152 398 402 252 52 186 186];
NeuronParams(5).compartmentDiameterArr = ...
  [25 4.36 2.65 4.10 2.25 2.4 5.94 3.45 3.45];
NeuronParams(5).compartmentXPositionMat = ...
[   0,    0;
    0,    0;
    0,  152;
    0,    0;
    0,    0;
    0,    0;
    0,    0;
    0, -193;
    0,  193];
NeuronParams(5).compartmentYPositionMat = ...
[   0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0];
NeuronParams(5).compartmentZPositionMat = ...
[ -35,    0;
    0,   65;
   65,   65;
   65,  463;
  463,  865;
  865, 1117;
  -35,  -87;
  -87, -193;
  -87, -193];
NeuronParams(5).C = 1.0*2.95;
NeuronParams(5).R_M = 20000/2.95;
NeuronParams(5).R_A = 150;
NeuronParams(5).E_leak = -70;
NeuronParams(5).dendritesID = [2 3 4 5 6 7 8 9];

NeuronParams(6) = NeuronParams(2); % Basket cells in layer 5
NeuronParams(6).somaLayer = 3;
NeuronParams(6).modelProportion = 0.02;
%We will also need to provide the neurons with some input:

NeuronParams(1).Input(1).inputType = 'i_ou';
NeuronParams(1).Input(1).meanInput = 330;
NeuronParams(1).Input(1).stdInput = 80;
NeuronParams(1).Input(1).tau = 2;
NeuronParams(2).Input(1).inputType = 'i_ou';
NeuronParams(2).Input(1).meanInput = 200;
NeuronParams(2).Input(1).stdInput = 20;
NeuronParams(2).Input(1).tau = 1;
NeuronParams(3).Input(1).inputType = 'i_ou';
NeuronParams(3).Input(1).meanInput = 230;
NeuronParams(3).Input(1).stdInput = 30;
NeuronParams(3).Input(1).tau = 2;
NeuronParams(4).Input(1).inputType = 'i_ou';
NeuronParams(4).Input(1).meanInput = 200;
NeuronParams(4).Input(1).stdInput = 20;
NeuronParams(4).Input(1).tau = 1;
NeuronParams(5).Input(1).inputType = 'i_ou';
NeuronParams(5).Input(1).meanInput = 830;
NeuronParams(5).Input(1).stdInput = 160;
NeuronParams(5).Input(1).tau = 2;
NeuronParams(6).Input(1).inputType = 'i_ou';
NeuronParams(6).Input(1).meanInput = 200;
NeuronParams(6).Input(1).stdInput = 20;
NeuronParams(6).Input(1).tau = 1;
ConnectionParams(1).axonArborRadius = [300, 200, 100];
ConnectionParams(1).axonArborLimit = [600, 400, 200];
ConnectionParams(1).numConnectionsToAllFromOne{1} = [1500,    0,    0];
ConnectionParams(1).numConnectionsToAllFromOne{2} = [ 250,    0,    0];
ConnectionParams(1).numConnectionsToAllFromOne{3} = [   0,   50,    0];
ConnectionParams(1).numConnectionsToAllFromOne{4} = [   0,   20,    0];
ConnectionParams(1).numConnectionsToAllFromOne{5} = [  25,    0,  175];
ConnectionParams(1).numConnectionsToAllFromOne{6} = [   0,    0,   25];
ConnectionParams(1).synapseType = ...
  {'g_exp', 'g_exp', 'g_exp', 'g_exp', 'g_exp', 'g_exp'};
ConnectionParams(1).targetCompartments = ...
  {NeuronParams(1).dendritesID, NeuronParams(2).dendritesID, ...
   NeuronParams(3).dendritesID, NeuronParams(4).dendritesID, ...
   NeuronParams(5).dendritesID, NeuronParams(6).dendritesID};
ConnectionParams(1).weights = {2, 30, 1, 15, 1, 15};
ConnectionParams(1).tau = {2, 1, 2, 1, 2, 1};
ConnectionParams(1).E_reversal={0,0,0,0,0,0};

ConnectionParams(1).axonArborSpatialModel = 'gaussian';
ConnectionParams(1).sliceSynapses = true;
ConnectionParams(1).axonConductionSpeed = 0.3;
ConnectionParams(1).synapseReleaseDelay = 0.5;
ConnectionParams(2).axonArborRadius = [150, 0, 0];
ConnectionParams(2).axonArborLimit = [300, 0, 0];
ConnectionParams(2).numConnectionsToAllFromOne = ...
  {[2000, 0, 0], [200, 0, 0], [0, 20, 0], [0, 50, 0], [15, 0, 50], [0, 0, 10]};
ConnectionParams(2).synapseType = ...
  {'g_exp', 'g_exp', 'g_exp', 'g_exp', 'g_exp', 'g_exp'};
ConnectionParams(2).targetCompartments = ...
  {1, NeuronParams(2).dendritesID, ...
   1, NeuronParams(4).dendritesID, ...
   1, NeuronParams(6).dendritesID};
ConnectionParams(2).weights = {4, 4, 4, 4, 4, 4};
ConnectionParams(2).tau = {6, 3, 6, 3, 6, 3};
ConnectionParams(2).E_reversal={-75,-75,-75,-75,-75,-75};
ConnectionParams(2).axonArborSpatialModel = 'gaussian';
ConnectionParams(2).sliceSynapses = true;
ConnectionParams(2).axonConductionSpeed = 0.3;
ConnectionParams(2).synapseReleaseDelay = 0.5;

ConnectionParams(3).axonArborRadius = [200, 300, 200];
ConnectionParams(3).axonArborLimit = [400, 600, 400];
ConnectionParams(3).numConnectionsToAllFromOne = ...
  {[50, 0, 0], [5, 0, 0], [0, 500, 0], [0, 100, 0], [0, 10, 40], [0, 0, 5]};
ConnectionParams(3).synapseType = ...
  {'g_exp', 'g_exp', 'g_exp', 'g_exp', 'g_exp', 'g_exp'};
ConnectionParams(3).targetCompartments = ...
  {NeuronParams(1).dendritesID, NeuronParams(2).dendritesID, ...
   NeuronParams(3).dendritesID, NeuronParams(4).dendritesID, ...
   NeuronParams(5).dendritesID, NeuronParams(6).dendritesID};
ConnectionParams(3).weights = {1, 15, 2, 30, 2, 30};
ConnectionParams(3).tau = {2, 1, 2, 1, 2, 1};
ConnectionParams(3).E_reversal={0,0,0,0,0,0};
ConnectionParams(3).axonArborSpatialModel = 'gaussian';
ConnectionParams(3).sliceSynapses = true;
ConnectionParams(3).axonConductionSpeed = 0.3;
ConnectionParams(3).synapseReleaseDelay = 0.5;

ConnectionParams(4).axonArborRadius = [0, 150, 0];
ConnectionParams(4).axonArborLimit = [0, 300, 0];
ConnectionParams(4).numConnectionsToAllFromOne = ...
  {[100, 0, 0], [10, 0, 0], [0, 450, 0], [0, 150, 0], [0, 10, 15], [0, 0, 5]}; % each row vector
% represents a number of connections made by neuron group i to the neuron group j. Each
% k element in each row vector represents the number of connections made
% per layer (three layers in this model, so three elements in each row
% vector). 
ConnectionParams(4).synapseType = ...
  {'g_exp', 'g_exp', 'g_exp', 'g_exp', 'g_exp', 'g_exp'};
ConnectionParams(4).targetCompartments = ...
  {1, NeuronParams(2).dendritesID, ...
   1, NeuronParams(4).dendritesID, ...
   1, NeuronParams(6).dendritesID};
ConnectionParams(4).weights = {4, 4, 4, 4, 4, 4};
ConnectionParams(4).tau = {6, 3, 6, 3, 6, 3};
ConnectionParams(4).E_reversal={-75,-75,-75,-75,-75,-75};
ConnectionParams(4).axonArborSpatialModel = 'gaussian';
ConnectionParams(4).sliceSynapses = true;
ConnectionParams(4).axonConductionSpeed = 0.3;
ConnectionParams(4).synapseReleaseDelay = 0.5;

ConnectionParams(5).axonArborRadius = [100, 200, 300];
ConnectionParams(5).axonArborLimit = [200, 400, 600];
ConnectionParams(5).numConnectionsToAllFromOne = ...
  {[250, 0, 0], [30, 0, 0], [0, 50, 0], [0, 20, 0], [15, 0, 200], [0, 0, 100]};
ConnectionParams(5).synapseType = ...
  {'g_exp', 'g_exp', 'g_exp', 'g_exp', 'g_exp', 'g_exp'};
ConnectionParams(5).targetCompartments = ...
  {NeuronParams(1).dendritesID, NeuronParams(2).dendritesID, ...
   NeuronParams(3).dendritesID, NeuronParams(4).dendritesID, ...
   NeuronParams(5).dendritesID, NeuronParams(6).dendritesID};
ConnectionParams(5).weights = {1, 15, 1, 15, 2, 30};
ConnectionParams(5).tau = {2, 1, 2, 1, 2, 1};
ConnectionParams(5).E_reversal={0,0,0,0,0,0};
ConnectionParams(5).axonArborSpatialModel = 'gaussian';
ConnectionParams(5).sliceSynapses = true;
ConnectionParams(5).axonConductionSpeed = 0.3;
ConnectionParams(5).synapseReleaseDelay = 0.5;

ConnectionParams(6).axonArborRadius = [0, 0, 150];
ConnectionParams(6).axonArborLimit = [0, 0, 300];
ConnectionParams(6).numConnectionsToAllFromOne = ...
  {[0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 400], [0, 0, 40]};
ConnectionParams(6).synapseType = {[], [], [], [], 'g_exp', 'g_exp'};
ConnectionParams(6).targetCompartments = ...
  {[], [], [], [], NeuronParams(5).dendritesID, NeuronParams(6).dendritesID};
ConnectionParams(6).weights = {[], [], [], [], 3, 3};
ConnectionParams(6).tau = {[], [], [], [], 6, 3};
ConnectionParams(6).E_reversal={[],[],[],[],-75,-75};
ConnectionParams(6).axonArborSpatialModel = 'gaussian';
ConnectionParams(6).sliceSynapses = true;
ConnectionParams(6).axonConductionSpeed = 0.3;
ConnectionParams(6).synapseReleaseDelay = 0.5;
RecordingSettings.saveDir =[ 'medium_net_g_exp' filesep];
RecordingSettings.LFP = true;
[meaX, meaY, meaZ] = meshgrid(0:500:2000, 200, 700:-100:0);
RecordingSettings.meaXpositions = meaX;
RecordingSettings.meaYpositions = meaY;
RecordingSettings.meaZpositions = meaZ;
RecordingSettings.minDistToElectrodeTip = 20;
RecordingSettings.v_m = 17:17:102;
RecordingSettings.maxRecTime = 100;
RecordingSettings.sampleRate = 1000;


SimulationSettings.simulationTime = 200;
SimulationSettings.timeStep = 0.03125;
SimulationSettings.parallelSim = false;
[params, connections, electrodes] = ...
  initNetwork(TissueParams, NeuronParams, ConnectionParams, ...
              RecordingSettings, SimulationSettings);

runSimulation(params, connections, electrodes);
Results = loadResults(RecordingSettings.saveDir);

rasterParams.colors = {'k','m','k','m','k','m'};
rasterParams.groupBoundaryLines = 'c';
rasterParams.title = 'Tutorial 5 Spike Raster';
rasterParams.xlabel = 'Time (ms)';
rasterParams.ylabel = 'Neuron ID';
rasterParams.figureID = 1;
rasterFigureImproved = plotSpikeRaster(Results, rasterParams);

figure(2)
plot(Results.LFP(1,:), 'b', 'LineWidth', 2);
hold on;
plot(Results.LFP(33,:), 'r', 'LineWidth', 2);
set(gcf,'color','w');
set(gca, 'FontSize', 16);
title('Tutorial 5: LFP at top-left & top-right electrodes', 'FontSize', 16)
xlabel('Time (ms)', 'FontSize', 16)
ylabel('LFP (mV)', 'FontSize', 16)

plot(Results.LFP(17,:), 'c', 'LineWidth', 2);
plot(Results.LFP(24,:), 'm', 'LineWidth', 2);
axis([100 500 -0.1 0.1]) 
set(gcf,'color','w');
set(gca, 'FontSize', 16);
title('Tutorial 5: LFP at 4 electrode positions', 'FontSize', 16)
xlabel('Time (ms)', 'FontSize', 16)
ylabel('LFP (mV)', 'FontSize', 16)

firingRates = groupRates(Results, 100, 500);
% export to neuroml
cell_components=cell_morphology(params,{'medium_net_g_exp_pop0','medium_net_g_exp_pop1','medium_net_g_exp_pop2','medium_net_g_exp_pop3','medium_net_g_exp_pop4','medium_net_g_exp_pop5'},'all');
synapse_to_nml(params,'medium_net_g_exp');
cellpositions_cellconnectivity(params,connections,'medium_net_g_exp',cell_components,'medium_net_g_exp');
