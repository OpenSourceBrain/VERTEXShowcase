function [synapse_types_per_projection, synapse_weights_per_projection...
      ,synapse_tau_per_projection,varargout]=synapse_parameters_export(VERTEX_params,varargin)
  % synapse_parameters_export() receives matlab structure or cell array
  % VERTEX_params and generates four outputs: a cell array of synapse types,
  % a matrix of synapse weights (pA for current-based, nS for conductance-based, 
  % a matrix of time constant values and a matrix of E_reversal, the latter being
  % returned only if conductance-based synapse is being specified. 
  % An element ij of each output array represents a parameter value for each
  % distinct projection, where i is the row index for the presynaptic population
  % and j is the column index for the postsynaptic population.

if isstruct(VERTEX_params)==1
    Connection_Params=VERTEX_params.ConnectionParams;
    Tissue_Params=VERTEX_params.TissueParams;
end

if iscell(VERTEX_params)==1
    Connection_Params=VERTEX_params{3};
    Tissue_Params=VERTEX_params{1};
end
synapses=[Connection_Params.synapseType];
time_constants=[Connection_Params.tau];
synapse_weights=[Connection_Params.weights];
if strcmp(unique(synapses),'g_exp')==1
    E_reversal_potentials=[Connection_Params.E_reversal];
    varargout{1}=zeros(Tissue_Params.numGroups,Tissue_Params.numGroups);
end
synapse_types_per_projection=cell(Tissue_Params.numGroups,Tissue_Params.numGroups);
synapse_weights_per_projection=zeros(Tissue_Params.numGroups,Tissue_Params.numGroups);
synapse_tau_per_projection=zeros(Tissue_Params.numGroups,Tissue_Params.numGroups);
start=1;
end_=Tissue_Params.numGroups;
for i=1:Tissue_Params.numGroups
    a=synapses(start:end_);
    b=time_constants(start:end_);
    c=synapse_weights(start:end_);
    if strcmp(unique(synapses),'g_exp')==1
    d=E_reversal_potentials(start:end_);
    end
    for j=1:Tissue_Params.numGroups
       
        synapse_types_per_projection{i,j}=a{j};
        synapse_weights_per_projection(i,j)=c{j};
        synapse_tau_per_projection(i,j)=b{j};
        if strcmp(unique(synapses),'g_exp')==1
        varargout{1}(i,j)=d{j};
        end
    
    end
    if i~=Tissue_Params.numGroups
    start=end_+1;
    end_=end_+2;
    end
end





