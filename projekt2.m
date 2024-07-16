clear all;
close all;

% VYPOCET KORENE FUNKCE POMOCI NEWTONOVY METODY

syms x; % vytvoreni symbolicke promenne x
fx = x - tan(x); % zadana funkce pomoci symbolicke promenne
% tato funkce nemá komplexní řešení, tudíž se řešením v komplexním oboru
% není třeba zabývat
fxder = diff(fx); % symbolicka derivace funkce

% graf zadane funkce
figure; % vytovoreni "prostoru pro graf"
fplot(fx, [-10, 10], 'r'); % vykresleni funkce
xlabel('x'); ylabel('y'); % popisky os
legend('fx = x - tan(x)'); % legenda

maxiter = 40; % promenna maximalniho poctu iteraci (aby se se nestalo, ze metoda bude divergovat a progeram se zacyklí)
xn(1) = 1; % pocatecni aproximace

% cyklus pro vypocet newtonovy metody
for i = 2 : maxiter
    % vypocet newtonovy metody: x(n+1) = x(n) - fx(x(n)) / fxder(x(n))
    % do symbolickych funkci dosadím pomoci subs() realne hodnoty
    xn(i) = xn(i-1) - eval(subs(fx, {x}, {xn(i-1)}) / subs(fxder, {x}, {xn(i-1)}));

    % kontrola velikosti vzdalenosti vysledku od korenu
    if abs(xn(i) - xn(i-1)) < 1e-6
        % pokud je chyba mensi nez 10^-6, vypocet skonci
        break;
    end
end

% graf zavisloti presnosti vysledku na poctu aproximaci
figure; % vytovoreni "prostoru pro graf"
plot(xn, 'b'); % vykresleni funkce
xlabel('pocet iteraci'); ylabel('aproximovana hodnota'); % popisky os

% ZÁVĚR:
% Z grafu funkce f(x) = x - tan(x) lze videt, ze funkce ma nekonecne mnoho
% reseni. Pri pouziti newtonovy metody s pocatecni aproximaci x = 1 metoda
% konverguje k reseni v 0.
