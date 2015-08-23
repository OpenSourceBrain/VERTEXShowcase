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
                                        
                                        numerical_value=str2double(strtok(attribute_value,attribute_value(find_isnan(3))));
                                        
                                    else
                                        numerical_value=str2double(strtok(attribute_value,attribute_value(find_isnan(2))));
                                        
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
        
        
        
    end
varargout{1}=connections;
varargout{2}=ConnectionParams;
varargout{3}=NeuronParams;

end

