function cellpositions_cellconnectivity(VERTEX_params,connections,network_id,component_array,directory,filename)

Formatted_data=cellpositions(VERTEX_params,'soma_matrix');
[ID_Matrix, group_boundaries]=cellconnectivity(connections,VERTEX_params,'ID_Matrix+group_boundaries');
[Group_members, Index_array]=cellconnectivity_tags(VERTEX_params,ID_Matrix,group_boundaries,'arrays');
synapse_types=synapse_parameters_export(VERTEX_params);
if isstruct(VERTEX_params)==1
    b=VERTEX_params.TissueParams;
end

if iscell(VERTEX_params)==1
    b=VERTEX_params{1};
end
% change original ID_Matrix used for cellconnectivity.txt to make sure it
% is compatible with indexing of cell instances.
for y=1:length(Group_members)
    if isempty(Group_members{1,y})~=1
       for k=1:length(Group_members{1,y})
           index_vector1= find(ID_Matrix(1,:)==Group_members{1,y}(k)-1);
           index_vector2=find(ID_Matrix(3,:)==Group_members{1,y}(k)-1);
           ID_Matrix(1,index_vector1)=k-1;
           ID_Matrix(3,index_vector2)=k-1;
           
           
       end
    
    end
end

docNode=com.mathworks.xml.XMLUtils.createDocument('neuroml');
neuroml=docNode.getDocumentElement;
neuroml.setAttribute('xmlns','http://www.neuroml.org/schema/neuroml2');
neuroml.setAttribute('xmlns:xsi','http://www.w3.org/2001/XMLSchema-instance');
neuroml.setAttribute('xsi:schemaLocation','http://www.neuroml.org/schema/neuroml2  https://raw.githubusercontent.com/NeuroML/NeuroML2/development/Schemas/NeuroML2/NeuroML_v2beta4.xsd');
neuroml.setAttribute('id',sprintf('%s',network_id));
for l=1:length(component_array)
    include=docNode.createElement('include');
    include.setAttribute('href',sprintf('%s.cell.nml',component_array{l}));
    neuroml.appendChild(include);
end
unique_types=unique(synapse_types);
for l=1:length(unique_types)
    include=docNode.createElement('include');
    include.setAttribute('href',sprintf('%s.synapse.nml',unique_types{l}));
    neuroml.appendChild(include);
end
network=docNode.createElement('network');
network.setAttribute('id',sprintf('%s',network_id));
neuroml.appendChild(network);
for i=1:b.numGroups
    Index_vector=(b.groupBoundaryIDArr(i)+1):b.groupBoundaryIDArr(i+1);
    population_size=length(Index_vector);
    if isempty(Index_vector)~=1
        population_data=Formatted_data(:,Index_vector(1):Index_vector(end));
        dim=size(population_data);
        population_data(1,:)=0:1:dim(2)-1;
        population=docNode.createElement('population');
        population.setAttribute('id',sprintf('pop%d',i));
        population.setAttribute('component',sprintf('%s',component_array{i}));
        population.setAttribute('type','populationList');
        population.setAttribute('size',sprintf('%d',population_size));
        network.appendChild(population);
        for j=1:dim(2)
            instance=docNode.createElement('instance');
            instance.setAttribute('id',sprintf('%d',j-1));
            population.appendChild(instance);
            location=docNode.createElement('location');
            location.setAttribute('x',sprintf('%f',population_data(2,j)));
            location.setAttribute('y',sprintf('%f',population_data(3,j)));
            location.setAttribute('z',sprintf('%f',population_data(4,j)));
            instance.appendChild(location);
            
        end
    end
    
end
projection_counter=0;
for i=1:b.numGroups
    if isempty(Group_members{1,i})~=1
        for j=1:b.numGroups
            if isempty(Index_array{i,j})~=1
                projection=docNode.createElement('projection');
                projection.setAttribute('id',sprintf('%d',projection_counter));
                projection.setAttribute('presynapticPopulation',sprintf('pop%d',i));
                projection.setAttribute('postsynapticPopulation',sprintf('pop%d',j));
                projection.setAttribute('synapse',sprintf('%s',synapse_types{i,j}));
                network.appendChild(projection);
                No_of_connections=length(Index_array{i,j});
                projection_data=ID_Matrix(:,[Index_array{i,j}]);
                for k=1:No_of_connections
                    connection=docNode.createElement('connection');
                    connection.setAttribute('id',sprintf('%d',k-1));
                    connection.setAttribute('preCellId',sprintf('../pop%d/%d/%s',i,projection_data(1,k),component_array{i}));
                    connection.setAttribute('postCellId',sprintf('../pop%d/%d/%s',j,projection_data(3,k),component_array{j}));
                    connection.setAttribute('postSegmentId',sprintf('%d',projection_data(5,k)));
                    connection.setAttribute('preSegmentId','0');
                    projection.appendChild(connection);
                end
                
                projection_counter=projection_counter+1;
            end
        end
    
    end
    
    
end
t=sprintf('%s%s.net.nml',directory,filename);
xmlwrite(t,docNode);
edit(t);

