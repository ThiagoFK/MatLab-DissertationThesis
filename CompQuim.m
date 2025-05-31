clear
close all
clc

Composition=["%C","%Si","%Mn","%P","%S","%Cr","%Nb","%Ti","%Ni","%Mo","%N"];
Um4512=[0.01,0.55,0.39,0.02,0.001,11.47,0.008,0.240,0.140,0.035,0.012;
        0.011,0.63,0.31,0.024,0.001,11.44,0.008,0.190,0.210,0.035,0.010];
Um4509=[0.014,0.50,0.31,0.025,0.001,17.82,0.37,0.14,0.250,0.06,0.017;
        0.014,0.46,0.32,0.025,0.001,17.66,0.36,0.12,0.350,0.065,0.016];

figure
for i=1:2
    subplot(2,2,i)
    hold on
    grid on
    grid minor
    limitmax4512=[0.030,1,1,0.04,0.015,12.5,100,(0.65^Um4512(i,1)),100,100,100];
    limitmin4512=[0,0,0,0,0,10.5,0,6*(Um4512(i,1)+Um4512(i,11)),0,0,0];
    bar(Composition,100*(Um4512(i,:))./(limitmax4512), 'FaceColor', [0.2, 0.6, 1]);
    yline(100, 'r--', 'Maximum Amount', 'LineWidth', 1.5);
    for j=1:11
        plot(j + [-0.2 0.2], [limitmin4512(j) limitmin4512(j)], 'r-', 'LineWidth', 1.5);
    end
    xlim(["%C" "%N"])
    ylim([0 110])
    title(strcat("1.4512 Sample ",num2str(i)))
    hold off

    subplot(2,2,i+2)
    hold on
    grid on
    grid minor
    limitmax4509=[0.030,1,1,0.04,0.015,18.5,1,0.6,100,100,100];
    limitmin4509=[0,0,0,0,0,17.5,3*Um4509(i,1)+0.3,0.1,0,0,0];
    bar(Composition,100*(Um4509(i,:))./(limitmax4509), 'FaceColor', [0.2, 0.6, 1]);
    yline(100, 'r--', 'Maximum Amount', 'LineWidth', 1.5);
    xlim(["%C" "%N"])
    for j=1:11
        plot(j + [-0.2 0.2], [limitmin4509(j) limitmin4509(j)], 'r-', 'LineWidth', 1.5);
    end
    ylim([0 110])
    title(strcat("1.4509 Sample ",num2str(i)))
    hold off
end
