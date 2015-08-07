function Izhikevich_parameters=VERTEX_IzhikevichCell_model_export(VERTEX_params)


if isstruct(VERTEX_params)==1
    Tissue_params=VERTEX_params.TissueParams;
    Neuron_params=VERTEX_params.NeuronParams;
end

if iscell(VERTEX_params)==1
    Tissue_params=VERTEX_params{1};
    Neuron_params=VERTEX_params{2};
end
Izhikevich_parameters=cell(Tissue_params.numGroups,6);

for i=1:Tissue_params.numGroups
    
    
    Izhikevich_parameters{i,1}=Neuron_params(i).v0;
    Izhikevich_parameters{i,2}=Neuron_params(i).thresh;
    Izhikevich_parameters{i,3}=Neuron_params(i).a;
    Izhikevich_parameters{i,4}=Neuron_params(i).b;
    Izhikevich_parameters{i,5}=Neuron_params(i).c;
    Izhikevich_parameters{i,6}=Neuron_params(i).d;
    
    
    
    
    
    
    
    
    
    
    
end