classdef PointNeuronModel_izhikevichcell < PointNeuronModel
  %PointNeuronModel_izhikevichCell equivalent to the izhikevichCell in LEMS
  %   Parameters to set in NeuronParams:
  %   - v0, (mV)
  %   - a, dimensionless
  %   - b, dimensionless
  %   - c, dimensionless
  %   - d, dimensionless
  %   - thresh, (mV)
  
  properties (SetAccess = private)
    U
    spikes
  end
  
  methods
    function NM = PointNeuronModel_izhikevichcell(Neuron, number)
      NM = NM@PointNeuronModel(Neuron, number);
      NM.v = Neuron.v0.* ones(number, 1);
      NM.U = Neuron.v0*Neuron.b.*ones(number, 1);
      NM.spikes = [];
    end
    
    function [NM] = updateNeurons(NM, IM, N, SM, dt)
      I_syn = PointNeuronModel.sumSynapticCurrents(SM);
      I_input = PointNeuronModel.sumInputCurrents(IM);
      kv = 0.04 .* (NM.v)^2 + 5.*(NM.v)+ 140.0 -NM.U + I_syn + I_input;
      
      kU = N.a .* (N.b.*NM.v - NM.U);
      
      k2v_in = NM.v + 0.5 .* dt .* kv;
      k2U_in = NM.U + 0.5 .* dt .* kU;
      
      kv = 0.04 .* (k2v_in)^2 + 5.*(k2v_in)+ 140.0 -NM.U + I_syn + I_input;
      
      kU = N.a .* (N.b.*NM.v - k2U_in);
    
      NM.v = NM.v + dt .* kv;
      NM.U = NM.U + dt .* kU;
      
      NM.spikes = NM.v(:,1) > N.thresh;
      NM.v(NM.spikes, 1) = N.c;
      NM.U(NM.spikes, 1) = NM.U(NM.spikes, 1) + N.d;
    end
    
    function spikes = get.spikes(NM)
      spikes = NM.spikes;
    end
    
    function NM = randomInit(NM, N)
      NM.v = N.v_reset - (rand(size(NM.v)) .* 5);
      NM.U = rand(size(NM.U)) .* N.d/3;
    end
  end % methods
  
  methods(Static)
    
    function params = getRequiredParams()
      params = [getRequiredParams@PointNeuronModel, ...
                {'v0','a','b','c','d','thresh'}];
    end
    
  end
end % classdef