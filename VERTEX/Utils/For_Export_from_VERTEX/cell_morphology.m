function varargout=cell_morphology(VERTEX_params,cell_id_array,output_type)
% cell_morphology works on models with at least two compartments;
% cell_morphology() receives VERTEX_params structure, the array
% cell_id_array, which specifies the unique names of cell component types in
% neuroml and output_type:
% 1) if output_type=='cell_id', the cell_morphology() returns the
% cell_id_array only.
% 2) if output_type=='neuroml', the cell_morphology() generates
% .../cell.nml files only.
% 3) if output_type=='all', the cell morphology() generates ../cell.nml
% files and returns the cell_id_array.


% output_type=='cell_id', output_type=='all', output_type='neuroml'
if strcmp(output_type,'cell_id')==1
    varargout{1}=cell_id_array;
end
if strcmp(output_type,'all')==1 || strcmp(output_type,'neuroml')==1
    [No_Comp,CompParentArr,CompDiameterArr,Comp_positions]=compartments_parameters_export(VERTEX_params);
     No_Cellgroups=length(No_Comp); 
    for i=1:No_Cellgroups
        
        
        docNode=com.mathworks.xml.XMLUtils.createDocument('neuroml');
        neuroml=docNode.getDocumentElement;
        neuroml.setAttribute('xmlns','http://www.neuroml.org/schema/neuroml2');
        neuroml.setAttribute('xmlns:xsi','http://www.w3.org/2001/XMLSchema-instance');
        neuroml.setAttribute('xsi:schemaLocation','http://www.neuroml.org/schema/neuroml2  https://raw.githubusercontent.com/NeuroML/NeuroML2/development/Schemas/NeuroML2/NeuroML_v2beta4.xsd');
        neuroml.setAttribute('id',sprintf('%s',cell_id_array{i}));
        Cell=docNode.createElement('cell');
        Cell.setAttribute('id',sprintf('%s',cell_id_array{i}));
        neuroml.appendChild(Cell);
        morphology=docNode.createElement('morphology');
        morphology.setAttribute('id',sprintf('%s_%s','morphology',cell_id_array{i}));
        Cell.appendChild(morphology);
        for j=1:No_Comp(i)
            segment=docNode.createElement('segment');
            segment.setAttribute('id',sprintf('%d',j-1));
            morphology.appendChild(segment);
            if j~=1
                parent=docNode.createElement('parent');
                parent.setAttribute('segment',sprintf('%d',CompParentArr{1,i}(1,j)-1));
                segment.appendChild(parent);
            end
            proximal=docNode.createElement('proximal');
            proximal.setAttribute('x',sprintf('%f',Comp_positions{1,i}(j,1)));
            proximal.setAttribute('y',sprintf('%f',Comp_positions{1,i}(j,2)));
            proximal.setAttribute('z',sprintf('%f',Comp_positions{1,i}(j,3)));
            proximal.setAttribute('diameter',sprintf('%f',CompDiameterArr{1,i}(j)));
            segment.appendChild(proximal);
            distal=docNode.createElement('distal');
            distal.setAttribute('x',sprintf('%f',Comp_positions{2,i}(j,1)));
            distal.setAttribute('y',sprintf('%f',Comp_positions{2,i}(j,2)));
            distal.setAttribute('z',sprintf('%f',Comp_positions{2,i}(j,3)));
            distal.setAttribute('diameter',sprintf('%f',CompDiameterArr{1,i}(j)));
            segment.appendChild(distal);
            
        end
        path=fileparts(which('VERTEX_nml.txt'));
        t=sprintf('%s%s%s.cell.nml',path,filesep,cell_id_array{i});
        xmlwrite(t,docNode);
        
        
    end
    if strcmp(output_type,'all')==1
        varargout{1}=cell_id_array;
    end
    
end

