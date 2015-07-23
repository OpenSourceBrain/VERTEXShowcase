function VERTEXcell_vs_LEMScell(VERTEX_params,Results,filename,cellID_in_pop,popID)
%use this function after VERTEX-specific and LEMS-specific simulations to
%compare membrane potential time courses across these two simulators.
%popID and cellID_in_pop are counted from zero as in LEMS; filename is the
%filename of the given .dat file generated during LEMS-specific simulation.
%This is usually saved in the jNeuroMLJar subfolder named results.
if isstruct(VERTEX_params)==1
    Tissue_params=VERTEX_params.TissueParams;
    
end

if iscell(VERTEX_params)==1
    Tissue_params=VERTEX_params{1};
   
    
end
% get cellID in VERTEX format
cellID=cellID_in_pop+1;
if popID~=0
    cellID=(cellID_in_pop+1)+Tissue_params.groupSizeArr(popID+1,1);
end
% Visualize results from both VERTEX and LEMS simulations
plot(Results.v_m(cellID, :), 'LineWidth', 2,'Color','r') 
hold on
load(sprintf('jNeuroMLJar/results/%s.dat',filename)); % change this depending where jNeuroMLJar results are saved
plot(1000*eval(sprintf('%s(:,1)',filename)),1000*eval(sprintf('%s(:,2)',filename)),'LineWidth',2,'Color','b')
set(gcf,'color','w');
set(gca,'FontSize',16)
title('Membrane potential for the Adex one compartment neuron in the LEMS and VERTEX simulations', 'FontSize', 16)
xlabel('Time (ms)', 'FontSize', 16)
ylabel('Membrane potential (mV)', 'FontSize', 16)
