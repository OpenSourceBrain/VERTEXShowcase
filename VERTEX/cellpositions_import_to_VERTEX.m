function [positions, TissueParams]=cellpositions_import_to_VERTEX(xml_or_nml_filename,no_of_Strips)

root_node=xmlread(xml_or_nml_filename);

list_cell_positions=root_node.getElementsByTagName('location');

Number_of_cells=list_cell_positions.getLength;

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
TissueParams.numStrips=no_of_Strips;
TissueParams.maxZOverlap=[-1, -1];








end