function [varargout]=lems_import_to_VERTEX(filename)

root_node=xmlread(which(filename));

get_LEMS=root_node.getElementsByTagName('Lems');

if get_LEMS.getLength~=0

    get_populations=root_node.getElementsByTagName('population');
    
    get_LEMS_children=get_LEMS.item(0).getChildNodes;
    
    no_of_populations=get_populations.getLength;
    
    populations_ids_sizes_components=cell(no_of_populations,3); % the first column contains the id names of distinct cell populations;
    % the second column contains the sizes of these populations.
    population_size_boundaries=zeros(no_of_populations,1);
    population_size_boundaries(1)=0;
    no_of_cells=0;
    for y=0:no_of_populations-1
        
        attributes=get_populations.item(y).getAttributes;
        attributes_length=attributes.getLength;
        for j=0:attributes_length-1
            attribute=attributes.item(j);
            if strcmp(char(attribute.getName),'id')==1
                populations_ids_sizes_components{y+1,1}=char(attribute.getValue);
                continue
            end
            if strcmp(char(attribute.getName),'size')==1
                populations_ids_sizes_components{y+1,2}=str2double(attribute.getValue);
                no_of_cells=no_of_cells+str2double(attribute.getValue);
                if y+1~=1
                    population_size_boundaries(y+1)=str2double(attribute.getValue)+population_size_boundaries(y);
                    continue
                end
            end
            if strcmp(char(attribute.getName),'component')==1
                component_name=char(attribute.getValue);
                populations_ids_sizes_components{y+1,3}=component_name;
            end
        end
        
        
    end
    NeuronParams(no_of_populations)=struct();
    
    for k=1:no_of_populations
        NeuronParams(k).modelProportion=populations_ids_sizes_components{k,2}/no_of_cells;
        NeuronParams(k).somaLayer=1;
        % assume for now one compartment cell models only
        NeuronParams(k).numCompartments=1;
        NeuronParams(k).somaID=1;
        NeuronParams(k).axisAligned = 'z';
    end
    
    counter=0;
    for i=0:get_LEMS_children.getLength-1
        specific_child=get_LEMS_children.item(i);
        specific_child_attributes=specific_child.getAttributes;
        if isempty(specific_child_attributes)==0
            for y=0:specific_child_attributes.getLength-1
                attribute=specific_child_attributes.item(y);
                if strcmp(char(attribute.getName),'id')==1
                    for k=1:no_of_populations
                        if strcmp(char(attribute.getValue),populations_ids_sizes_components{k,3})==1
                            
                            NeuronParams(k).neuronModel=char(specific_child.getNodeName);
                            
                            for l=0:specific_child_attributes.getLength-1
                                attribute_in=specific_child_attributes.item(l);
                                if strcmp(char(attribute_in.getName),'id')~=1
                                    attribute_name=char(attribute_in.getName);
                                    attribute_value=char(attribute_in.getValue);
                                    attribute_value_type=zeros(1,length(attribute_value));
                                    for x=1:length(attribute_value)
                                        character=str2double(attribute_value(x));
                                        attribute_value_type(x)=character;
                                    end
                                    find_isnan=find(isnan(attribute_value_type));
                                    
                                    if find_isnan(1)==1
                                        if numel(find_isnan)>=3
                                            numerical_value=str2double(strtok(attribute_value,attribute_value(find_isnan(3))));
                                        else
                                            numerical_value=str2double(attribute_value);
                                            
                                        end
                                        
                                    else
                                        if numel(find_isnan)>=2
                                            numerical_value=str2double(strtok(attribute_value,attribute_value(find_isnan(2))));
                                        else
                                            numerical_value=str2double(attribute_value);
                                        end
                                    end
                                    
                                    
                                    NeuronParams(k).(matlab.lang.makeValidName(attribute_name))=numerical_value;
                                    
                                end
                            end
                            counter=counter+1;
                            break
                        end
                    end
                    break
                end
                
                
            end
        end
        if counter==no_of_populations
            
            break
        end
    end
    
    
    % the following block is for the extraction of cell connectivity information
    connections=cell(no_of_cells,3);
    
    for y=1:no_of_cells
        
        for j=1:3
            
            connections{y,j}=[];
            if j==1 % later decide how to take into account simulation time and convert the second column to time steps in uint16
                connections{y,j}=uint16(connections{y,j});
            end
            if j==2
                connections{y,j}=uint8(connections{y,j});
                
            end
        end
        
    end
    
    
    
    get_synapticConnection=root_node.getElementsByTagName('synapticConnection');
    
    get_synapticConnectionWD=root_node.getElementsByTagName('synapticConnectionWD');
    
    no_of_synapticConnection=get_synapticConnection.getLength;
    
    no_of_synapticConnectionWD=get_synapticConnectionWD.getLength;
    
    get_expOneSynapse=root_node.getElementsByTagName('expOneSynapse');
    synapse_array=cell(get_expOneSynapse.getLength,5);
    if get_expOneSynapse.getLength~=0
        for i=0:get_expOneSynapse.getLength-1
            synapse_array{i+1,5}='g_exp';
            attributes=get_expOneSynapse.item(i).getAttributes;
            attributes_length=attributes.getLength;
            for l=0:attributes_length-1
                attribute=attributes.item(l);
                if strcmp(char(attribute.getName),'id')==1
                    get_string=char(attribute.getValue);
                    synapse_array{i+1,1}=get_string;
                    continue
                end
                if strcmp(char(attribute.getName),'erev')==1
                    get_string=char(attribute.getValue);
                    synapse_array{i+1,2}=str2double(strtok(get_string,'m'));
                    continue
                end
                if strcmp(char(attribute.getName),'gbase')==1
                    get_string=char(attribute.getValue);
                    synapse_array{i+1,3}=str2double(strtok(get_string,'n'));
                    continue
                    
                end
                if strcmp(char(attribute.getName),'tauDecay')==1
                    get_string=char(attribute.getValue);
                    synapse_array{i+1,4}=str2double(strtok(get_string,'m'));
                end
                
            end
            
        end
        
        
    end
    
    
    ConnectionParams(no_of_populations)=struct();
    
    for y=1:no_of_populations
        ConnectionParams(y).numConnectionsToAllFromOne =num2cell(zeros(1,no_of_populations));
        ConnectionParams(y).targetCompartments=num2cell(ones(1,no_of_populations));
        ConnectionParams(y).synapseType =cell(1,no_of_populations);
        ConnectionParams(y).weights =cell(1,no_of_populations);
        ConnectionParams(y).tau =cell(1,no_of_populations);
        ConnectionParams(y).E_reversal=cell(1,no_of_populations);
        ConnectionParams(y).axonArborSpatialModel = 'uniform';
        ConnectionParams(y).sliceSynapses = false;
        ConnectionParams(y).axonArborRadius = 100; % set the same value for all populations for now.
        ConnectionParams(y).axonConductionSpeed = Inf;
        ConnectionParams(y).synapseReleaseDelay = 0;
        
        
    end
    counters_for_post_cells=ones(no_of_cells,1);
    if no_of_synapticConnection~=0
        
        
        for y=0:no_of_synapticConnection-1
            attributes=get_synapticConnection.item(y).getAttributes;
            attributes_length=attributes.getLength;
            for j=0:attributes_length-1
                attribute=attributes.item(j);
                if strcmp(char(attribute.getName),'from')==1
                    get_string=char(attribute.getValue);
                    for k=1:no_of_populations
                        if isempty(strfind(get_string,populations_ids_sizes_components{k,1}))==0
                            [~,pre_cellID]=strtok(get_string,'[');
                            pre_cellID=pre_cellID(2:end-1);
                            pre_cellID=str2double(pre_cellID)+1;
                            pre_pop_size=population_size_boundaries(k);
                            pre_pop_Index=k;
                            break
                        end
                    end
                    break
                    
                end
                
            end
            
            for j=0:attributes_length-1
                attribute=attributes.item(j);
                if strcmp(char(attribute.getName),'to')==1
                    get_to_string=char(attribute.getValue);
                    for k=1:no_of_populations
                        if isempty(strfind(get_to_string,populations_ids_sizes_components{k,1}))==0
                            [~,post_cellID]=strtok(get_to_string,'[');
                            post_pop_Index=k;
                            post_cellID=post_cellID(2:end-1);
                            post_cellID=str2double(post_cellID)+1;
                            connections{pre_cellID+pre_pop_size,1}(counters_for_post_cells(pre_cellID+pre_pop_size))=post_cellID+population_size_boundaries(k);
                            connections{pre_cellID+pre_pop_size,2}(counters_for_post_cells(pre_cellID+pre_pop_size))=1;
                            counters_for_post_cells(pre_cellID+pre_pop_size)=counters_for_post_cells(pre_cellID+pre_pop_size)+1;
                            ConnectionParams(pre_pop_Index).numConnectionsToAllFromOne{1,k}=ConnectionParams(pre_pop_Index).numConnectionsToAllFromOne{1,k}+1;
                            
                            break
                        end
                    end
                    break
                    
                end
                
            end
            
            for j=0:attributes_length-1
                attribute=attributes.item(j);
                if strcmp(char(attribute.getName),'synapse')==1
                    get_synapse_id=char(attribute.getValue);
                    for i=1:get_expOneSynapse.getLength
                        if strcmp(get_synapse_id,synapse_array{i,1})==1
                            ConnectionParams(pre_pop_Index).synapseType{1,post_pop_Index}=synapse_array{i,5};
                            ConnectionParams(pre_pop_Index).weights{1,post_pop_Index}=synapse_array{i,3};
                            ConnectionParams(pre_pop_Index).E_reversal{1,post_pop_Index}=synapse_array{i,2};
                            ConnectionParams(pre_pop_Index).tau{1,post_pop_Index}=synapse_array{i,4};
                            break
                        end
                        
                    end
                    break
                end
                
            end
            
            
        end
        
        
        
        
    end
    
    
    if no_of_synapticConnectionWD~=0
        
        for y=0:no_of_synapticConnectionWD-1
            attributes=get_synapticConnectionWD.item(y).getAttributes;
            attributes_length=attributes.getLength;
            for j=0:attributes_length-1
                attribute=attributes.item(j);
                if strcmp(char(attribute.getName),'from')==1
                    get_string=char(attribute.getValue);
                    for k=1:no_of_populations
                        if isempty(strfind(get_string,populations_ids_sizes_components{k,1}))==0
                            [~,pre_cellID]=strtok(get_string,'[');
                            pre_cellID=pre_cellID(2:end-1);
                            pre_cellID=str2double(pre_cellID)+1;
                            pre_pop_size=population_size_boundaries(k);
                            pre_pop_Index=k;
                            break
                        end
                    end
                    break
                    
                end
            end
            for j=0:attributes_length-1
                attribute=attributes.item(j);
                if strcmp(char(attribute.getName),'to')==1
                    get_to_string=char(attribute.getValue);
                    for k=1:no_of_populations
                        if isempty(strfind(get_to_string,populations_ids_sizes_components{k,1}))==0
                            post_pop_Index=k;
                            [~,post_cellID]=strtok(get_string,'[');
                            post_cellID=post_cellID(2:end-1);
                            post_cellID=str2double(post_cellID)+1;
                            connections{pre_cellID+pre_pop_size,1}(counters_for_post_cells(pre_cellID+pre_pop_size))=post_cellID+population_size_boundaries(k);
                            connections{pre_cellID+pre_pop_size,2}(counters_for_post_cells(pre_cellID+pre_pop_size))=1;
                            ConnectionParams(pre_pop_Index).numConnectionsToAllFromOne{1,k}=ConnectionParams(pre_pop_Index).numConnectionsToAllFromOne{1,k}+1;
                            break
                        end
                    end
                    
                end
                
            end
            for j=0:attributes_length-1
                attribute=attributes.item(j);
                if strcmp(char(attribute.getName),'synapse')==1
                    get_synapse_id=char(attribute.getValue);
                    for i=1:get_expOneSynapse.getLength
                        if strcmp(get_synapse_id,synapse_array{i,1})==1
                            ConnectionParams(pre_pop_Index).synapseType{1,post_pop_Index}=synapse_array{i,5};
                            ConnectionParams(pre_pop_Index).weights{1,post_pop_Index}=synapse_array{i,3};
                            ConnectionParams(pre_pop_Index).E_reversal{1,post_pop_Index}=synapse_array{i,2};
                            ConnectionParams(pre_pop_Index).tau{1,post_pop_Index}=synapse_array{i,4};
                            break
                        end
                        
                    end
                    break
                end
            end
            for j=0:attributes_length-1
                attribute=attributes.item(j);
                if strcmp(char(attribute.getName),'delay')==1
                    delay=strtok(char(attribute.getValue),'m');
                    connections{pre_cellID+pre_pop_size,3}(counters_for_post_cells(pre_cellID+pre_pop_size))=str2double(delay);
                    break
                end
                
            end
            counters_for_post_cells(pre_cellID+pre_pop_size)=counters_for_post_cells(pre_cellID+pre_pop_size)+1;
            
        end
        
        
        
    end
    
    
    
    
    list_cell_positions=root_node.getElementsByTagName('location');
    if list_cell_positions.getLength~=0
        Number_of_cells=list_cell_positions.getLength; % generally should be the same as no_of_cells
        %calculated by adding values of attribute "size" from different populations
        
        positions=zeros(Number_of_cells,4);
        
        positions(:,4)=1:Number_of_cells;
        if Number_of_cells==no_of_cells
            for i=0:Number_of_cells-1
                
                attributes=list_cell_positions.item(i).getAttributes;
                attributes_length=attributes.getLength;
                for j=0:attributes_length-1
                    attribute=attributes.item(j);
                    if strcmp(char(attribute.getName),'x')==1
                        positions(i+1,1)=str2double(attribute.getValue);
                        continue
                    end
                    
                    if strcmp(char(attribute.getName),'y')==1
                        positions(i+1,2)=str2double(attribute.getValue);
                        continue
                    end
                    
                    if strcmp(char(attribute.getName),'z')==1
                        positions(i+1,3)=str2double(attribute.getValue);
                        
                        
                    end
                    
                    
                end
                
                
            end
        
        
            get_max_x=max(positions(:,1));
            get_max_y=max(positions(:,2));
            get_max_z=max(positions(:,3));
            % round to the nearest tenth and set some of the TissueParams
            TissueParams.X=roundn(get_max_x,1);
            TissueParams.Y=roundn(get_max_y,1);
            TissueParams.Z=roundn(get_max_z,1);
            TissueParams.neuronDensity=(Number_of_cells*10^9)/(TissueParams.X*TissueParams.Y*TissueParams.Z);
            TissueParams.layerBoundaryArr=[TissueParams.Z, 0];
            % maybe later include as the optional input argument
            if no_of_cells<=50
                
                TissueParams.numStrips=1;
            end
            if no_of_cells >50 && no_of_cells<=1000
                TissueParams.numStrips=10;
            end
            if no_of_cells>1000 && no_of_cells<=5000
                TissueParams.numStrips=20;
            end
            if no_of_cells>5000 && no_of_cells<=10000
                TissueParams.numStrips=50;
            end
            if no_of_cells >10000
                TissueParams.numStrips=100;
            end
            TissueParams.maxZOverlap=[-1, -1];
            
            
            varargout{4}=positions;
            varargout{5}=TissueParams;
        end
    else
            
            TissueParams.neuronDensity=25000;
            V=(no_of_cells*10^9)/TissueParams.neuronDensity;
            TissueParams.X=V^(1/3);
            TissueParams.Y=V^(1/3);
            TissueParams.Z=V^(1/3); %depth of the soma layer
            TissueParams.layerBoundaryArr=[TissueParams.Z, 0];
            TissueParams.maxZOverlap=[-1, -1];
            % maybe later include as the optional input argument
            if no_of_cells<=50
                
                TissueParams.numStrips=1;
            end
            if no_of_cells >50 && no_of_cells<=1000
                TissueParams.numStrips=10;
            end
            if no_of_cells>1000 && no_of_cells<=5000
                TissueParams.numStrips=20;
            end
            if no_of_cells>5000 && no_of_cells<=10000
                TissueParams.numStrips=50;
            end
            if no_of_cells >10000
                TissueParams.numStrips=100;
            end
            
        
        
           
            varargout{4}=TissueParams;
    end
    
    get_explicitInput=root_node.getElementsByTagName('explicitInput');
    if get_explicitInput.getLength~=0
        get_cell_inputs=cell(get_explicitInput.getLength,2);
        Index_array=cell(1,no_of_populations);
        for k=1:no_of_populations
            Index_array{1,k}=zeros(1,get_explicitInput.getLength);
        end
        for i=0:get_explicitInput.getLength-1
            Explicit_input=get_explicitInput.item(i);
            Explicit_input_attributes=Explicit_input.getAttributes;
            for j=0:Explicit_input_attributes.getLength-1
                attribute=Explicit_input_attributes.item(j);
                if strcmp(char(attribute.getName),'input')==1
                    get_cell_inputs{i+1,1}=char(attribute.getValue);
                    
                    continue
                end
                if strcmp(char(attribute.getName),'target')==1
                    target_string=char(attribute.getValue);
                    target_name=strtok(target_string,'[');
                    get_cell_inputs{i+1,2}=target_name;
                    for k=1:no_of_populations
                        if strcmp(target_name,populations_ids_sizes_components{k,1})==1
                              Index_array{1,k}(1,i+1)=1;
                        end
                        
                        
                    end
                    continue
                end
                
                
            end
        
        
        
        end
        targets=zeros(1,no_of_populations);
        get_cell_inputs_for_counting=get_cell_inputs(:,1);
        input_ids=cell(1,no_of_populations);
        for k=1:no_of_populations
            pop_targets=get_cell_inputs_for_counting(Index_array{1,k}~=0);
            unique_input=unique(pop_targets);
            if length(unique_input)==1
                input_ids{1,k}=unique_input;
                targets(1,k)=length(pop_targets)==populations_ids_sizes_components{k,2};
            else
                break
            end
            
        end
        if all(targets)==1
            for i=0:get_LEMS_children.getLength-1
                specific_child=get_LEMS_children.item(i);
                specific_child_attributes=specific_child.getAttributes;
                if isempty(specific_child_attributes)==0
                    for y=0:specific_child_attributes.getLength-1
                        attribute=specific_child_attributes.item(y);
                        if strcmp(char(attribute.getName),'id')==1
                            for k=1:no_of_populations
                                if strcmp(char(attribute.getValue),input_ids{1,k})==1
                                    if strcmp(char(specific_child.getNodeName),'pulseGenerator')==1 || strcmp(char(specific_child.getNodeName),'pulseGeneratorDL')==1
                                       
                                        NeuronParams(k).Input(1).inputType='i_step';
                                        for x=0:specific_child_attributes.getLength-1
                                            attribute_in=specific_child_attributes.item(x);
                                            if strcmp(char(attribute_in.getName),'amplitude')==1
                                                
                                                attribute_value=char(attribute_in.getValue);
                                                attribute_value_type=zeros(1,length(attribute_value));
                                                for l=1:length(attribute_value)
                                                    character=str2double(attribute_value(l));
                                                    attribute_value_type(l)=character;
                                                end
                                                find_isnan=find(isnan(attribute_value_type));
                                                
                                                if find_isnan(1)==1
                                                    if numel(find_isnan)>=3
                                                        numerical_value=str2double(strtok(attribute_value,attribute_value(find_isnan(3))));
                                                    else
                                                        numerical_value=str2double(attribute_value);
                                                        
                                                    end
                                                    
                                                else
                                                    if numel(find_isnan)>=2
                                                        numerical_value=str2double(strtok(attribute_value,attribute_value(find_isnan(2))));
                                                    else
                                                        numerical_value=str2double(attribute_value);
                                                    end
                                                end
                                                NeuronParams(k).Input(1).amplitude=numerical_value;
                                                
                                                continue
                                            end
                                            if strcmp(char(attribute_in.getName),'delay')==1
                                                attribute_value=strtok(char(attribute_in.getValue),'m');
                                                NeuronParams(k).Input(1).timeOn=str2double(attribute_value);
                                                continue
                                            end
                                            if strcmp(char(attribute_in.getName),'duration')==1
                                                attribute_value=strtok(char(attribute_in.getValue),'m');
                                                duration=str2double(attribute_value);
                                                
                                            end
                                            
                                        end
                                        
                                    end
                                    NeuronParams(k).Input(1).timeOff=(NeuronParams(k).Input(1).timeOn)+duration;
                                    break
                                end
                                   
                            end
                        end
                    end
                end
            end
        end
        
    end
    
    
varargout{1}=connections;
varargout{2}=ConnectionParams;
varargout{3}=NeuronParams;

end

