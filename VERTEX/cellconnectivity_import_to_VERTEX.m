function connections=cellconnectivity_import_to_VERTEX(filename)

root_node=xmlread(filename);

get_populations=root_node.getElementsByTagName('population');

no_of_populations=get_populations.getLength;

%if strcmp(varargin{1},'get synapses too')==1
    %varargout{1}=cell(no_of_populations,no_of_populations);
    
%end

populations_ids_sizes=cell(no_of_populations,2); % the first column contains the id names of distinct cell populations;
% the second column contains the sizes of these populations.
population_size_boundaries=zeros(no_of_populations,1);
population_size_boundaries(1)=0;
no_of_cells=0;
for i=0:no_of_populations-1
    
    attributes=get_populations.item(i).getAttributes;
    attributes_length=attributes.getLength;
    for j=0:attributes_length-1
        attribute=attributes.item(j);
        if strcmp(char(attribute.getName),'id')==1
            populations_ids_sizes{i+1,1}=char(attribute.getValue);
            continue
        end
        if strcmp(char(attribute.getName),'size')==1
            populations_ids_sizes{i+1,2}=str2double(attribute.getValue);
            no_of_cells=no_of_cells+str2double(attribute.getValue);
            if i+1~=1
                population_size_boundaries(i+1)=str2double(attribute.getValue)+population_size_boundaries(i);
            end
        end
           
    end
    
    
end

connections=cell(no_of_cells,3);

for i=1:no_of_cells
    
    for j=1:3
        
        connections{i,j}=[];
        if j==1 || j==3
            connections{i,j}=uint16(connections{i,j});
        end
        if j==2
            connections{i,j}=uint8(connections{i,j});
        end
    end
    
end

get_synapticConnection=root_node.getElementsByTagName('synapticConnection');

get_synapticConnectionWD=root_node.getElementsByTagName('synapticConnectionWD');

get_projections=root_node.getElementsByTagName('projection');

%get_connection=root_node.getElementsByTagName('connection');

%get_connectionWD=root_node.getElementsByTagName('connectionWD');

no_of_synapticConnection=get_synapticConnection.getLength;

no_of_synapticConnectionWD=get_synapticConnectionWD.getLength;

no_of_projections=get_projections.getLength;

%no_of_connection=get_connection.getLength;

%no_of_connectionWD=get_connectionWD.getLength;
counters_for_post_cells=ones(no_of_cells,1);
if no_of_synapticConnection~=0
    
  
   for i=0:no_of_synapticConnection-1
       attributes=get_synapticConnection.item(i).getAttributes;
       attributes_length=attributes.getLength;
       for j=0:attributes_length-1
           attribute=attributes.item(j);
           if strcmp(char(attribute.getName),'from')==1
               get_string=char(attribute.getValue);
               for k=1:no_of_populations
                   if isempty(strfind(get_string,populations_ids_sizes{k,1}))==0
                       [~,pre_cellID]=strtok(get_string,'[');
                       pre_cellID=pre_cellID(2:end-1);
                       pre_cellID=str2double(pre_cellID)+1;
                       pre_pop_size=population_size_boundaries(k);
                       
                       break
                   end
               end
               continue
           
           end
           
           if strcmp(char(attribute.getName),'to')==1
               get_to_string=char(attribute.getValue);
               for k=1:no_of_populations
                   if isempty(strfind(get_to_string,populations_ids_sizes{k,1}))==0
                       [~,post_cellID]=strtok(get_string,'[');
                       post_cellID=post_cellID(2:end-1);
                       post_cellID=str2double(post_cellID)+1;
                       connections{pre_cellID+pre_pop_size,1}(counters_for_post_cells(pre_cellID+pre_pop_size))=post_cellID+population_size_boundaries(k);
                       counters_for_post_cells(pre_cellID+pre_pop_size)=counters_for_post_cells(pre_cellID+pre_pop_size)+1;
                       break
                   end
               end
               
           end
           
           if strcmp(char(attribute.getName),'synapse')==1
               
               
           end
       end
   end




end


if no_of_synapticConnectionWD~=0
    
    for i=0:no_of_synapticConnectionWD-1
       attributes=get_synapticConnectionWD.item(i).getAttributes;
       attributes_length=attributes.getLength;
       for j=0:attributes_length-1
           attribute=attributes.item(j);
           if strcmp(char(attribute.getName),'from')==1
               get_string=char(attribute.getValue);
               for k=1:no_of_populations
                   if isempty(strfind(get_string,populations_ids_sizes{k,1}))==0
                       [~,pre_cellID]=strtok(get_string,'[');
                       pre_cellID=pre_cellID(2:end-1);
                       pre_cellID=str2double(pre_cellID)+1;
                       pre_pop_size=population_size_boundaries(k);
                       
                       break
                   end
               end
               continue
           
           end
           
           if strcmp(char(attribute.getName),'to')==1
               get_to_string=char(attribute.getValue);
               for k=1:no_of_populations
                   if isempty(strfind(get_to_string,populations_ids_sizes{k,1}))==0
                       [~,post_cellID]=strtok(get_string,'[');
                       post_cellID=post_cellID(2:end-1);
                       post_cellID=str2double(post_cellID)+1;
                       connections{pre_cellID+pre_pop_size,1}(counters_for_post_cells(pre_cellID+pre_pop_size))=post_cellID+population_size_boundaries(k);
                       counters_for_post_cells(pre_cellID+pre_pop_size)=counters_for_post_cells(pre_cellID+pre_pop_size)+1;
                       break
                   end
               end
               
           end
           
           if strcmp(char(attribute.getName),'synapse')==1
               
               
           end
       end
   end


    
end



if no_of_projections~=0
    
    
    
    
end


