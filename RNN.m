classdef RNN < matlab.mixin.SetGet

  properties (GetAccess = private, Constant)
    eta = .1;
    seq_length = 25;
  end
  properties
    % Vectors
    b;
    c;
    % Weight matrixes
    U;
    W;
    V;

  end
  properties (GetAccess = private)
    grad;
    m;
    sig;
  end
  methods
    function obj = RNN(m, K, sig)
      obj.sig = sig;
      obj.m =  m;
      obj.b =  zeros(m,1);
      obj.c =  zeros(K,1);

      obj.U = randn(m, K)*sig;
      obj.W = randn(m, m)*sig;
      obj.V = randn(K,m)*sig;
      obj.grad = Gradients(obj.W, obj.V, obj.U, obj.b, obj.c);

    end
    function Output = synthesize(obj, h0, x0, n)
      %  h0 (the hidden state at time 0)
      %  x0 represent the first (dummy) input
      %  n denotes the length of the sequence you want to generate
      x = zeros(size(x0,1),n+1);
      x(:,1) = x0;

      h = zeros(size(h0,1),n+1);
      h(:,1) = h0;

      for i = 1:(n)
          a = obj.W * h(:,i) + obj.U * x(:,i) + obj.b;
          h(:,i+1) = tanh(a);
          o = obj.V*h(:,i+1) + obj.c;
          p = obj.SOFTMAX(o);
          x(obj.randCharSelect(p),i+1) = 1;
      end

      Output = x;

    end
    function train(obj, X, Y, h0)

        obj.GradientDescent(X,Y,h0);

    end
    function [a, o, h, p] = ForwardPass(obj, h0, x0, n)

      h = zeros(size(obj.W,1),n+1);
      h(:,1) = h0;
      a = zeros(size(obj.W,1),n);
      x = x0;
      o = zeros(size(obj.V,1),n);
      p = zeros(size(obj.V,1),n);

      for i = 1:n
        a(:,i) = obj.W * h(:,i) + obj.U * x(:,i) + obj.b;
        h(:,i+1) = tanh(a(:,i));
        o(:,i) = obj.V*h(:,i+1) + obj.c;
        p(:,i) = obj.SOFTMAX(o(:,i));

        if sum(sum(isnan(p))) > 0
            error(strcnt('The problem is P at ', int2str(i)));
        end
      end
    end
    function BackProp(obj)
      % obj.W = obj.W - obj.grad.W;
      % obj.V = obj.V - obj.grad.V;
      % obj.U = obj.U - obj.grad.U;

      for f = fieldnames(RNN)'
        obj.(f{1}) = obj.(f{1}) - obj.eta * grad.(f{1});
      end
    end
    function GradientDescent(obj, X, Y,h0)
      [a, o, h, P] = obj.ForwardPass(h0, X, size(X,2));
      G = -(Y-P)';
      t = size(Y,2);

      L_o = G;
      L_W = zeros(size(obj.grad.W));
      L_V = zeros(size(obj.grad.V));
      L_U = zeros(size(obj.grad.U));
      L_b = zeros(size(obj.grad.b));
      L_c = zeros(size(obj.grad.c));
      L_h = zeros(obj.m,t);
      L_a = zeros(obj.m,t);

      L_h(:,t) = (L_o(t,:)*obj.V)';
      L_a(:,t) = (L_h(:,t)'*diag(1 - tanh(a(:,t)).^2))';
      for i = (t-1):-1:1
        L_h(:,i) = (L_o(i,:)*obj.V)' + (L_a(:,i)'*obj.W)';
        L_a(:,i) = (L_h(:,i)'* diag(1 - tanh(a(:,i)).^2))';
        L_W = L_W + L_a(:,i)*h(:,i+1)';
        L_V = L_V + G(i,:)'*h(:,i+1)';
        L_U = L_U + L_a(:,i)*X(:,i)';

        if sum(isnan(L_h(:,i))) > 0
            error(strcnt('The problem is h at ', int2str(i)));
        end
        if sum(isnan(L_a(:,i))) > 0
            error(strcnt('The problem is L_a at ', int2str(i)));
        end
        if sum(sum(isnan(L_W))) > 0
            error(strcnt('The problem is L_W at ', int2str(i)));
        end
        if sum(sum(isnan(L_V))) > 0
            error(strcnt('The problem is L_V at ', int2str(i)));
        end
        if sum(sum(isnan(L_U))) > 0
            error(strcnt('The problem is L_U at ', int2str(i)));
        end


        % TODO
        % L_b = L_b + G(i,:)';
        % L_c = L_c;

      end
      obj.grad.W = L_W;
      obj.grad.V = L_V;
      obj.grad.U = L_U;

      % obj.BackProp();
    end
    function Errors = testGradients(obj, X, Y)
      h0 = zeros(obj.m,1);
      h = 10^(-4);
      obj.GradientDescent(X,Y,h0);
      grads = ComputeGradsNum(X, Y, obj, h);

      Errors{1} = obj.ErrDiff(obj.grad.W,grads.W);
      Errors{2} = obj.ErrDiff(obj.grad.V,grads.V);
      Errors{3} = obj.ErrDiff(obj.grad.U,grads.U);
    end
  end

  methods (Static)
    function ret = SOFTMAX(O)
      out_temp = O - max(O);
      P = out_temp + 0.0000001;
      e = exp(P);
      split2 = (sum(e));

      ret = e/split2;
      if sum(sum(isnan(ret))) > 0
          error('The problem is Softmax');
      end


    end
    function ii = randCharSelect(p)
      cp = cumsum(p);
      a = rand;
      ixs = find(cp-a >0);
      ii = ixs(1);
    end
    function diff = ErrDiff(X,Y)
      diff = sum(abs(max(X - Y)))/max(.001,sum(abs(max(X))) +sum(abs(max(Y))));
    end
    function cost_val = cost(Y, P)
      cost_val = 0;
      for i = 1:size(P,2)
        cost_val = cost_val - log(Y(:,i)'*P(:,i));
      end
    end
  end
end
