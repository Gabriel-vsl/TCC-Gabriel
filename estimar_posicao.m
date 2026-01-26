% Carregar os dados
data1 = load('resultados_0dbm_usuarios_DOA.mat');
data2 = load('resultados_15dbm_usuarios_DOA.mat');
rng(39); % Você pode usar qualquer valor para garantir a reprodutibilidade


% Extrair resultados das bases de dados
resultados1 = data1.resultados_usuarios;
resultados2 = data2.resultados_usuarios;

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

% Verificar se temos o mesmo número de dados para cada AP na primeira base de dados
max_size1 = max([size(doa_AP1_1, 1), size(doa_AP2_1, 1), size(doa_AP3_1, 1), size(doa_AP4_1, 1)]);
doa_AP1_1 = padarray(doa_AP1_1, [max_size1 - size(doa_AP1_1, 1), 0], 'replicate', 'post');
doa_AP2_1 = padarray(doa_AP2_1, [max_size1 - size(doa_AP2_1, 1), 0], 'replicate', 'post');
doa_AP3_1 = padarray(doa_AP3_1, [max_size1 - size(doa_AP3_1, 1), 0], 'replicate', 'post');
doa_AP4_1 = padarray(doa_AP4_1, [max_size1 - size(doa_AP4_1, 1), 0], 'replicate', 'post');

% Concatenar dados DOA da primeira base de dados
X1 = [doa_AP1_1, doa_AP2_1, doa_AP3_1, doa_AP4_1];
X1 = normalize(X1);
Y1 = posicoes1;

% Dividir os dados da primeira base de dados em conjunto de treinamento e teste
cv1 = cvpartition(size(X1, 1), 'HoldOut', 0.2);
idx1 = cv1.test;

X_train1 = X1(~idx1, :);
Y_train1 = Y1(~idx1, :);
X_test1 = X1(idx1, :);
Y_test1 = Y1(idx1, :);

% Inicializar variáveis para armazenar erros e R^2 para a primeira base de dados
k_values = 1:10;
erros_medios1 = zeros(length(k_values), 1);
R2_x1 = zeros(length(k_values), 1);
R2_y1 = zeros(length(k_values), 1);
R2_z1 = zeros(length(k_values), 1);

% Testar diferentes valores de K para a primeira base de dados
for k = k_values
    Mdl_x1 = fitcknn(X_train1, Y_train1(:, 1), 'NumNeighbors', k);
    Mdl_y1 = fitcknn(X_train1, Y_train1(:, 2), 'NumNeighbors', k);
    Mdl_z1 = fitcknn(X_train1, Y_train1(:, 3), 'NumNeighbors', k);

    Y_pred_x1 = predict(Mdl_x1, X_test1);
    Y_pred_y1 = predict(Mdl_y1, X_test1);
    Y_pred_z1 = predict(Mdl_z1, X_test1);
    Y_pred1 = [Y_pred_x1, Y_pred_y1, Y_pred_z1];

    erro1 = sqrt(sum((Y_test1 - Y_pred1).^2, 2));
    erros_medios1(k) = mean(erro1);

    SS_res_x1 = sum((Y_test1(:, 1) - Y_pred_x1).^2);
    SS_res_y1 = sum((Y_test1(:, 2) - Y_pred_y1).^2);
    SS_res_z1 = sum((Y_test1(:, 3) - Y_pred_z1).^2);

    SS_tot_x1 = sum((Y_test1(:, 1) - mean(Y_test1(:, 1))).^2);
    SS_tot_y1 = sum((Y_test1(:, 2) - mean(Y_test1(:, 2))).^2);
    SS_tot_z1 = sum((Y_test1(:, 3) - mean(Y_test1(:, 3))).^2);

    R2_x1(k) = 1 - (SS_res_x1 / SS_tot_x1);
    R2_y1(k) = 1 - (SS_res_y1 / SS_tot_y1);
    R2_z1(k) = 1 - (SS_res_z1 / SS_tot_z1);
end

% Encontrar o K com o menor erro médio para a primeira base de dados
[menor_erro1, melhor_k1] = min(erros_medios1);

% Exibir o K com o menor erro médio e o valor do erro para a primeira base de dados
disp('Primeira base de dados:');
disp(['Melhor valor de K: ', num2str(melhor_k1)]);
disp(['Menor erro médio: ', num2str(menor_erro1), ' metros']);
disp(['R^2 para X: ', num2str(R2_x1(melhor_k1))]);
disp(['R^2 para Y: ', num2str(R2_y1(melhor_k1))]);
disp(['R^2 para Z: ', num2str(R2_z1(melhor_k1))]);

