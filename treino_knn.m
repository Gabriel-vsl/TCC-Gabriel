clear;
close all;
clc;

% Parâmetros de intervalo e passo
x_start = -14.7;
x_end = 14.7;
y_start = -4.9;
y_end = 15.9;
z_start = 0.2;
z_end = 2.8;
stepz = 0.6;
stepy = 2.6;
stepx = 2.1;

% Geração dos vetores de posição
x_range = x_start:stepx:x_end;
y_range = y_start:stepy:y_end;
z_range = z_start:stepz:z_end;

% Inicialize as listas de resultados
resultados_doas_list = {};
resultados_ap_list = {};
resultados_posicao_list = {};

% Inicialize a célula para armazenar os resultados DOA, APs e posições do usuário
resultados_usuarios = cell(0, 3);
resultados_teoricos = cell(0, 3);

% Scenario 
mapFileName = "ambientev2.stl";
fc = 60e9;
c = physconst("LightSpeed");
lambda = c / fc;
powerdBm = 0;

% Configuração do canal
subcarrierSpacing = power(2, 4) * 15e3;
fftlen = power(2, 11);

% Configuração do array
antenna = phased.IsotropicAntennaElement('FrequencyRange', [100e6 4 * fc]);
userArray = arrayConfig("Size", [1, 1], "ElementSpacing", lambda / 2); % User
apArray = phased.URA('Element', antenna, 'Size', [8 8], 'ElementSpacing', [lambda / 2 lambda / 2]); %AP

apPosition1 = [-1; 12; 2.8];  %% Sala menor
apPosition2 = [-8; 9.5; 2.8]; %% Corredor maior
apPosition3 = [-13; 8; 2.8];  %% Corredor menor
apPosition4 = [0; 0; 2.8];    %% Centro

ap1 = rxsite("cartesian", "Antenna", apArray, "AntennaPosition", apPosition1);
ap2 = rxsite("cartesian", "Antenna", apArray, "AntennaPosition", apPosition2);
ap3 = rxsite("cartesian", "Antenna", apArray, "AntennaPosition", apPosition3);
ap4 = rxsite("cartesian", "Antenna", apArray, "AntennaPosition", apPosition4);

% Inicialize o siteviewer
siteviewer("SceneModel", mapFileName);
ap_positions = {apPosition1, apPosition2, apPosition3, apPosition4};
for i = 1:4
    ap_position = ap_positions{i};
    ap_instance = rxsite("cartesian", "Antenna", apArray, "AntennaPosition", ap_position);
    show(ap_instance, "ShowAntennaHeight", false);
end

