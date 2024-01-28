function [ws, states] = reduction(ws, states, prune_threshold, merge_threshold, nmax)
  if length(ws) == 0
    return;
  end

  % Save total weight for re-normalization
  wsum = ref.logsumexp(ws);

  % 1. Pruning : remove hypotheses wth weight < prune threshold
  filter = ws > prune_threshold;
  ws = ws(filter);
  states = states(filter);

  % 2. Merging : merge hypotheses that are close enought from each other
  %[ws, states] = ref.gaussianMerging(ws, states, merge_threshold);

  % 3. Capping : keep the nmax most probable associations
  if length(ws) > nmax
    disp("capping:"), disp(length(ws) - nmax);
    [~, idx] = sort(ws, "descend");
    idx = idx(1:nmax);
    ws = ws(idx);
    states = states(idx);
  end
end
