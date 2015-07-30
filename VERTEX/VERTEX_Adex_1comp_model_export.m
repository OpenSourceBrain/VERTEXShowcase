function Adex_parameters=VERTEX_Adex_1comp_model_export(VERTEX_params)


if isstruct(VERTEX_params)==1
    Tissue_params=VERTEX_params.TissueParams;
    Neuron_params=VERTEX_params.NeuronParams;
end

if iscell(VERTEX_params)==1
    Tissue_params=VERTEX_params{1};
    Neuron_params=VERTEX_params{2};
end
Adex_parameters=cell(Tissue_params.numGroups,10); % each row represents a distinct cell group; 
% the columns represent Adex parameters in the following order: C (pF), gL (nS), EL (mV), 
% reset (mV), VT (mV), delT (mV), tauw(ms),  a (nS),   b (nA),
% v_cutoff (mV); in total - 10 parameters.
for i=1:Tissue_params.numGroups
    if isfield(Neuron_params(i),'C_m')==1
        if isempty(Neuron_params(i).C_m)~=1
            Adex_parameters{i,1}=Neuron_params(i).C_m;
        end   
    else
        if isfield(Neuron_params(i),'C')==1
            if isempty(Neuron_params(i).C)~=1
                if isempty(Neuron_params(i).compartmentLengthArr)~=1 && isempty(Neuron_params(i).compartmentDiameterArr)~=1
                    Adex_parameters{i,1}=Neuron_params(i).C*pi*Neuron_params(i).compartmentDiameterArr*Neuron_params(i).compartmentLengthArr*10^-8*10^6;
                    % as expected for LEMS, in picoFarads.
                end
                
            end
        end
    end    
    
    if isfield(Neuron_params(i),'g_l')==1
        if isempty(Neuron_params(i).g_l)~=1
            Adex_parameters{i,2}=Neuron_params(i).g_l;
        end
    else
        if isfield(Neuron_params(i),'R_M')==1    
            if isempty(Neuron_params(i).R_M)~=1
                if isempty(Neuron_params(i).compartmentLengthArr)~=1 && isempty(Neuron_params(i).compartmentDiameterArr)~=1
                    Adex_parameters{i,2}=((10^9)*((Neuron_params(i).R_M))^(-1))*(pi*(Neuron_params(i).compartmentDiameterArr)*(Neuron_params(i).compartmentLengthArr)*10^-8);
                    % as expected for LEMS, in nanoSiemens.
                end
                
            end
        end
    end
        
        
    
    Adex_parameters{i,3}=Neuron_params(i).E_leak;
    Adex_parameters{i,4}=Neuron_params(i).v_reset;
    Adex_parameters{i,5}=Neuron_params(i).V_t;
    Adex_parameters{i,6}=Neuron_params(i).delta_t;
    Adex_parameters{i,7}=Neuron_params(i).tau_w;
    Adex_parameters{i,8}=Neuron_params(i).a;
    Adex_parameters{i,9}=Neuron_params(i).b*10^-3;
    Adex_parameters{i,10}=Neuron_params(i).v_cutoff;
    
    
    
    
    
    
    
    
    
    
end