
% This is equivalent to LEMS definition of the Fitzhugh Nagumo neuron
% model, according to FitzHugh R. (1969): Mathematical models of excitation and
% propagation in nerve. Chapter 1 (pp. 1–85 in H.P. Schwan, ed. Biological Engineering, McGraw–Hill Book Co., N.Y.)


classdef PointNeuronModel_fitzhughnagumocell < PointNeuronModel

  
  
  properties (SetAccess = private)
    
    w
    F
    spikes
  end
  
  methods
    function NM = PointNeuronModel_fitzhughnagumocell(Neuron, number)
      NM = NM@PointNeuronModel(Neuron, number);
      
      NM.v = Neuron.v0.* ones(number, 1);
      NM.w=Neuron.w0.*ones(number,1);
      NM.spikes = [];
    end
    
    function [NM] = updateNeurons(NM, IM, N, SM, dt)
      I_syn = PointNeuronModel.sumSynapticCurrents(SM);
      I_input = PointNeuronModel.sumInputCurrents(IM);
        
         
         kv=(NM.v-((NM.v)^3)/3 - NM.w + N.I);
         kw=N.phi * (NM.v + N.a - N.b *NM.w);
        
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




