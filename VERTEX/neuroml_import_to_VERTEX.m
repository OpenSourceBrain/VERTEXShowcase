function [import_connections,positions,TissueParams, NeuronParams,ConnectionParams, ...
 RecordingSettings, SimulationSettings]=neuroml_import_to_VERTEX(filename_run,...
 import_connections,positions,params,populations_ids_sizes_components, population_size_boundaries)

TissueParams=params.TissueParams;
NeuronParams=params.NeuronParams;
ConnectionParams=params.ConnectionParams;
RecordingSettings=params.RecordingSettings;
SimulationSettings=params.SimulationSettings;

if isempty(strfind(filename_run,'_run'))~=1
    filename_=strtok(filename_run,'run');
    filename_=filename_(1:end-1);
    nml_filename=sprintf('%.net.nml',filename_);
    does_file_exist=which(nml_filename);
    if isempty(does_file_exist)==1
        disp('Specified net.nml does not exist. Empty arrays are returned.');
        
    else
        root_node=xmlread(which(nml_filename));
    end
elseif isempty(strfind(filename_run,'.net.nml'))~=1
       %filename_=strtok(filename_run,'.');
       does_file_exist=which(filename_run);
       if isempty(does_file_exist)==1
           disp('Specified net.nml does not exist. Empty arrays are returned.');
           
       else
           root_node=xmlread(which(filename_run));
       end
else
    %filename_=filename_run;
    nml_filename=sprintf('%s.net.nml',filename_run);
    does_file_exist=which(nml_filename);
    if isempty(does_file_exist)==1
           disp('Specified net.nml does not exist. Empty arrays are returned.');
           
    else
           root_node=xmlread(which(nml_filename));
    
    end
    
    
end

if isempty(does_file_exist)~=1

get_neuroml=root_node.getElementsByTagName('neuroml');
    
