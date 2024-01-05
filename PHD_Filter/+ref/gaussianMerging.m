function [ws, states] = gaussianMerging(ws, states, threshold)
  if length(states) == 0
    return;
  endif

  I = 1:length(states);
  el = 1;

  while ~isempty(I)
    Ij = [];
    % Get the component with the highest weight
    [~, j] = max(ws);

    % For each components, compute mahalanobis distance and keep close ones
    for i = I
      temp = states(i).x - states(j).x;
      val = diag(temp.'*(states(j).P \temp));
      if val < threshold
        Ij = [Ij, i];
      endif
    endfor

    % Merge components using gaussian moment matching
    [temp, w_hat(el, 1)] = ref.normalizeLogWeights(ws(Ij));
    states_hat(1, el) = ref.momentMatching(temp, states(Ij));

    % Remove indices of merged components
    I = setdiff(I, Ij);

    ws(Ij) = log(eps);
    el = el + 1;
  endwhile

  ws = w_hat;
  states = states_hat;
endfunction