% Verificar se temos o mesmo número de dados para cada AP na segunda base de dados
max_size2 = max([size(doa_AP1_2, 1), size(doa_AP2_2, 1), size(doa_AP3_2, 1), size(doa_AP4_2, 1)]);
doa_AP1_2 = padarray(doa_AP1_2, [max_size2 - size(doa_AP1_2, 1), 0], 'replicate', 'post');
doa_AP2_2 = padarray(doa_AP2_2, [max_size2 - size(doa_AP2_2, 1), 0], 'replicate', 'post');
doa_AP3_2 = padarray(doa_AP3_2, [max_size2 - size(doa_AP3_2, 1), 0], 'replicate', 'post');
doa_AP4_2 = padarray(doa_AP4_2, [max_size2 - size(doa_AP4_2, 1), 0], 'replicate', 'post');

% Concatenar dados DOA da segunda base de dados
X2 = [doa_AP1_2, doa_AP2_2, doa_AP3_2, doa_AP4_2];
X2 = normalize(X2);
Y2 = posicoes2;

% Dividir os dados da segunda base de dados em conjunto de treinamento e teste
cv2 = cvpartition(size(X2, 1), 'HoldOut', 0.2);
idx2 = cv2.test;

X_train2 = X2(~idx2, :);
Y_train2 = Y2(~idx2, :);
X_test2 = X2(idx2, :);
Y_test2 = Y2(idx2, :);

% Inicializar variáveis para armazenar erros e R^2 para a segunda base de dados
erros_medios2 = zeros(length(k_values), 1);
R2_x2 = zeros(length(k_values), 1);
R2_y2 = zeros(length(k_values), 1);
R2_z2 = zeros(length(k_values), 1);

% Testar diferentes valores de K para a segunda base de dados
for k = k_values
    Mdl_x2 = fitcknn(X_train2, Y_train2(:, 1), 'NumNeighbors', k);
    Mdl_y2 = fitcknn(X_train2, Y_train2(:, 2), 'NumNeighbors', k);
    Mdl_z2 = fitcknn(X_train2, Y_train2(:, 3), 'NumNeighbors', k);

    Y_pred_x2 = predict(Mdl_x2, X_test2);
    Y_pred_y2 = predict(Mdl_y2, X_test2);
    Y_pred_z2 = predict(Mdl_z2, X_test2);
    Y_pred2 = [Y_pred_x2, Y_pred_y2, Y_pred_z2];

    erro2 = sqrt(sum((Y_test2 - Y_pred2).^2, 2));
    erros_medios2(k) = mean(erro2);

    SS_res_x2 = sum((Y_test2(:, 1) - Y_pred_x2).^2);
    SS_res_y2 = sum((Y_test2(:, 2) - Y_pred_y2).^2);
    SS_res_z2 = sum((Y_test2(:, 3) - Y_pred_z2).^2);

    SS_tot_x2 = sum((Y_test2(:, 1) - mean(Y_test2(:, 1))).^2);
    SS_tot_y2 = sum((Y_test2(:, 2) - mean(Y_test2(:, 2))).^2);
    SS_tot_z2 = sum((Y_test2(:, 3) - mean(Y_test2(:, 3))).^2);

    R2_x2(k) = 1 - (SS_res_x2 / SS_tot_x2);
    R2_y2(k) = 1 - (SS_res_y2 / SS_tot_y2);
    R2_z2(k) = 1 - (SS_res_z2 / SS_tot_z2);
end

% Encontrar o K com o menor erro médio para a segunda base de dados
[menor_erro2, melhor_k2] = min(erros_medios2);

% Exibir o K com o menor erro médio e o valor do erro para a segunda base de dados
disp('Segunda base de dados:');
disp(['Melhor valor de K: ', num2str(melhor_k2)]);
disp(['Menor erro médio: ', num2str(menor_erro2), ' metros']);
disp(['R^2 para X: ', num2str(R2_x2(melhor_k2))]);
disp(['R^2 para Y: ', num2str(R2_y2(melhor_k2))]);
disp(['R^2 para Z: ', num2str(R2_z2(melhor_k2))]);


% Calcular o MAE (Mean Absolute Error) para cada predição
mae_x1 = abs(Y_test1(:, 1) - Y_pred_x1);
mae_y1 = abs(Y_test1(:, 2) - Y_pred_y1);
mae_z1 = abs(Y_test1(:, 3) - Y_pred_z1);

mae_x2 = abs(Y_test2(:, 1) - Y_pred_x2);
mae_y2 = abs(Y_test2(:, 2) - Y_pred_y2);
mae_z2 = abs(Y_test2(:, 3) - Y_pred_z2);

% Calcular o MAE total para cada predição
mae_total1 = mean([mae_x1, mae_y1, mae_z1], 2);
mae_total2 = mean([mae_x2, mae_y2, mae_z2], 2);

