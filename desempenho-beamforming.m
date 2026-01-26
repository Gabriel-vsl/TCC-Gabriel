% Carregar os dados
data1 = load('resultados_00_0dbm_usuarios_DOA.mat');
data2 = load('resultados_teoricos_0dBm_usuarios_DOA.mat');
rng(39); % Você pode usar qualquer valor para garantir a reprodutibilidade


% Extrair resultados das bases de dados
resultados1 = data1.resultados_usuarios;
resultados2 = data2.resultados_teoricos;

% Inicializar arrays para armazenar dados de treinamento para a primeira base de dados
doa_AP1_1 = []; doa_AP2_1 = []; doa_AP3_1 = []; doa_AP4_1 = [];
posicoes1 = [];

% Organizar os dados da primeira base de dados
for i = 1:size(resultados1, 1)
    doa1 = []; doa2 = []; doa3 = []; doa4 = [];
    pos1 = []; pos2 = []; pos3 = []; pos4 = [];
    
    if i <= size(resultados1, 1)
        doa1 = resultados1{i, 1};
    end
    if i+1 <= size(resultados1, 1)
        doa2 = resultados1{i+1, 1};
    end
    if i+2 <= size(resultados1, 1)
        doa3 = resultados1{i+2, 1};
    end
    if i+3 <= size(resultados1, 1)
        doa4 = resultados1{i+3, 1};
    end
    
    if i <= size(resultados1, 1)
        pos1 = resultados1{i, 3};
    end
    if i+1 <= size(resultados1, 1)
        pos2 = resultados1{i+1, 3};
    end
    if i+2 <= size(resultados1, 1)
        pos3 = resultados1{i+2, 3};
    end
    if i+3 <= size(resultados1, 1)
        pos4 = resultados1{i+3, 3};
    end
    
           % doa_AP1_1 = [doa_AP1_1; doa1];
           % doa_AP2_1 = [doa_AP2_1; doa2];
           % doa_AP3_1 = [doa_AP3_1; doa3];
           % doa_AP4_1 = [doa_AP4_1; doa4];
           % posicoes1 = [posicoes1; pos1(:)'];


    if isequal(pos1, pos2) && isequal(pos1, pos3) && isequal(pos1, pos4)
        if ~isequal(doa1, [999, 999]) || ~isequal(doa2, [999, 999]) || ~isequal(doa3, [999, 999]) || ~isequal(doa4, [999, 999])
            doa_AP1_1 = [doa_AP1_1; doa1];
            doa_AP2_1 = [doa_AP2_1; doa2];
            doa_AP3_1 = [doa_AP3_1; doa3];
            doa_AP4_1 = [doa_AP4_1; doa4];
            posicoes1 = [posicoes1; pos1(:)'];
        end
    end
end

% Inicializar arrays para armazenar dados de treinamento para a segunda base de dados
doa_AP1_2 = []; doa_AP2_2 = []; doa_AP3_2 = []; doa_AP4_2 = [];
posicoes2 = [];

% Organizar os dados da segunda base de dados
for i = 1:size(resultados2, 1)
    doa1 = []; doa2 = []; doa3 = []; doa4 = [];
    pos1 = []; pos2 = []; pos3 = []; pos4 = [];
    
    if i <= size(resultados2, 1)
        doa1 = resultados2{i, 1};
    end
    if i+1 <= size(resultados2, 1)
        doa2 = resultados2{i+1, 1};
    end
    if i+2 <= size(resultados2, 1)
        doa3 = resultados2{i+2, 1};
    end
    if i+3 <= size(resultados2, 1)
        doa4 = resultados2{i+3, 1};
    end
    
    if i <= size(resultados2, 1)
        pos1 = resultados2{i, 3};
    end
    if i+1 <= size(resultados2, 1)
        pos2 = resultados2{i+1, 3};
    end
    if i+2 <= size(resultados2, 1)
        pos3 = resultados2{i+2, 3};
    end
    if i+3 <= size(resultados2, 1)
        pos4 = resultados2{i+3, 3};
    end
    
           % doa_AP1_2 = [doa_AP1_2; doa1];
           % doa_AP2_2 = [doa_AP2_2; doa2];
           % doa_AP3_2 = [doa_AP3_2; doa3];
           % doa_AP4_2 = [doa_AP4_2; doa4];
           % posicoes2 = [posicoes2; pos1(:)'];


   if isequal(pos1, pos2) && isequal(pos1, pos3) && isequal(pos1, pos4)
        if ~isequal(doa1, [999, 999]) || ~isequal(doa2, [999, 999]) || ~isequal(doa3, [999, 999]) || ~isequal(doa4, [999, 999])
            doa_AP1_2 = [doa_AP1_2; doa1];
            doa_AP2_2 = [doa_AP2_2; doa2];
            doa_AP3_2 = [doa_AP3_2; doa3];
            doa_AP4_2 = [doa_AP4_2; doa4];
            posicoes2 = [posicoes2; pos1(:)'];
        end
    end
end

% Calcular os erros para cada AP
errors_AP1 = doa_AP1_1 - doa_AP1_2;
errors_AP2 = doa_AP2_1 - doa_AP2_2;
errors_AP3 = doa_AP3_1 - doa_AP3_2;
errors_AP4 = doa_AP4_1 - doa_AP4_2;

% Inicializar a figura
figure;

% Histograma de erros para AP1
subplot(2, 2, 1);
histogram(errors_AP1, 20);
xlabel('Erro DOA');
ylabel('Frequência');
title('Histograma dos Erros para AP1');

% Histograma de erros para AP2
subplot(2, 2, 2);
histogram(errors_AP2, 20);
xlabel('Erro DOA');
ylabel('Frequência');
title('Histograma dos Erros para AP2');

% Histograma de erros para AP3
subplot(2, 2, 3);
histogram(errors_AP3, 20);
xlabel('Erro DOA');
ylabel('Frequência');
title('Histograma dos Erros para AP3');

% Histograma de erros para AP4
subplot(2, 2, 4);
histogram(errors_AP4, 20);
xlabel('Erro DOA');
ylabel('Frequência');
title('Histograma dos Erros para AP4');

% Ajustar o layout
sgtitle('Distribuição dos Erros DOA entre Bases de Dados');

% Inicializar a figura
figure;

% Gráfico de dispersão para AP1
subplot(2, 2, 1);
scatter(doa_AP1_1(:, 1), doa_AP1_2(:, 1), 'o');
hold on;
scatter(doa_AP1_1(:, 2), doa_AP1_2(:, 2), 'x');
xlabel('DOA Base 1');
ylabel('DOA Base 2');
title('Gráfico de Dispersão para AP1');
legend('Coluna 1', 'Coluna 2');
grid on;

% Gráfico de dispersão para AP2
subplot(2, 2, 2);
scatter(doa_AP2_1(:, 1), doa_AP2_2(:, 1), 'o');
hold on;
scatter(doa_AP2_1(:, 2), doa_AP2_2(:, 2), 'x');
xlabel('DOA Base 1');
ylabel('DOA Base 2');
title('Gráfico de Dispersão para AP2');
legend('Coluna 1', 'Coluna 2');
grid on;

% Gráfico de dispersão para AP3
subplot(2, 2, 3);
scatter(doa_AP3_1(:, 1), doa_AP3_2(:, 1), 'o');
hold on;
scatter(doa_AP3_1(:, 2), doa_AP3_2(:, 2), 'x');
xlabel('DOA Base 1');
ylabel('DOA Base 2');
title('Gráfico de Dispersão para AP3');
legend('Coluna 1', 'Coluna 2');
grid on;

% Gráfico de dispersão para AP4
subplot(2, 2, 4);
scatter(doa_AP4_1(:, 1), doa_AP4_2(:, 1), 'o');
hold on;
scatter(doa_AP4_1(:, 2), doa_AP4_2(:, 2), 'x');
xlabel('DOA Base 1');
ylabel('DOA Base 2');
title('Gráfico de Dispersão para AP4');
legend('Coluna 1', 'Coluna 2');
grid on;

% Ajustar o layout
sgtitle('Gráficos de Dispersão dos DOAs entre Bases de Dados');

% Calcular o erro quadrático médio
mse_AP1 = mean(mean((doa_AP1_1 - doa_AP1_2).^2));
mse_AP2 = mean(mean((doa_AP2_1 - doa_AP2_2).^2));
mse_AP3 = mean(mean((doa_AP3_1 - doa_AP3_2).^2));
mse_AP4 = mean(mean((doa_AP4_1 - doa_AP4_2).^2));

% Calcular a raiz do erro quadrático médio
rmse_AP1 = sqrt(mse_AP1);
rmse_AP2 = sqrt(mse_AP2);
rmse_AP3 = sqrt(mse_AP3);
rmse_AP4 = sqrt(mse_AP4);

% Mostrar resultados
fprintf('Erro Quadrático Médio para AP1: %.2f\n', mse_AP1);
fprintf('Raiz do Erro Quadrático Médio para AP1: %.2f\n', rmse_AP1);

fprintf('Erro Quadrático Médio para AP2: %.2f\n', mse_AP2);
fprintf('Raiz do Erro Quadrático Médio para AP2: %.2f\n', rmse_AP2);

fprintf('Erro Quadrático Médio para AP3: %.2f\n', mse_AP3);
fprintf('Raiz do Erro Quadrático Médio para AP3: %.2f\n', rmse_AP3);

fprintf('Erro Quadrático Médio para AP4: %.2f\n', mse_AP4);
fprintf('Raiz do Erro Quadrático Médio para AP4: %.2f\n', rmse_AP4);


% Calcular o erro absoluto médio para cada AP
error_AP1 = mean(abs(doa_AP1_1 - doa_AP1_2), 1);
error_AP2 = mean(abs(doa_AP2_1 - doa_AP2_2), 1);
error_AP3 = mean(abs(doa_AP3_1 - doa_AP3_2), 1);
error_AP4 = mean(abs(doa_AP4_1 - doa_AP4_2), 1);

% Mostrar resultados
fprintf('Erro Absoluto Médio para AP1: %.2f\n', mean(error_AP1));
fprintf('Erro Absoluto Médio para AP2: %.2f\n', mean(error_AP2));
fprintf('Erro Absoluto Médio para AP3: %.2f\n', mean(error_AP3));
fprintf('Erro Absoluto Médio para AP4: %.2f\n', mean(error_AP4));

% Calcular o erro absoluto para AP1
erro_AP1_col1 = abs(doa_AP1_1(:, 1) - doa_AP1_2(:, 1)); % Erro para coluna 1 (Azimute)
erro_AP1_col2 = abs(doa_AP1_1(:, 2) - doa_AP1_2(:, 2)); % Erro para coluna 2 (Elevação)

% Calcular o erro absoluto para AP2
erro_AP2_col1 = abs(doa_AP2_1(:, 1) - doa_AP2_2(:, 1));
erro_AP2_col2 = abs(doa_AP2_1(:, 2) - doa_AP2_2(:, 2));

% Calcular o erro absoluto para AP3
erro_AP3_col1 = abs(doa_AP3_1(:, 1) - doa_AP3_2(:, 1));
erro_AP3_col2 = abs(doa_AP3_1(:, 2) - doa_AP3_2(:, 2));

% Calcular o erro absoluto para AP4
erro_AP4_col1 = abs(doa_AP4_1(:, 1) - doa_AP4_2(:, 1));
erro_AP4_col2 = abs(doa_AP4_1(:, 2) - doa_AP4_2(:, 2));

% Inicializar a figura para gráficos dos erros
figure;

% Gráfico de erros para AP1
subplot(2, 2, 1);
plot(erro_AP1_col1, 'o-', 'DisplayName', 'Erro Coluna 1 (Azimute)');
hold on;
plot(erro_AP1_col2, 'x-', 'DisplayName', 'Erro Coluna 2 (Elevação)');
xlabel('Índice');
ylabel('Erro Absoluto');
title('Erro Absoluto para AP1');
legend('show');
grid on;

% Gráfico de erros para AP2
subplot(2, 2, 2);
plot(erro_AP2_col1, 'o-', 'DisplayName', 'Erro Coluna 1 (Azimute)');
hold on;
plot(erro_AP2_col2, 'x-', 'DisplayName', 'Erro Coluna 2 (Elevação)');
xlabel('Índice');
ylabel('Erro Absoluto');
title('Erro Absoluto para AP2');
legend('show');
grid on;

% Gráfico de erros para AP3
subplot(2, 2, 3);
plot(erro_AP3_col1, 'o-', 'DisplayName', 'Erro Coluna 1 (Azimute)');
hold on;
plot(erro_AP3_col2, 'x-', 'DisplayName', 'Erro Coluna 2 (Elevação)');
xlabel('Índice');
ylabel('Erro Absoluto');
title('Erro Absoluto para AP3');
legend('show');
grid on;

% Gráfico de erros para AP4
subplot(2, 2, 4);
plot(erro_AP4_col1, 'o-', 'DisplayName', 'Erro Coluna 1 (Azimute)');
hold on;
plot(erro_AP4_col2, 'x-', 'DisplayName', 'Erro Coluna 2 (Elevação)');
xlabel('Índice');
ylabel('Erro Absoluto');
title('Erro Absoluto para AP4');
legend('show');
grid on;

% Ajustar o layout do gráfico
sgtitle('Gráficos de Erro Absoluto dos DOAs entre Bases de Dados');

% Inicializar a figura para o histograma do azimute
figure;

% Plotar o histograma dos erros absolutos do Azimute de todos os APs
subplot(1, 2, 1); % Subplot para organizar os gráficos
histogram(erro_AP1_col1, 'BinWidth', 1, 'DisplayStyle', 'stairs', 'EdgeColor', 'b', 'LineWidth', 1.5); % AP1 em azul
hold on;
histogram(erro_AP2_col1, 'BinWidth', 1, 'DisplayStyle', 'stairs', 'EdgeColor', 'r', 'LineWidth', 1.5); % AP2 em vermelho
histogram(erro_AP3_col1, 'BinWidth', 1, 'DisplayStyle', 'stairs', 'EdgeColor', 'g', 'LineWidth', 1.5); % AP3 em verde
histogram(erro_AP4_col1, 'BinWidth', 1, 'DisplayStyle', 'stairs', 'EdgeColor', 'm', 'LineWidth', 1.5); % AP4 em magenta

% Configurar os rótulos e título para o gráfico de azimute
xlabel('Erro Absoluto do Azimute (Graus)');
ylabel('Frequência');
title('Histograma dos Erros Absolutos do Azimute para APs 1, 2, 3 e 4');
legend({'AP1 (Azul)', 'AP2 (Vermelho)', 'AP3 (Verde)', 'AP4 (Magenta)'});
grid on;

% Inicializar a figura para o histograma da elevação
subplot(1, 2, 2); % Subplot para organizar os gráficos
histogram(erro_AP1_col2, 'BinWidth', 1, 'DisplayStyle', 'stairs', 'EdgeColor', 'c', 'LineWidth', 1.5); % AP1 em ciano
hold on;
histogram(erro_AP2_col2, 'BinWidth', 1, 'DisplayStyle', 'stairs', 'EdgeColor', 'y', 'LineWidth', 1.5); % AP2 em amarelo
histogram(erro_AP3_col2, 'BinWidth', 1, 'DisplayStyle', 'stairs', 'EdgeColor', 'k', 'LineWidth', 1.5); % AP3 em preto
histogram(erro_AP4_col2, 'BinWidth', 1, 'DisplayStyle', 'stairs', 'EdgeColor', [0.5 0 0.5], 'LineWidth', 1.5); % AP4 em púrpura escura

% Configurar os rótulos e título para o gráfico de elevação
xlabel('Erro Absoluto da Elevação (Graus)');
ylabel('Frequência');
title('Histograma dos Erros Absolutos da Elevação para APs 1, 2, 3 e 4');
legend({'AP1 (Ciano)', 'AP2 (Amarelo)', 'AP3 (Preto)', 'AP4 (Púrpura)'});
grid on;

% Ajustar visualização
hold off;


% Configurar os dados para o gráfico
APs = {'AP1', 'AP2', 'AP3', 'AP4'};
azimuth_errors = [error_AP1(1), error_AP2(1), error_AP3(1), error_AP4(1)];
elevation_errors = [error_AP1(2), error_AP2(2), error_AP3(2), error_AP4(2)];

% Inicializar a figura para o gráfico de barras
figure;

% Plotar o gráfico de barras para o erro absoluto médio
bar_data = [azimuth_errors; elevation_errors]';
bar(bar_data);

% Configurar os rótulos e título
set(gca, 'XTickLabel', APs);
xlabel('Ponto de Acesso');
ylabel('Erro Absoluto Médio (Graus)');
title('Erro Absoluto Médio de Azimute e Elevação para cada AP');
legend({'Azimute', 'Elevação'}, 'Location', 'Best');
grid on;

% Inicializar a figura para o CDF do azimute
figure;

% Cálculo da CDF dos erros absolutos do Azimute para todos os APs
[sorted_err_AP1_col1, cdf_AP1_col1] = ecdf(erro_AP1_col1);
[sorted_err_AP2_col1, cdf_AP2_col1] = ecdf(erro_AP2_col1);
[sorted_err_AP3_col1, cdf_AP3_col1] = ecdf(erro_AP3_col1);
[sorted_err_AP4_col1, cdf_AP4_col1] = ecdf(erro_AP4_col1);

% Plotar o CDF do azimute
plot(sorted_err_AP1_col1, cdf_AP1_col1, 'b', 'DisplayName', 'AP1');
hold on;
plot(sorted_err_AP2_col1, cdf_AP2_col1, 'r', 'DisplayName', 'AP2');
plot(sorted_err_AP3_col1, cdf_AP3_col1, 'g', 'DisplayName', 'AP3');
plot(sorted_err_AP4_col1, cdf_AP4_col1, 'm', 'DisplayName', 'AP4');

% Configurar os rótulos e título para o gráfico de azimute
xlabel('Erro Absoluto do Azimute (Graus)');
ylabel('CDF');
title('CDF dos Erros Absolutos do Azimute para APs 1, 2, 3 e 4');
legend('show');
grid on;

% Inicializar a figura para o CDF da elevação
figure;

% Cálculo da CDF dos erros absolutos da Elevação para todos os APs
[sorted_err_AP1_col2, cdf_AP1_col2] = ecdf(erro_AP1_col2);
[sorted_err_AP2_col2, cdf_AP2_col2] = ecdf(erro_AP2_col2);
[sorted_err_AP3_col2, cdf_AP3_col2] = ecdf(erro_AP3_col2);
[sorted_err_AP4_col2, cdf_AP4_col2] = ecdf(erro_AP4_col2);

% Plotar o CDF da elevação
plot(sorted_err_AP1_col2, cdf_AP1_col2, 'b', 'DisplayName', 'AP1');
hold on;
plot(sorted_err_AP2_col2, cdf_AP2_col2, 'r', 'DisplayName', 'AP2');
plot(sorted_err_AP3_col2, cdf_AP3_col2, 'g', 'DisplayName', 'AP3');
plot(sorted_err_AP4_col2, cdf_AP4_col2, 'm', 'DisplayName', 'AP4');

% Configurar os rótulos e título para o gráfico de elevação
xlabel('Erro Absoluto da Elevação (Graus)');
ylabel('CDF');
title('CDF dos Erros Absolutos da Elevação para APs 1, 2, 3 e 4');
legend('show');
grid on;
