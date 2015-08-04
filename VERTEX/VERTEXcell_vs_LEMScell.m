function VERTEXcell_vs_LEMScell(VERTEX_params,Results,filename,cellID_in_pop,popID)
%use this function after VERTEX-specific and LEMS-specific simulations to
%compare membrane potential time courses across these two simulators.
%popID and cellID_in_pop are counted from zero as in LEMS; filename is the
%filename of the given .dat file generated during LEMS-specific simulation.
%This is usually saved in the jNeuroMLJar subfolder named results.
if isstruct(VERTEX_params)==1
    Tissue_params=VERTEX_params.TissueParams;
    Recording_params=VERTEX_params.RecordingSettings;
end

if iscell(VERTEX_params)==1
    Tissue_params=VERTEX_params{1};
    Recording_params=VERTEX_params{4};
   
    
end
% get cellID in VERTEX format
cellID=cellID_in_pop+1;
if popID~=0
    cellID=cellID_in_pop+1+Tissue_params.groupBoundaryIDArr(popID+1,1);
end
index=find(Recording_params.v_m==cellID);
% Visualize results from both VERTEX and LEMS simulations
x=plot(Results.v_m(index, :), 'LineWidth', 2,'Color','r');
dat_path=which(sprintf('%s.dat',filename));
hold on
load(dat_path);
y=plot(1000*eval(sprintf('%s(:,1)',filename)),1000*eval(sprintf('%s(:,2)',filename)),'LineWidth',2,'Color','b');
set(gcf,'color','w');
set(gca,'FontSize',16)
legend([x,y],'VERTEX','LEMS','Location','NorthEastOutside')
title('Membrane potential of the Adex point neuron in the LEMS and VERTEX simulations', 'FontSize', 16)
xlabel('Time (ms)', 'FontSize', 16)
ylabel('Membrane potential (mV)', 'FontSize', 16)
