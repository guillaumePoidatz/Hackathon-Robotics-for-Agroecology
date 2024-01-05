function e = err(z, z_hat)
  % This function computes the error between z_hat the expected measurement
  % and z the actual measurement. It keeps error on the angle between -pi and pi
  % to avoid jumps in the kalman update

  a = z_hat(2);
  b = z(2);

  a = a + 2*pi * floor((b-a) / (2*pi));
  if (b - a) > pi
    a = a + 2*pi;
  elseif (a - b) > pi
    a = a - 2*pi;
  endif

  % a is the new difference between angles
  e = z - z_hat;
  e(2) = b - a;

end
