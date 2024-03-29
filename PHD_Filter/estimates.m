function objects = estimates(ws, hyps)
  %%% Returns point estimates of the positions (x, y) of the targets
  %% - ws log weights of the hypotheses in the filter
  %% - hyps the hypotheses of the filter, struct array with fields x and P
  %%% Returns
  %% Estimates as a matrix of size (2, n) where n is the estimated number of targets.
  %%
  %% WARNING !! Note that we only return the positions (x, y) of the targets, not the other variables of the state vectors

  ws = exp(ws);
  expectedNumberOfObjects = ceil(sum(ws));
  if expectedNumberOfObjects~=0
      % we select only the most releavant hypothesis
      [~, sortedIndices] = sort(ws, 'descend');
      for kObject=1:expectedNumberOfObjects
          objects(:,kObject) = hyps(sortedIndices(kObject)).x(1:2);
      end
  else
      % to just avoid an error of empty array in the following steps after
      % this function
      objects = [1;1];
  end
end
