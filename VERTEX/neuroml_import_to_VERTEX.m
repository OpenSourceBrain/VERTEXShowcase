function [positions, TissueParams,connections]=neuroml_import_to_VERTEX(xml_or_nml_filename)

root_node=xmlread(which(xml_or_nml_filename));

get_neuroml=root_node.getElementsByTagName('neuroml');

list_cell_positions=root_node.getElementsByTagName('location');

get_populations=root_node.getElementsByTagName('population');

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



if get_neuroml.getLength~=0
    get_projections=root_node.getElementsByTagName('projection');
    no_of_projections=get_projections.getLength; 
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
                            pre_pop_size=population_size_boundaries(l);
                        end
                        
                    end
                    continue
                end
                if strcmp(char(projection_attribute.getName),'postsynapticPopulation')==1
                    get_post_pop_name=char(projection_attribute.getValue);
                    for l=1:no_of_populations
                        if isempty(strfind(get_post_pop_name,populations_ids_sizes_components{l,1}))==0
                            post_pop_size=population_size_boundaries(l);
                        end
                        
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
                    connections{pre_cellID+pre_pop_size,1}(counters_for_post_cells(pre_cellID+pre_pop_size))=post_cellID+post_pop_size;
                    connections{pre_cellID+pre_pop_size,2}(counters_for_post_cells(pre_cellID+pre_pop_size))=1;
                    counters_for_post_cells(pre_cellID+pre_pop_size)=counters_for_post_cells(pre_cellID+pre_pop_size)+1;
                    
                    if strcmp(char(attribute.getName),'synapse')==1
                        
                        
                    end
                end
            end
            
            
            
            
            
            if no_of_connectionsWD~=0
                
                
                
                
            end
            
            
            
            
            
            
        end
        
    end
    
    
end







end