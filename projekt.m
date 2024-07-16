clear all;
close all;

% funkce
% f(x) = c1 + c2*x^3

% vstupni hodnoty
x = [0.1 0.3 0.4 0.6 0.9];
y = [0.9 1.2 0.8 0.9 2.2];

% metoda nejmensich ctvercu
% S(c1, c2) = suma(f(xi) - yi)^2 = suma(c1 + c2*xi^3 - yi)^2 - hledam minimum teto funkce 
% pomoci parcialnich derivaci
% dS(c1, c2) / dc1 = suma(c1 + c2*xi^3 - yi) = 0
% dS(c1, c2) / dc2 = suma(c1 + c2*xi^3 - yi)*xi^3 = 0

% obe rovnice roznasobim a upravim do tvaru:
% suma(c1) + suma(c2*xi^3) = suma(yi)
% suma(c1*xi^3) + suma(c2*xi^6) = suma(yi*xi^3)

% hledam konstanty c1 a c2 pomoci operaci s maticemi (vztah A*c = b)
% A je matice levych stran rovnic
A = [length(x) sum(x.^3)
     sum(x.^3) sum(x.^6)];
% b je sloupcovy vektor pravych stran rovnic
b = [sum(y); sum(y.*x.^3)];

% c je sloupcovy vektor konstant c1 a c2
c = inv(A)*b;

% vytvoření proměnné a aproximační funkce
xx = 0:0.1:x(end)+0.1; % (+0.1 je tam, aby posledni namerena hodnota nebyla prilepena na hranici grafu)
yy = c(1) + c(2).*xx.^3;

% vypis vypocitanych konstant c1 a c2
disp("c1 = " + c(1));
disp("c2 = " + c(2));

% Vypocet sumy ctvercu chyb
% (pro kazdou namerenou hodnotu se vypocita rozdil oproti hodnote
% aprox. fce v danem bode, umocni se na 2 a vsechny vypocitane hodnoty se sectou) 
error = sum((y - (c(1) + c(2).*x.^3)).^2);
disp("Sum of the square errors = " + error); % Vypis

% vykreslení grafu aprox. fce a namerenych hodnot
figure; % vytvoreni "prostoru pro graf"
plot(x, y, '+', xx, yy); % vykresleni hodnot
xlabel('x'); ylabel('y'); % popisky os
legend('data', 'model', 'Location', 'northwest'); % legenda

% vytvoreni 3D grafu sumy ctvercu chyb v okoli vypocitanych konstant
figure; % vytvoreni "prostoru pro 3D graf"
xcoord = c(1)-1:0.1:c(1)+1; % jednotlive body v x-ove souradnici
ycoord = c(2)-1:0.1:c(2)+1; % jednotlive body v y-ove souradnici
[X,Y] = meshgrid(xcoord, xcoord); % vytvoreni matice pro 3d graf z hodnot x a y

Z = zeros(length(x), length(y)); % vytvoreni matice s nulami o rozsahu delky xcoord × delky ycoord

% naplneni nulove matice hodnotami
for j = 1:length(xcoord) % cyklus pres vsechny hodnoty xcoord
    for k = 1:length(ycoord) % cyklus pres vsechny hodnoty ycoord
        Z(j, k) = sum((y - (xcoord(j) + ycoord(k).*x.^3)).^2); % vypocet chyby na danem indexu
    end
end

surfl(X, Y, Z); % vykresleni 3D grafu
xlabel('surroundings c1'); ylabel('surroundings c2'); zlabel('sum of square errors'); %popisky os