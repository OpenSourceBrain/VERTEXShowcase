function cellpositions_cellconnectivity(VERTEX_params,network_id,directory,filename)

Formatted_data=cellpositions(VERTEX_params,'soma_matrix');

if isstruct(VERTEX_params)==1
    b=VERTEX_params.TissueParams;
end

if iscell(VERTEX_params)==1
    b=VERTEX_params{1};
end


docNode=com.mathworks.xml.XMLUtils.createDocument('neuroml');
neuroml=docNode.getDocumentElement;
neuroml.setAttribute('xmlns','http://www.neuroml.org/schema/neuroml2');
neuroml.setAttribute('xmlns:xsi','http://www.w3.org/2001/XMLSchema-instance');
neuroml.setAttribute('xsi:schemaLocation','http://www.neuroml.org/schema/neuroml2  https://raw.githubusercontent.com/NeuroML/NeuroML2/development/Schemas/NeuroML2/NeuroML_v2beta4.xsd');
neuroml.setAttribute('id',sprintf('%s',network_id));
network=docNode.createElement('network');
network.setAttribute('id',sprintf('%s',network_id));
neuroml.appendChild(network);
for i=1:b.numGroups
    Index_vector=(b.groupBoundaryIDArr(i)+1):b.groupBoundaryIDArr(i+1);
    if isempty(Index_vector)~=1
        population_data=Formatted_data(:,Index_vector(1):Index_vector(end));
        dim=size(population_data);
        population_data(1,:)=0:1:dim(2)-1;
        population=docNode.createElement('population');
        population.setAttribute('id',sprintf('%d',i-1));
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
t=sprintf('%s%s.nml',directory,filename);
xmlwrite(t,docNode);
edit(t);
