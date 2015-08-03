TissueParams.X=1000; % dimensions of the soma layer of the model (X,Y,Z) in micro m
                      % and neuronDensity in neurons per cubic mm
TissueParams.Y=1000;  % are chosen so that total number of neurons in 
TissueParams.Z=1000;  % the model is 3.
TissueParams.neuronDensity=3;
TissueParams.numLayers=1;
TissueParams.layerBoundaryArr=[1000, 0]; 
TissueParams.numStrips=1;
TissueParams.maxZOverlap=[-1, -1];

% Cell population 1
NeuronParams(1).modelProportion = 0.33;
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
NeuronParams(1).Input(1).amplitude=80; % pA
NeuronParams(1).Input(1).timeOn=50;
NeuronParams(1).Input(1).timeOff=400;
NeuronParams(1).Input(1).inputType='i_step';

%Cell population 2
NeuronParams(2).modelProportion = 0.33;
NeuronParams(2).somaLayer = 1;
NeuronParams(2).neuronModel='adex';
NeuronParams(2).V_t = -50;
NeuronParams(2).delta_t = 2;
NeuronParams(2).a = 1.0;
NeuronParams(2).tau_w = 10;
NeuronParams(2).b = 100;
NeuronParams(2).v_reset = -65;
NeuronParams(2).v_cutoff = -45;
NeuronParams(2).numCompartments = 1;
NeuronParams(2).somaID=1;
NeuronParams(2).compartmentLengthArr= 10;
NeuronParams(2).compartmentDiameterArr=24;
NeuronParams(2).C = 1.0*2.93;
NeuronParams(2).R_M = 15000/2.93;
NeuronParams(2).E_leak = -72;
NeuronParams(2).Input(1).amplitude=0; 
NeuronParams(2).Input(1).timeOn=50;
NeuronParams(2).Input(1).timeOff=400;
NeuronParams(2).Input(1).inputType='i_step';

% Cell population 3
NeuronParams(3).modelProportion = 0.33;
NeuronParams(3).axisAligned = 'z';
NeuronParams(3).neuronModel = 'adex';
NeuronParams(3).somaLayer = 1;
NeuronParams(3).somaID=1;
NeuronParams(3).V_t = -52;
NeuronParams(3).delta_t = 2;
NeuronParams(3).a = 10;
NeuronParams(3).tau_w = 75;
NeuronParams(3).b = 345;
NeuronParams(3).v_reset = -60;
NeuronParams(3).v_cutoff = -47;
NeuronParams(3).numCompartments = 1;
NeuronParams(3).compartmentLengthArr = 35;
NeuronParams(3).compartmentDiameterArr = 25;
NeuronParams(3).C = 1.0*2.95;
NeuronParams(3).R_M = 20000/2.95;
NeuronParams(3).R_A = 150;
NeuronParams(3).E_leak = -70;
NeuronParams(3).Input(1).amplitude=0;
NeuronParams(3).Input(1).timeOn=50;
NeuronParams(3).Input(1).timeOff=400;
NeuronParams(3).Input(1).inputType='i_step';


%Connections
ConnectionParams(1).numConnectionsToAllFromOne ={0,1,1}; 
ConnectionParams(1).targetCompartments={NeuronParams(1).somaID, NeuronParams(2).somaID, NeuronParams(3).somaID};
ConnectionParams(1).synapseType ={'g_exp','g_exp','g_exp'}; 
ConnectionParams(1).weights ={10,10,10}; % for current-based - in pA, for conductance-based - in nS.
ConnectionParams(1).tau ={2,2,2};
ConnectionParams(1).E_reversal={0,0,0};

ConnectionParams(1).axonArborSpatialModel = 'gaussian';
ConnectionParams(1).sliceSynapses = false;
ConnectionParams(1).axonArborRadius = 100;
ConnectionParams(1).axonArborLimit = 200;
ConnectionParams(1).axonConductionSpeed = 0.3;
ConnectionParams(1).synapseReleaseDelay = 0.5;



ConnectionParams(2).numConnectionsToAllFromOne ={0,0,0};
ConnectionParams(2).synapseType ={ 'g_exp','g_exp','g_exp'};
ConnectionParams(2).targetCompartments ={NeuronParams(1).somaID, NeuronParams(2).somaID,NeuronParams(3).somaID};
ConnectionParams(2).weights ={5,4,5};
ConnectionParams(2).tau ={6,3,6};
ConnectionParams(2).E_reversal={-75,-75,-75};

ConnectionParams(2).axonArborSpatialModel = 'gaussian';
ConnectionParams(2).sliceSynapses = false;
ConnectionParams(2).axonArborRadius = 100;
ConnectionParams(2).axonArborLimit = 200;
ConnectionParams(2).axonConductionSpeed = 0.3;
ConnectionParams(2).synapseReleaseDelay = 0.5;

ConnectionParams(3).numConnectionsToAllFromOne ={0,0,0};
ConnectionParams(3).synapseType ={'g_exp','g_exp','g_exp'};
ConnectionParams(3).targetCompartments ={NeuronParams(1).somaID, NeuronParams(2).somaID, NeuronParams(3).somaID};
ConnectionParams(3).weights ={3,3,3};
ConnectionParams(3).tau ={6,6,6};
ConnectionParams(3).E_reversal={-75,-75,-75};

ConnectionParams(3).axonArborSpatialModel = 'gaussian';
ConnectionParams(3).sliceSynapses = false;
ConnectionParams(3).axonArborRadius = 100;
ConnectionParams(3).axonArborLimit = 200;
ConnectionParams(3).axonConductionSpeed = 0.3;
ConnectionParams(3).synapseReleaseDelay = 0.5;

RecordingSettings.saveDir=['Adex2pop_1comp_test4', filesep];
RecordingSettings.LFP=false;
RecordingSettings.v_m = 1:3;
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
cells_to_display={0,0,0};
model_path=which('VERTEX_Adex_LEMS.xml');
VERTEX_Adex_1comp_to_LEMS(params,connections,0.01,model_path,['..' filesep '..' filesep 'test_LEMS' filesep],'Adex2pop_1comp_test4',cells_to_display);
% load Results which later will be visualized
Results=loadResults(RecordingSettings.saveDir);

plot(Results.v_m(1, :), 'LineWidth', 2,'Color','b') 
hold on
plot(Results.v_m(2,:),'LineWidth',2,'Color','r')
hold on 
plot(Results.v_m(3,:),'LineWidth',2,'Color','m');
set(gcf,'color','w');
set(gca,'FontSize',16)
title('Membrane potential traces of two Adex point neurons', 'FontSize', 16)
xlabel('Time (ms)', 'FontSize', 16)
ylabel('Membrane potential (mV)', 'FontSize', 16)


% run LEMS model through the command line using jNeuroML

