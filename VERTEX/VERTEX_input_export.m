function Input_parameters=VERTEX_input_export(VERTEX_params)

if isstruct(VERTEX_params)==1
    Neuron_params=VERTEX_params.NeuronParams;
    
end

if iscell(VERTEX_params)==1
    Neuron_params=VERTEX_params{2};
    
end
Input_parameters=cell(1,length(Neuron_params));
for i=1:length(Neuron_params)
    if length(Neuron_params(i).Input)==1 % currently made to support only one type of input to the given cell group.
        if strcmp(Neuron_params(i).Input(1).inputType,'i_step')==1
            %currently supports only step current inputs
            Input_parameters{1,i}=cell(1,4);
            Input_parameters{1,i}{1,1}=Neuron_params(i).Input(1).inputType;
            Input_parameters{1,i}{1,2}=Neuron_params(i).Input(1).amplitude*10^-3;
            Input_parameters{1,i}{1,3}=Neuron_params(i).Input(1).timeOn;
            Input_parameters{1,i}{1,4}=Neuron_params(i).Input(1).timeOff;
            
            
        end
    end
        % the code later can be expanded to include other types of input.
    
end



end