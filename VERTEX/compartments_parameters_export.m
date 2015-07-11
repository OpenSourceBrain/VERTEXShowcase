function [No_Compartments, CompartmentParentArr_Export,CompartmentDiameterArr_Export, Compartment_positions_Export]=...
          compartments_parameters_export(VERTEX_params)

if isstruct(VERTEX_params)==1
   
    Neurons=VERTEX_params.NeuronParams;
end

if iscell(VERTEX_params)==1
    
    Neurons=VERTEX_params{2};
end
No_Compartments=[Neurons.numCompartments];
No_Cellgroups=length(No_Compartments); 
CompartmentParentArray=[Neurons.compartmentParentArr];
CompartmentDiameterArray=[Neurons.compartmentDiameterArr];
CompartmentParentArr_Export=cell(1,No_Cellgroups); % preallocate parent compartment cell array
CompartmentDiameterArr_Export=cell(1,No_Cellgroups);  % preallocate compartment diameter cell array
Compartment_positions_Export=cell(2,No_Cellgroups); % the first row contains information on proximal ends of compartments;
% the second row contains information on distal ends of compartments.
CompartmentXPositions=[Neurons.compartmentXPositionMat];
CompartmentYPositions=[Neurons.compartmentYPositionMat];
CompartmentZPositions=[Neurons.compartmentZPositionMat];
CompartmentXYZPositions=cell(3,No_Cellgroups);
start=1;
start_c=1;
end_c=2;
No_Comp=No_Compartments(1);
for i=1:No_Cellgroups
    CompartmentParentArr_Export{1,i}=CompartmentParentArray(start:No_Comp);
    CompartmentDiameterArr_Export{1,i}=CompartmentDiameterArray(start:No_Comp);
    CompartmentXYZPositions{1,i}=CompartmentXPositions(:,start_c:end_c);
    CompartmentXYZPositions{2,i}=CompartmentYPositions(:,start_c:end_c);
    CompartmentXYZPositions{3,i}=CompartmentZPositions(:,start_c:end_c);
    start=No_Compartments(i)+1;
    if i~=No_Cellgroups
        start=No_Compartments(i)+1;
        No_Comp=No_Comp+No_Compartments(i+1);
        start_c=end_c+1;
        end_c=end_c+2;
    end
end

for j=1:No_Cellgroups
    comp=No_Compartments(j);
    proximal=zeros(comp,3); % the first column x coordinate, the second column - y coordinate
    distal=zeros(comp,3);  % the third column - z corodinate.
    for k=1:comp
        proximal(k,1)=CompartmentXYZPositions{1,j}(k,1);
        proximal(k,2)=CompartmentXYZPositions{2,j}(k,1);
        proximal(k,3)=CompartmentXYZPositions{3,j}(k,1);
        distal(k,1)=CompartmentXYZPositions{1,j}(k,2);
        distal(k,2)=CompartmentXYZPositions{2,j}(k,2);
        distal(k,3)=CompartmentXYZPositions{3,j}(k,2);
        
    end
    Compartment_positions_Export{1,j}=proximal;
    Compartment_positions_Export{2,j}=distal;
    
    
    
    
end