% Calcular o MAPE (Mean Absolute Percentage Error) para cada predição
mape_x1 = abs((Y_test1(:, 1) - Y_pred_x1) ./ Y_test1(:, 1)) * 100;
mape_y1 = abs((Y_test1(:, 2) - Y_pred_y1) ./ Y_test1(:, 2)) * 100;
mape_z1 = abs((Y_test1(:, 3) - Y_pred_z1) ./ Y_test1(:, 3)) * 100;

mape_x2 = abs((Y_test2(:, 1) - Y_pred_x2) ./ Y_test2(:, 1)) * 100;
mape_y2 = abs((Y_test2(:, 2) - Y_pred_y2) ./ Y_test2(:, 2)) * 100;
mape_z2 = abs((Y_test2(:, 3) - Y_pred_z2) ./ Y_test2(:, 3)) * 100;

% Calcular o MAPE total para cada predição
mape_total1 = mean([mape_x1, mape_y1, mape_z1], 2);
mape_total2 = mean([mape_x2, mape_y2, mape_z2], 2);


% Plotar o gráfico de CDF para MAPE com resultados das duas bases de dados
figure;
hold on;
sorted_erros1 = sort(erros_medios1);
cdf_erros1 = (1:length(sorted_erros1)) / length(sorted_erros1);
plot(sorted_erros1, cdf_erros1, '-o', 'DisplayName', '0 dBm');

sorted_erros2 = sort(erros_medios2);
cdf_erros2 = (1:length(sorted_erros2)) / length(sorted_erros2);
plot(sorted_erros2, cdf_erros2, '-x', 'DisplayName', '15 dBm');

xlabel('RMSE (m)');
ylabel('CDF');
title('CDF para RMSE');
legend('show');
grid on;
hold off;


% Calcular a CDF para MAE
[mae_cdf_1, mae_x_values_1] = ecdf(mae_total1);
[mae_cdf_2, mae_x_values_2] = ecdf(mae_total2);

% Calcular a CDF para MAPE
[mape_cdf_1, mape_x_values_1] = ecdf(mape_total1);
[mape_cdf_2, mape_x_values_2] = ecdf(mape_total2);

% Plotar o gráfico de CDF para MAE
figure;
plot(mae_x_values_1, mae_cdf_1, '-o', 'DisplayName', '0 dBm', 'LineWidth', 2);
hold on;
plot(mae_x_values_2, mae_cdf_2, '-x', 'DisplayName', '15 dBm', 'LineWidth', 2);
title('CDF para MAE');
xlabel('MAE (m)');
ylabel('CDF');
legend show;
grid on;



% Plotar o gráfico de CDF para MAPE
figure;
plot(mape_x_values_1, mape_cdf_1, '-o', 'DisplayName', '0 dBm', 'LineWidth', 2);
hold on;
plot(mape_x_values_2, mape_cdf_2, '-x', 'DisplayName', '15 dBm', 'LineWidth', 2);
title('CDF para MAPE');
xlabel('MAPE (%)');
ylabel('CDF');
legend show;
grid on;





% Calcular os percentis (10, 50, 90) para MAE na primeira base de dados
percentil_10_mae1 = prctile(mae_total1, 10);
percentil_50_mae1 = prctile(mae_total1, 50);
percentil_90_mae1 = prctile(mae_total1, 90);

% Calcular os percentis (10, 50, 90) para MAE na segunda base de dados
percentil_10_mae2 = prctile(mae_total2, 10);
percentil_50_mae2 = prctile(mae_total2, 50);
percentil_90_mae2 = prctile(mae_total2, 90);

% Exibir os valores dos percentis no console para a primeira base de dados
disp('Primeira base de dados:');
disp(['MAE no percentil 10: ', num2str(percentil_10_mae1), ' metros']);
disp(['MAE no percentil 50: ', num2str(percentil_50_mae1), ' metros']);
disp(['MAE no percentil 90: ', num2str(percentil_90_mae1), ' metros']);

% Exibir os valores dos percentis no console para a segunda base de dados
disp('Segunda base de dados:');
disp(['MAE no percentil 10: ', num2str(percentil_10_mae2), ' metros']);
disp(['MAE no percentil 50: ', num2str(percentil_50_mae2), ' metros']);
disp(['MAE no percentil 90: ', num2str(percentil_90_mae2), ' metros']);

