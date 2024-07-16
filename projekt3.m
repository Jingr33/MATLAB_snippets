close all;
clear all;

%%%%%%%%%%%%%%%%%%%%%%%%%
% DIFERENCIALNI ROVNICE
%%%%%%%%%%%%%%%%%%%%%%%%%
% y'' - 2*y' + 3*y = 0.1, y(0) = 0, y'(0) = 1

h = 0.001; % krok
x = 0:h:5; % nezavisla promenna

% ode23
[x, y] = ode23('fode_projekt3', [0 5], [0; 1]);

% dsolve
ys = dsolve('D2y - 2*Dy + 3*y = 0.1', 'y(0) = 0', 'Dy(0) = 1', 'xx');

% graf
figure;
plot(x, subs(ys, 'xx', x), 'r', x, y(:, 1), 'b'); hold on

% simulink
S = load('projekt3.mat');
T = S.Sim.Time;
ynum = S.Sim.Data;
plot(T, ynum, 'x');

%popisky
xlabel('x'); ylabel('y');
legend('DSOLVE', 'ODE23', 'SIMULINK');

% Body vypoctene simulinkem se oddaluji od dsolvu resp. ode23 nejspise
% kvuli velkemu kroku


%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DERIVACE A INTEGRAL
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% f(x) = x^2 - zadana funkce

h = 1e-4; % krok
a = 0; % dolni mez urciteho integralu
b = 2; % horni mez urciteho integralu
x = a:h:b; % promenna x
fx = x.^2; % zadani funkce pro obdelnikovou metodu
fce = @(x) x.^2; % zadani funkce ve formatu pro funkci QUAD
syms xx;
fxx = int(xx^2, xx); % symbolicka integrace
fxxx = diff(xx^2, xx); % symbolicka derivace


% OBDELNIKOVA METODA - INTEGRACE
% Urcity integral je v grafu plocha ohranicena funkcemi fx a y = 0 a
% mezemi.
% V obd. metode se utvar rozdeli na ose x na h siroke "platky" a obsah
% kazdeho se aproximuje obsahem obdelniku f(x(i))*h.
% Nedokonalost pod fci se zanedba.
% Iobd = h*suma(f(x(i))
Iobd = h*sum(fx(1:end-1));
fprintf('Obdelnikova metoda: %f\n',Iobd);

% INTEGRAL POMOCI FCE QUAD
q = quad(fce, a, b);
fprintf('QUAD: %f\n',q);

% vypocet bodu neurciteho integralu (aby to slo vykreslit v grafu)
v(1) = 0; % prvni bod
for j = 2:length(x)
    v(j) = v(j-1) + h*fx(j); % pomoci obdelnikove metody se vypoctou ostatni funkcni body integralu
end

% Lze videt, ze obdelnikova metoda ma urcitou odchylku oproti presneji
% vypoctem urcitem integralu pomoci funkce QUAD.

% DERIVACE
% symbolicka derivace pomoci diff
derfx = diff(xx^2, xx);
fprintf('Symbolicka derivace: derfx = %s\n', derfx);

% diferencni formule - body derivace se vypocitaji z funkcnich hodnot puvodni funkce ze vztahu
% pro prvni bod derivace: u'(0) = (-3u(0) + 4u(1) - u(2)) / (2h)
% pro posledni bod: u'(n) = (u(n-2) - 4u(n-1) + 3u(n)) / (2h)
% pro vsechny ostatni body: u'(i) = (u(i+1) - u(i-1)) /(2h),
% kde u' jsou funkcni hodnoty derivace funkce a u jsou funkci hodnoty
% puvodni funkce.
u(1) = (-3*fx(1) + 4*fx(2) - fx(3)) / (2*h); % pocatecni bod derivace
u(length(fx)) = (fx(end-2) - 4*fx(end-1) + 3*fx(end)) / (2*h); % konecny bod derivace

for i = 2:length(fx) - 1
    u(i) = (fx(i+1) - fx(i-1)) / (2*h); % prostredni body derivace
end

% vykresleni puvodni funkce, jeji derivace a integralu
figure;
plot(x, fx, 'r', x, u, 'b', x, v, 'g');
xlabel('x'); ylabel('y'); % popisky os
legend('puvodni funkce', 'derivace funkce', 'integral funkce'); % legenda

% Z grafu lze videt, ze diferncni formule v tomto pripade aproximuje
% derivaci funkce velmi presne.