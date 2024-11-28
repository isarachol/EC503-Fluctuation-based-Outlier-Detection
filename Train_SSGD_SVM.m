% Perform stochastic sub-gradient descend on SVM algorithm
% inputs: training data, testing data, two labels of interest
% outputs: theta, y_predictions for training andn testing data
% COST, CCR for training and testing data, and iterations
% Add these if need to test => y_test_pred, CCR_test, = X_test, Y_test, 

function [theta, y_train_pred, COST, CCR_train, iteration_x] = Train_SSGD_SVM(X_train, Y_train, y1, y2)
X_1 = X_train(Y_train==y1,:);
X_2 = X_train(Y_train==y2,:);

X_in = [X_1;X_2];
Y_in = [-1*ones(size(X_1,1),1);+1*ones(size(X_2,1),1)];
X_in_ext = [X_in,ones(length(X_in),1)];


% X_f1f2_TEST = [X_test(Y_test==y1,:);X_test(Y_test==y2,:)];
% Y_f1f2_TEST = [-1*ones(length(X_test(Y_test==y1,:)),1);+1*ones(length(X_test(Y_test==y2,:)),1)];
% X_12_test_ext = [X_f1f2_TEST,ones(length(X_f1f2_TEST),1)];

t_max = 400000; %400000
c = 0.5; %0.5;
[~,dim] = size(X_train);
w = zeros(dim,1);
b = 0;
theta = [w;b];

COST      = [];
CCR_train = [];
% CCR_test  = [];
iteration_x = [];

for iii = 1:t_max
    % current iteration index
    t = iii; 

    % choose sample index:
    j_current = randi([1,length(X_in)]);
    x_current = X_in(j_current,:);
    x_current_ext = [x_current';1];
    y_current = Y_in(j_current);

    % compute subgradient:
    v = [w;0];
    if y_current*theta'*x_current_ext < 1
        v = v - length(X_in)*c*y_current*x_current_ext;
    end

    % update parameters:
    eta = 0.2/t; %0.2/t; %s_t

    theta = theta - eta*v;

    % redefine parameters    
    w = theta(1:dim,1);
    w = w(:);
    b = theta(end);

    if (mod(t,1000) == 0)
        iteration_x = [iteration_x, t];

        % Cost function:
        condition_train = double((X_in_ext*theta).*Y_in>0);
        cost = 1/2*norm(w)^2 + c*sum(max(0, 1-condition_train));
        COST = [COST, cost/length(X_in)];

        % Training CCR:
        ccr_train = 1/length(X_in)*sum(condition_train);
        sign_train = X_in_ext*theta;
        y_train_pred = ones(length(sign_train), 1);
        y_train_pred(sign_train<0) = -1;
        CCR_train = [CCR_train, ccr_train];

        % Test CCR:
        % condition_test = double((X_12_test_ext*theta).*Y_f1f2_TEST>0);
        % ccr_test = 1/length(X_12_test_ext)*sum(condition_test);
        % sign_test = X_12_test_ext*theta;
        % y_test_pred = ones(length(sign_test), 1);
        % y_test_pred(sign_test<0) = -1;
        % CCR_test = [CCR_test, ccr_test];
    end

end

% w = theta(1:dim,1);
% w = w(:);
% b = theta(end);
% 
% disp('Final w and b:')
% disp(w)
% disp(b)

%%%%%%%%%%%%%%%%
% Visualize separating hyperplane between the two classes:

% add separating line:
% figure; 
% gscatter(X_in(:,2), X_in(:,5), Y_in); 
% xlabel('Feature 1'); 
% ylabel('Feature 2');
% title(strcat('Classes ',num2str(y1),', ',num2str(y2))); 
% grid on; 
% hold on;
% 
% w1 = w(2); w2 = w(5);
% b = b;
% 
% x_space = min(X_in(:,1)):0.05:max(X_in(:,1));
% y_space = -w1/w2*x_space - b/w2;
% 
% plot(x_space,y_space)
% legend(num2str(y1),num2str(y2),strcat('h_{SVM,',num2str(y1),',',num2str(y2),'} (x_2,x_4) = 0'),...
%     'Location','northeastoutside')
%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOTS and SUMMARIZING VALUES FOR CLASSES 1,2 PAIR %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Plot cost
% figure;
% plot(iteration_x,COST); 
% xlabel('Iterations'); 
% ylabel('Sample normalized cost');
% title(strcat('Cost for ',num2str(y1),'-',num2str(y2),' pair: ')); 
% grid on;
% 
% % Plot train ccr
% figure; 
% plot(iteration_x,CCR_train); 
% xlabel('Iterations'); 
% ylabel('Train CCR');
% title(strcat('Train CCR for ',num2str(y1),'-',num2str(y2),' pair: ')); 
% grid on;

% Plot test ccr
% figure; 
% plot(iteration_x,CCR_test); 
% xlabel('Iterations'); 
% ylabel('Test CCR');
% title(strcat('Test CCR for ',num2str(y1),'-',num2str(y2),' pair: ')); 
% grid on;

% final values
% fprintf('\n\n\n\n')
% disp(strcat('Summary of values for ',num2str(y1),'-',num2str(y2),' pair: '))
% disp('Theta: '), disp(theta),
% theta = theta;
% disp('Train CCR: '), disp(CCR_train(end)),
% disp('Test CCR: '), disp(CCR_test(end)),
% disp('Train Confusion Matrix: '), confusionmat(y_train_pred,Y_in)
% disp('Test Confusion Matrix: '), confusionmat(y_test_pred,Y_f1f2_TEST)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
