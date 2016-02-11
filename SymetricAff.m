function sA = SymetricAff(A)

rowsums = sum(A,2) + 1e-15;
sA      = A./(rowsums*rowsums');
A2      = sqrt(sum(sA,2)) + 1e-15;
sA      = sA./(A2*A2');