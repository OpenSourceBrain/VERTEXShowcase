function [synapse_types_per_projection, synapse_weights_per_projection...
      ,synapse_tau_per_projection,varargout]=synapse_parameters_export(VERTEX_params)
  % synapse_parameters_export() receives matlab structure or cell array
  % VERTEX_params and generates four outputs: a cell array of synapse types,
  % a matrix of synapse weights (pA for current-based, nS for conductance-based, 
  % a matrix of time constant values and a matrix of E_reversal, the latter being
  % returned only if conductance-based synapse has been specified. 
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




varargout{1}=cell(Tissue_Params.numGroups,Tissue_Params.numGroups);
 
  
       


synapse_types_per_projection=cell(Tissue_Params.numGroups,Tissue_Params.numGroups);
synapse_weights_per_projection=cell(Tissue_Params.numGroups,Tissue_Params.numGroups);
synapse_tau_per_projection=cell(Tissue_Params.numGroups,Tissue_Params.numGroups);

for i=1:Tissue_Params.numGroups
    
    
    for j=1:Tissue_Params.numGroups
       
        synapse_types_per_projection{i,j}=Connection_Params(i).synapseType{j};
        synapse_weights_per_projection{i,j}=Connection_Params(i).weights{j};
        synapse_tau_per_projection{i,j}=Connection_Params(i).tau{j};
        if strcmp(Connection_Params(i).synapseType{j},'g_exp')==1
        varargout{1}{i,j}=Connection_Params(i).E_reversal{j};
        end
    
    end
    
end