% Itere sobre as diferentes posições do usuário
for x_user = x_range
    for y_user = y_range
        for z_user = z_range
            userPosition = [x_user; y_user; z_user];
            user = txsite("cartesian", "Antenna", userArray, "AntennaPosition", userPosition, 'TransmitterFrequency', fc);
            show(user, "ShowAntennaHeight", false);


            % Se o usuário estiver no alcance, calcula os DOA
            %if any(inRange)
                %inRangeIndices = find(inRange);
                for idy = 1:4
                    ap_name = strcat('AP', num2str(idy));
                    apPosition = eval(sprintf('apPosition%d', idy));
                    apy = rxsite("cartesian", "Antenna", apArray, "AntennaPosition", apPosition);
                    pm2 = propagationModel("raytracing", "CoordinateSystem", "cartesian", "Method", "sbr", "AngularSeparation", "low", "MaxNumReflections", 2, "SurfaceMaterial", "wood");
                    rays2 = raytrace(user, apy, pm2);
                    rays2 = rays2{1, 1};

                    if size(rays2, 2) > 1
                        rtChan = comm.RayTracingChannel(rays2, user, apy);
                        rtChan.NormalizeImpulseResponses = false;
                        rtChan.NormalizeChannelOutputs = false;
                        rtChan.SampleRate = fftlen * subcarrierSpacing;
                        rtChan.ReceiverVirtualVelocity = [0; 0; 0];
                        rtChanInfo = info(rtChan);

                        numTx = rtChanInfo.NumTransmitElements;
                        numRx = rtChanInfo.NumReceiveElements;

                        bitsPerCarrier = 6;
                        modOrder = power(2, bitsPerCarrier);

                        cpLen = fftlen / 4;
                        numGuardBandCarrier = [9; 8];
                        pilotCarrierIdx = [numGuardBandCarrier(1) + 1:fftlen / 2 - 2, fftlen / 2 + 1:fftlen / 2 - fftlen - numGuardBandCarrier(2)]';
                        numDataCarrier = fftlen - sum(numGuardBandCarrier) - length(pilotCarrierIdx) - 1;
                        numOfdmSymbols = 2;

                        ofdmMod = comm.OFDMModulator("FFTLength", fftlen, "NumGuardBandCarriers", numGuardBandCarrier, "InsertDCNull", true, ...
                            "PilotInputPort", true, "PilotCarrierIndices", pilotCarrierIdx, "CyclicPrefixLength", cpLen, "NumSymbols", numOfdmSymbols, "NumTransmitAntennas", numTx, "Windowing", true, ...
                            "WindowLength", 32);
                        ofdmDemod = comm.OFDMDemodulator(ofdmMod);

                        numBits = bitsPerCarrier * numDataCarrier * numOfdmSymbols * numTx;
                        encBits = randi(2, numBits, 1) - 1;
                        qamSym = qammod(encBits, modOrder, ...
                            'InputType', 'bit', 'UnitAveragePower', true);
                        X = reshape(qamSym, numDataCarrier, numOfdmSymbols, numTx);

                        numBitsPilots = length(pilotCarrierIdx) * numOfdmSymbols * numTx;
                        pilots = sign(randi(2, numBitsPilots, 1) - 1.5);
                        P = reshape(pilots, length(pilotCarrierIdx), numOfdmSymbols, numTx);

                        txWave = ofdmMod(X, P);
                        scaling = sqrt(db2pow(powerdBm - 30)) * 1 / norm(txWave);
                        txWave = scaling * txWave;

                        chanIn = [txWave; zeros(fftlen + cpLen, numTx)];
                        [chanOut, CIR] = rtChan(chanIn);
                        release(rtChan);

                        receiver = phased.ReceiverPreamp('Gain', 20, ...
                            'NoiseFigure', 5, 'ReferenceTemperature', 290, ...
                            'SampleRate', rtChan.SampleRate, 'SeedSource', 'Property', 'Seed', 1e3);

                        rxSignal = receiver(chanOut);

                        estimator = phased.BeamscanEstimator2D('SensorArray', apArray, 'OperatingFrequency', fc, ...
                            'DOAOutputPort', true, 'NumSignals', 1, 'AzimuthScanAngles', -180:0.1:180, 'ElevationScanAngles', -90:0.1:90);

                        [~, doas] = estimator(chanOut);

                        resultados_usuarios{end + 1, 1} = [doas(1), doas(2)];
                        resultados_usuarios{end, 2} = ap_name;
                        resultados_usuarios{end, 3} = userPosition;
                        disp(['Resultado armazenado para a posição ', num2str(idy), 'Posicao', num2str(x_user), ', ', num2str(y_user), ', ', num2str(z_user), ')']);

                        resultados_doas_list{end + 1} = doas;
                        resultados_ap_list{end + 1} = ap_name;
                        resultados_posicao_list{end + 1} = userPosition;

                        dist_vector_teorico = userPosition - apPosition;
                        [azimuth_teorico, elevation_teorico, ~] = cart2sph(dist_vector_teorico(1), dist_vector_teorico(2), dist_vector_teorico(3));
                        az_deg_teorico = azimuth_teorico * (180 / pi);
                        ele_deg_teorico = elevation_teorico * (180 / pi);

                        resultados_teoricos{end + 1, 1} = [az_deg_teorico, ele_deg_teorico];
                        resultados_teoricos{end, 2} = ap_name;
                        resultados_teoricos{end, 3} = userPosition;


                    else
                        disp(['Nenhum raio para o Ponto de Acesso ', num2str(idy), 'Posicao', num2str(x_user), ', ', num2str(y_user), ', ', num2str(z_user), ')']);
                        resultados_usuarios{end + 1, 1} = [999, 999];
                        resultados_usuarios{end, 2} = ap_name;
                        resultados_usuarios{end, 3} = userPosition;

                        resultados_doas_list{end + 1} = [999, 999];
                        resultados_ap_list{end + 1} = ap_name;
                        resultados_posicao_list{end + 1} = userPosition;

                        resultados_teoricos{end + 1, 1} = [999, 999];
                        resultados_teoricos{end, 2} = ap_name;
                        resultados_teoricos{end, 3} = userPosition;
                    end
                end
            %else
                %disp(['O usuário está fora do alcance para a posição (x, y, z) = (', num2str(x_user), ', ', num2str(y_user), ', ', num2str(z_user), ')']);
                %resultados_usuarios{end + 1, 1} = [999, 999];
                %resultados_usuarios{end, 2} = 'None';
                %resultados_usuarios{end, 3} = userPosition;

                %resultados_doas_list{end + 1} = [999, 999];
                %resultados_ap_list{end + 1} = 'None';
                %resultados_posicao_list{end + 1} = userPosition;
            %end
        end
    end
end

% Salvar os resultados em um arquivo para uso futuro com o algoritmo k-NN
save('resultados_01_0dBm_usuarios_DOA.mat', 'resultados_usuarios');

% Salvar os resultados teóricos
save('resultados_teoricos_01_0dBm_usuarios_DOA.mat', 'resultados_teoricos');

