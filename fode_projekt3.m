% y2 = y', y2' = 2*y2 - 3y1 + 0.1

function[yd] = fode(x, y)
yd = [y(2); 2*y(2) - 3*y(1) + 0.1];