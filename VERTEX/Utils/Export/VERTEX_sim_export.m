function Simulation_parameters=VERTEX_sim_export(VERTEX_params)

if isstruct(VERTEX_params)==1
    Sim_params=VERTEX_params.SimulationSettings;
    
end

if iscell(VERTEX_params)==1
    Sim_params=VERTEX_params{5};
    
end

Simulation_parameters=zeros(1,2);
Simulation_parameters(1,1)=Sim_params.simulationTime;
Simulation_parameters(1,2)=Sim_params.timeStep;


end