if get_neuroml.getLength~=0   
    %% A block for SimulationSettings
    if isempty(SimulationSettings)==1
        SimulationSettings=struct();
        SimulationSettings.parallelSim = false;
        get_simulation=root_node.getElementsByTagName('Simulation');
        simulation_attributes=get_simulation.item(0).getAttributes;
        for i=0:simulation_attributes.getLength-1
             simulation_attribute=simulation_attributes.item(i);
             if strcmp(char(simulation_attribute.getName),'length')==1
                  get_value=char(simulation_attribute.getValue);
                  if isempty(strfind(get_value,'ms'))~=1
                
                      SimulationSettings.simulationTime=str2double(strtok(char(simulation_attribute.getValue),'m'));
                
                  else
                       SimulationSettings.simulationTime=1000*str2double(strtok(char(simulation_attribute.getValue),'s'));
                  end
            
                  continue
             end
             if strcmp(char(simulation_attribute.getName),'step')==1
                  if isempty(strfind(get_value,'ms'))~=1
                
                      SimulationSettings.timeStep=str2double(strtok(char(simulation_attribute.getValue),'m'));
                
                  else
                      SimulationSettings.timeStep=1000*str2double(strtok(char(simulation_attribute.getValue),'s'));
                  end
            
             end
        
       end
        
        
        
    end
    %% A block for population info
    get_populations=root_node.getElementsByTagName('population');
        
    no_of_populations=get_populations.getLength;
    
    if isempty(populations_ids_sizes_components)==1 && isempty(population_size_boundaries)==1
        
        
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
    end
    %% A block for cell positions
    if isempty(positions)==1
        list_cell_positions=root_node.getElementsByTagName('location');
        Number_of_cells=list_cell_positions.getLength; % generally should be the same as no_of_cells
        %calculated by adding values of attribute "size" from different populations
        
        positions=zeros(Number_of_cells,4);
        
        positions(:,4)=1:Number_of_cells;
        
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
        
    end
    %% A block for import_connections and ConnectionParams
        % currrently assumes that, if import_connections are specified through 
        % lems import, the ConnectionParams are also specified through lems import
    if isempty(import_connections)==1
        if isempty(populations_ids_sizes_components)~=1 && isempty(population_size_boundaries)~=1
            no_of_cells=0;
            for i=1:length(size(populations_ids_sizes_components))
                   no_of_cells=no_of_cells+populations_ids_sizes_components{i,2};
            end
        end
        import_connections=cell(no_of_cells,3);
        ConnectionParams(no_of_populations)=struct();
        %% A block for synapse parameters
        get_include=root_node.getElementsByTagName('include');
        get_include_length=get_include.getLength;
        
        if get_include_length~=0
            synapse_packet=cell(1,get_include_length);
            synapse_array_counter=1;
            for i=0:get_include_length-1
                get_attributes=get_include.item(i);
                if get_attributes.getLength~=0
                    for j=0:get_attributes.getLength-1
                        attribute=get_attributes.item(j);
                        if strcmp(char(attribute.getName),'href')==1
                            if isempty(strfind(char(attribute.getValue),'.synapse.nml'))==0
                                synapse_node=xmlread(which(char(attribute.getValue)));
                                % currently supports import of models with expOneSynapse only:
                                get_expOneSynapse=synapse_node.getElementsByTagName('expOneSynapse');
                                if get_expOneSynapse.getLength~=0
                                    synapse_array=cell(get_expOneSynapse.getLength,5);
                                    for ind=0:get_expOneSynapse.getLength-1
                                        synapse_array{ind+1,5}='g_exp';
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
                                                synapse_array{ind+1,2}=str2double(strtok(get_string,'m'));
                                                continue
                                            end
                                            if strcmp(char(attribute.getName),'gbase')==1
                                                get_string=char(attribute.getValue);
                                                synapse_array{ind+1,3}=str2double(strtok(get_string,'n'));
                                                continue
                                                
                                            end
                                            if strcmp(char(attribute.getName),'tauDecay')==1
                                                get_string=char(attribute.getValue);
                                                synapse_array{ind+1,4}=str2double(strtok(get_string,'m'));
                                            end
                                            
                                        end
                                        
                                   end
        
                                    
                                    
                                end
                                synapse_packet{1,synapse_array_counter}=synapse_array;
                                synapse_array_counter=synapse_array_counter+1;
                            end
                            
                        end
                        
                    end
                    
                    
                end
            end
            
            
        end
        for j=1:length(synapse_packet)
            if isempty(synapse_packet{1,j})==1
                synapse_packet=synapse_packet(1:j-1);
                break
            end
        end
        
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
            ConnectionParams(y).synapseReleaseDelay = 0.5;
            
            
        end
        
        for y=1:no_of_cells
            
            for j=1:3
                
                import_connections{y,j}=[];
                if j==1 % later decide how to take into account simulation time and convert the second column to time steps in uint16
                    import_connections{y,j}=uint16(import_connections{y,j});
                end
                if j==2
                    import_connections{y,j}=uint8(import_connections{y,j});
                    
                end
            end
            
        end
        
        
        
        
        get_projections=root_node.getElementsByTagName('projection');
        no_of_projections=get_projections.getLength;
        synapse_array=cell(no_of_populations,no_of_populations);
        counters_for_post_cells=ones(no_of_cells,1);
        if no_of_projections~=0
            for y=0:no_of_projections-1
                get_connections=get_projections.item(y).getElementsByTagName('connection');
                get_connectionsWD=get_projections.item(y).getElementsByTagName('connectionWD');
                no_of_connections=get_connections.getLength;
                no_of_connectionsWD=get_connectionsWD.getLength;
                projection_attributes=get_projections.item(y).getAttributes;
                projection_attributes_length=projection_attributes.getLength;
                for k=0:projection_attributes_length-1
                    projection_attribute=projection_attributes.item(k);
                    if strcmp(char(projection_attribute.getName),'presynapticPopulation')==1
                        get_pre_pop_name=char(projection_attribute.getValue);
                        for l=1:no_of_populations
                            if isempty(strfind(get_pre_pop_name,populations_ids_sizes_components{l,1}))==0
                                pre_pop_Index=l;
                                pre_pop_size=population_size_boundaries(l);
                            end
                            
                        end
                        continue
                    end
                    if strcmp(char(projection_attribute.getName),'postsynapticPopulation')==1
                        get_post_pop_name=char(projection_attribute.getValue);
                        for l=1:no_of_populations
                            if isempty(strfind(get_post_pop_name,populations_ids_sizes_components{l,1}))==0
                                post_pop_Index=l;
                                post_pop_size=population_size_boundaries(l);
                            end
                            
                        end
                        continue
                    end
                    if strcmp(char(projection_attribute.getName),'synapse')==1
                        synapse_array{pre_pop_Index,post_pop_Index}=char(projection_attribute.getValue);
                    end
                end
                %assign synapse parameters:
                for ind=1:length(synapse_packet)
                    for x=1:length(synapse_packet{1,ind})
                        if strcmp(synapse_packet{1,ind}{x,1},synapse_array{pre_pop_Index,post_pop_Index})==1
                            ConnectionParams(pre_pop_Index).synapseType{1,post_pop_Index}=synapse_packet{1,ind}{x,5};
                            ConnectionParams(pre_pop_Index).weights{1,post_pop_Index}=synapse_packet{1,ind}{x,3};
                            ConnectionParams(pre_pop_Index).E_reversal{1,post_pop_Index}=synapse_packet{1,ind}{x,2};
                            ConnectionParams(pre_pop_Index).tau{1,post_pop_Index}=synapse_packet{1,ind}{x,4};
                        end
                    end
                    
                end
                if no_of_connections~=0
                    
                    for j=0:no_of_connections-1
                        attributes=get_connections.item(j).getAttributes;
                        attributes_length=attributes.getLength;
                        for k=0:attributes_length-1
                            attribute=attributes.item(k);
                            if strcmp(char(attribute.getName),'preCellId')==1
                                get_string=char(attribute.getValue);
                                find_string_separator1=strfind(get_string,'/');
                                find_string_separator2=strfind(get_string,'[');
                                if isempty(find_string_separator1)==0
                                    if isempty(find_string_separator2)==0
                                        
                                        pre_cellID=str2double(get_string(find_string_separator2+1,end-1))+1;
                                        
                                    else
                                        pre_cellID=str2double(get_string(find_string_separator1(2)+1:find_string_separator1(3)-1))+1;
                                        
                                    end
                                end
                                
                                break
                            end
                        end
                        
                        for k=0:attributes_length-1
                            attribute=attributes.item(k);
                            if strcmp(char(attribute.getName),'postCellId')==1
                                get_string=char(attribute.getValue);
                                find_string_separator1=strfind(get_string,'/');
                                find_string_separator2=strfind(get_string,'[');
                                if isempty(find_string_separator1)==0
                                    if isempty(find_string_separator2)==0
                                        
                                        post_cellID=str2double(get_string(find_string_separator2+1,end-1))+1;
                                        
                                    else
                                        post_cellID=str2double(get_string(find_string_separator1(2)+1:find_string_separator1(3)-1))+1;
                                        
                                    end
                                    
                                end
                                
                                
                                
                                
                                
                                break
                            end
                        end
                        import_connections{pre_cellID+pre_pop_size,1}(counters_for_post_cells(pre_cellID+pre_pop_size))=post_cellID+post_pop_size;
                        import_connections{pre_cellID+pre_pop_size,2}(counters_for_post_cells(pre_cellID+pre_pop_size))=1;
                        import_connections{pre_cellID+pre_pop_size,3}(counters_for_post_cells(pre_cellID+pre_pop_size))=0.5;
                        counters_for_post_cells(pre_cellID+pre_pop_size)=counters_for_post_cells(pre_cellID+pre_pop_size)+1;
                        ConnectionParams(pre_pop_Index).numConnectionsToAllFromOne{1,post_pop_Index}=ConnectionParams(pre_pop_Index).numConnectionsToAllFromOne{1,k}+1;
                        
                        
                    end
                end
                
                if no_of_connectionsWD~=0
                    for j=0:no_of_connectionsWD-1
                        attributes=get_connectionsWD.item(j).getAttributes;
                        attributes_length=attributes.getLength;
                        for k=0:attributes_length-1
                            attribute=attributes.item(k);
                            if strcmp(char(attribute.getName),'preCellId')==1
                                get_string=char(attribute.getValue);
                                find_string_separator1=strfind(get_string,'/');
                                find_string_separator2=strfind(get_string,'[');
                                if isempty(find_string_separator1)==0
                                    if isempty(find_string_separator2)==0
                                        
                                        pre_cellID=str2double(get_string(find_string_separator2+1,end-1))+1;
                                        
                                    else
                                        pre_cellID=str2double(get_string(find_string_separator1(2)+1:find_string_separator1(3)-1))+1;
                                        
                                    end
                                end
                                
                                break
                            end
                        end
                        
                        for k=0:attributes_length-1
                            attribute=attributes.item(k);
                            if strcmp(char(attribute.getName),'postCellId')==1
                                get_string=char(attribute.getValue);
                                find_string_separator1=strfind(get_string,'/');
                                find_string_separator2=strfind(get_string,'[');
                                if isempty(find_string_separator1)==0
                                    if isempty(find_string_separator2)==0
                                        
                                        post_cellID=str2double(get_string(find_string_separator2+1,end-1))+1;
                                        
                                    else
                                        post_cellID=str2double(get_string(find_string_separator1(2)+1:find_string_separator1(3)-1))+1;
                                        
                                    end
                                    
                                end
                                break
                            end
                        end
                        for k=0:attributes_length-1
                            attribute=attributes.item(k);
                            if strcmp(char(attribute.getName),'delay')==1
                               delay=strtok(char(attribute.getValue),'m');
                               import_connections{pre_cellID+pre_pop_size,3}(counters_for_post_cells(pre_cellID+pre_pop_size))=str2double(delay)+0.5;
                            
                            end
                        end
                        import_connections{pre_cellID+pre_pop_size,1}(counters_for_post_cells(pre_cellID+pre_pop_size))=post_cellID+post_pop_size;
                        import_connections{pre_cellID+pre_pop_size,2}(counters_for_post_cells(pre_cellID+pre_pop_size))=1;
                        counters_for_post_cells(pre_cellID+pre_pop_size)=counters_for_post_cells(pre_cellID+pre_pop_size)+1;
                        ConnectionParams(pre_pop_Index).numConnectionsToAllFromOne{1,post_pop_Index}=ConnectionParams(pre_pop_Index).numConnectionsToAllFromOne{1,k}+1;
                        
                        
                    end
                end
            end
        end
        % VERTEX assumes that within a given cell population each presynaptic cell provides
        % a fixed number of synaptic inputs to the postsynaptic neurons in a
        % given cell population. This method assumes that this condition is met
        % by lems file; if not, the results will be rounded to the nearest integer as below:
    
        for pre=1:no_of_populations
            for post=1:no_of_populations
              ConnectionParams(pre).numConnectionsToAllFromOne{1,post}=round((ConnectionParams(pre).numConnectionsToAllFromOne{1,post})/populations_ids_sizes_components{pre,2});
        
            end
        end
        
        % Use SimulationSettings.timeStep to obtain delay steps:
        for i=1:no_of_cells
        
            import_connections{i,3}=uint16(ceil(import_connections{i,3}./ (SimulationSettings.timeStep)));
        
        end
        
        
    end
    
    %% A block for RecordingSettings
    if isempty(RecordingSettings)==1
        RecordingSettings=struct();
        RecordingSettings.saveDir=[sprintf('%s_import',filename_), filesep];
        RecordingSettings.LFP=false;
        RecordingSettings.v_m = 1:no_of_cells;
        RecordingSettings.maxRecTime = 100;
        RecordingSettings.sampleRate = 1000*(1/SimulationSettings.timeStep);
    end
    
    
end



end