function positions=cellpositions_import_to_VERTEX(xml_or_nml_filename)

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







end