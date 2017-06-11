classdef RNN < matlab.mixin.SetGet

  properties (constant)
    eta = .1;
    seq_length = 25;
  end
  properties
    % properties
    m;
    sig;
    % Vectors
    b;
    c;
    % Weight matrixes
    U;
    W;
    V;
  end
  methods
    function obj = RNN(m, K, sig)
      obj.sig = ,sig;
      obj.m =  m;
      obj.b =  zeros(m,1);
      obj.c =  zeros(K,1);

      obj.U = randn(m, K)*sig;
      obj.W = randn(m, m)*sig;
      obj.V = randn(K,m)*sig;
    end
    function sequence = synthesize(obj, h0, x0, n)
      %  h0 (the hidden state at time 0)
      %  x0 represent the first (dummy) input
      %  n denotes the length of the sequence you want to generate
    end
    function ii = randCharSelect(obj, p,cp)

    end
  end
end
