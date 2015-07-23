TissueParams.X=1000; % dimensions of the soma layer of the model (X,Y,Z) in micro m
                      % and neuronDensity in neurons per cubic mm
TissueParams.Y=1000;  % are chosen so that total number of neurons in 
TissueParams.Z=1000;  % the model is 1.
TissueParams.neuronDensity=1;
TissueParams.numLayers=1;
TissueParams.layerBoundaryArr=[1000, 0]; 
TissueParams.numStrips=1;
TissueParams.maxZOverlap=[-1, -1];


NeuronParams(1).modelProportion = 1;
NeuronParams(1).somaLayer = 1;
NeuronParams(1).neuronModel='adex';
NeuronParams(1).V_t = -50;
NeuronParams(1).delta_t = 2;
NeuronParams(1).a = 2.6; %nS
NeuronParams(1).tau_w = 50;
NeuronParams(1).b = 200; %pA
NeuronParams(1).v_reset = -70;
NeuronParams(1).v_cutoff = -45; % the membrane potential at which a spike is detected. 
% VERTEX documentation recommends to set v_cutoff to V_t+5; see http://vertexsimulator.org/tutorial-2/
NeuronParams(1).numCompartments=1;
NeuronParams(1).somaID=1;
%NeuronParams(1).compartmentLengthArr = 13;
%NeuronParams(1).compartmentDiameterArr = 29.8;
% compartment lengthArr and compartment Diameter Arr are only needed if
% specific membrane capacitance, C, and specific membrane resistance, R_M,
% are specified; this is because compartment length and diameter will be
% later used by the VERTEX script to calculate membrane capacitance (C_m) in
% picoFarads and g_l in nanoSiemens. Below derived C_m and g_l are given.
NeuronParams(1).axisAligned = 'z';
NeuronParams(1).C_m = 2.96*pi*13*29.8*10^-8*10^6;   %picoFarads
NeuronParams(1).g_l =(10^9)/((20000/2.96)/(pi*13*29.8*10^-8));%nanoSiemens.
%NeuronParams(1).C=2.96;
%NeuronParams(1).R_M=20000/2.96;
NeuronParams(1).E_leak = -70;
NeuronParams(1).Input(1).amplitude=100; % pA
NeuronParams(1).Input(1).timeOn=50;
NeuronParams(1).Input(1).timeOff=400;
NeuronParams(1).Input(1).inputType='i_step';
ConnectionParams(1).numConnectionsToAllFromOne{1} = 0; % although no connections, VERTEX requires to specify the parameters below,
ConnectionParams(1).targetCompartments{1}=NeuronParams(1).somaID;
ConnectionParams(1).synapseType{1} = 'g_exp'; % otherwise error messages are generated.
ConnectionParams(1).weights{1} = 10; % for current-based - in pA, for conductance-based - in nS.
ConnectionParams(1).tau{1} = 2;
ConnectionParams(1).E_reversal{1}=0;
ConnectionParams(1).axonArborSpatialModel = 'gaussian';
ConnectionParams(1).sliceSynapses = false;
ConnectionParams(1).axonArborRadius = 100;
ConnectionParams(1).axonArborLimit = 200;
ConnectionParams(1).axonConductionSpeed = 0.3;
ConnectionParams(1).synapseReleaseDelay = 0.5;


RecordingSettings.saveDir='Adex_1comp_results_test2/'; % change this for other simulations
RecordingSettings.LFP=false;
RecordingSettings.v_m = 1;
RecordingSettings.maxRecTime = 100;
RecordingSettings.sampleRate = 1000;
SimulationSettings.simulationTime = 500;
SimulationSettings.timeStep = 0.03125;
SimulationSettings.parallelSim = false;
% initialize 
[params, connections, electrodes] =initNetwork(TissueParams, NeuronParams,ConnectionParams,RecordingSettings, SimulationSettings);
% run simulation
runSimulation(params,connections,electrodes);

% conversion to LEMS
cells_to_display={0};
VERTEX_Adex_1comp_to_LEMS(params,'~\VERTEXShowcase\test_LEMS\VERTEX_Adex_LEMS.xml',RecordingSettings.saveDir,'Adex_1comp_stepI_test2',cells_to_display);
% load Results which later will be visualized
Results=loadResults(RecordingSettings.saveDir);
% run LEMS model through the command line using jNeuroML