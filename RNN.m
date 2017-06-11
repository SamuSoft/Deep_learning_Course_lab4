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
      h{1} = h0;
      x = x0;
      sequence = zeros();
      for i = 1:size(x,2)
        a{i} = obj.W * h{i} + obj.U * x(:,i) + obj.b;
        h{i+1} = tanh(a{i});
        o{i} = V*h{i+1} + c;
        p{i} = SOFTMAX({o{i}});
      end

    end
    function ret = SOFTMAX(P)
      e = exp(P);
      one = ones(size(P,1),1);
      split = one'*e;
      ret = e/split(1,1);
    end
    function ii = randCharSelect(obj, p,cp)
      cp = cumsum(p);
      a = rand;
      ixs = find(cp-a >0);
      ii = ixs(1);
    end
    function cost_val = cost(Y, P)
      cost_val = 0;
      for i = size(Y,2)
        cost_val = cost_val - log(Y(:,i)'*P(:,i));
      end
    end
  end
end
