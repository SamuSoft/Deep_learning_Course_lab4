function loss = ComputeLoss(X, Y, RNN, hprev)
  [~,~,~,p] = RNN.ForwardPass(hprev,X,25);
  loss = RNN.cost(Y,p);
  if sum(sum(isnan(p)))
      error('P is bad');
  end
end
