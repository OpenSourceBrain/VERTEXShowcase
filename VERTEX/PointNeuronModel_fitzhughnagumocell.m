


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%    PLEASE NOTE: This export is still in development
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
               %% the first problem: class name has to include a name of cell type 
               % not a cell id (previously there was aa fn1_flat)
classdef PointNeuronModel_fitzhughnagumocell < PointNeuronModel

  
  
  properties (SetAccess = private)
    
    w
    F
    spikes
  end
  
  methods
    function NM = PointNeuronModel_fitzhughnagumocell(Neuron, number)
      NM = NM@PointNeuronModel(Neuron, number);
      %% the second problem: if there is no on start value, set to zero (previously there was Neuron.0.* ...)
      NM.v = Neuron.v0.* ones(number, 1);
      NM.w=Neuron.w0.*ones(number,1);
      NM.spikes = [];
    end
    
    function [NM] = updateNeurons(NM, IM, N, SM, dt)
      I_syn = PointNeuronModel.sumSynapticCurrents(SM);
      I_input = PointNeuronModel.sumInputCurrents(IM);
        %the third problem: state variables have to be obtained through NM
        %constructor 
        %the fourth problem: parameters have to be obtained through N
        %arrays
        % the fifth problem: SEC has no associated value, simple divide by
        % one (?)
         
         kv=(NM.v-((NM.v)^3)/3 - NM.w + N.I);
         kw=N.phi * (NM.v + N.a - N.b *NM.w);
        % the fifth problem: second-order Runge Kutta has to be specified
        % in each cell class:
        k2v_in = NM.v + 0.5 .* dt .* kv;
        k2w_in = NM.w + 0.5 .* dt .* kw;
        
        kv=(k2v_in-((k2v_in)^3)/3 -NM.w+N.I);
        kw=N.phi*(NM.v+N.a-N.b*k2w_in);
        NM.v = NM.v + dt .* kv;
        NM.w = NM.w + dt .* kw;

    end
    
    function spikes = get.spikes(NM)
      spikes = NM.spikes;
    end
    
    function NM = randomInit(NM, N)
      NM.v = 0.* ones(number, 1) - (rand(size(NM.v)) .* 5);
      NM.W = rand(size(NM.W)) .* N.d/3;
    end
  end % methods
  

  methods(Static)
    
    function params = getRequiredParams()
      params = [getRequiredParams@PointNeuronModel, ...
                {'a','b','I','phi','v0','w0'}];
    end
    
  end
end % classdef