% Função para plotar o MAE total em função dos percentis
function plot_mae_percentiles(mae_total1, mae_total2)
    % Calcular os percentis (10, 50, 90) para MAE na primeira base de dados
    percentis = [10, 50, 90];
    percentil_mae1 = prctile(mae_total1, percentis);
    
    % Calcular os percentis (10, 50, 90) para MAE na segunda base de dados
    percentil_mae2 = prctile(mae_total2, percentis);
    
    % Criar a figura para o gráfico
    figure;
    
    % Plotar os percentis de MAE para a primeira base de dados
    plot(percentis, percentil_mae1, '-o', 'DisplayName', '0 dBm');
    hold on;
    
    % Plotar os percentis de MAE para a segunda base de dados
    plot(percentis, percentil_mae2, '-x', 'DisplayName', '15 dBm');
    
    % Adicionar título e rótulos aos eixos
    title('Percentis do MAE Total');
    xlabel('Percentil');
    ylabel('MAE (m)');
    
    % Adicionar uma legenda para identificar as bases de dados
    legend;
    
    % Exibir o grid para facilitar a leitura dos dados
    grid on;
    
    % Segurar a figura para mais plots, se necessário
    hold off;
end

% Chamar a função para plotar os percentis do MAE total
plot_mae_percentiles(mae_total1, mae_total2);

% Plotar o gráfico de RMSE para a primeira base de dados
figure;
plot(k_values, erros_medios1, '-o',  'DisplayName', '0 dBm', 'LineWidth', 2);
hold on;
plot(k_values, erros_medios2, '-x',  'DisplayName', '15 dBm', 'LineWidth', 2);
title('RMSE vs. K-vizinhos');
xlabel('K-vizinhos');
ylabel('RMSE (m)');
legend;
grid on;

% Plotar o gráfico de R^2 para a primeira base de dados
figure;
hold on;
plot(k_values, R2_x1, '-x', 'DisplayName', 'X - 0 dBm');
plot(k_values, R2_y1, '-x', 'DisplayName', 'Y - 0 dBm');
plot(k_values, R2_z1, '-x', 'DisplayName', 'Z - 0 dBm');
hold on;
plot(k_values, R2_x2, '-o', 'DisplayName', 'X - 15 dBm');
plot(k_values, R2_y2, '-o', 'DisplayName', 'Y - 15 dBm');
plot(k_values, R2_z2, '-o', 'DisplayName', 'Z - 15 dBm');
title('R^2 vs. K-Vizinhos');
xlabel('K-vizinhos');
ylabel('R^2');
legend('show');
grid on;
hold off;


% Função para plotar o gráfico de CDF para R^2
function plot_r2_cdf(R2_x1, R2_y1, R2_z1, R2_x2, R2_y2, R2_z2)
    % Calcular a CDF para R^2 na primeira base de dados
    [r2_cdf_x1, r2_x_values_x1] = ecdf(R2_x1);
    [r2_cdf_y1, r2_y_values_x1] = ecdf(R2_y1);
    [r2_cdf_z1, r2_z_values_x1] = ecdf(R2_z1);

    % Calcular a CDF para R^2 na segunda base de dados
    [r2_cdf_x2, r2_x_values_x2] = ecdf(R2_x2);
    [r2_cdf_y2, r2_y_values_x2] = ecdf(R2_y2);
    [r2_cdf_z2, r2_z_values_x2] = ecdf(R2_z2);

    % Plotar o gráfico de CDF para R^2
    figure;
    hold on;

    % Plotar a CDF para R^2 X
    plot(r2_x_values_x1, r2_cdf_x1, '-o', 'DisplayName', 'Base de Dados 1 - X', 'LineWidth', 2);
    plot(r2_x_values_x2, r2_cdf_x2, '-x', 'DisplayName', 'Base de Dados 2 - X', 'LineWidth', 2);

    % Plotar a CDF para R^2 Y
    plot(r2_y_values_x1, r2_cdf_y1, '--o', 'DisplayName', 'Base de Dados 1 - Y', 'LineWidth', 2);
    plot(r2_y_values_x2, r2_cdf_y2, '--x', 'DisplayName', 'Base de Dados 2 - Y', 'LineWidth', 2);

    % Plotar a CDF para R^2 Z
    plot(r2_z_values_x1, r2_cdf_z1, ':o', 'DisplayName', 'Base de Dados 1 - Z', 'LineWidth', 2);
    plot(r2_z_values_x2, r2_cdf_z2, ':x', 'DisplayName', 'Base de Dados 2 - Z', 'LineWidth', 2);

    % Adicionar título e rótulos aos eixos
    title('CDF para R^2');
    xlabel('R^2');
    ylabel('CDF');

    % Adicionar uma legenda para identificar as bases de dados e coordenadas
    legend('show');

    % Exibir o grid para facilitar a leitura dos dados
    grid on;

    % Segurar a figura para mais plots, se necessário
    hold off;
end

% Chamar a função para plotar o gráfico de CDF para R^2
plot_r2_cdf(R2_x1, R2_y1, R2_z1, R2_x2, R2_y2, R2_z2);
