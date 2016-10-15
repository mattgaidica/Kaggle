% trainSet = 2;
figure;
maxFiles = 36;
for trainSet = 1:3
    h = waitbar(0,['training set ',num2str(trainSet)]);
    xs_0 = [];
    ys_0 = [];
    xs_1 = [];
    ys_1 = [];
    session = 1;
    for iFile = 1:maxFiles
        waitbar(iFile/maxFiles,h);
        filePath = ['/Users/mattgaidica/Dropbox/Projects/Kaggle/train',num2str(trainSet),'/',num2str(trainSet),'_',num2str(iFile),'_0.mat'];
        load(filePath);
        data_0 = dataStruct.data;
        filePath = ['/Users/mattgaidica/Dropbox/Projects/Kaggle/train',num2str(trainSet),'/',num2str(trainSet),'_',num2str(iFile),'_1.mat'];
        load(filePath);
        data_1 = dataStruct.data;

        curSeq = dataStruct.sequence;
        fpass = [13 30];
        res_0 = [];
        res_1 = [];
        for iCh=1:16
            fdata_00 = eegfilt(data_0(:,iCh)',400,13,30);
            fdata_01 = eegfilt(data_0(:,iCh)',400,50,100);
            fdata_10 = eegfilt(data_1(:,iCh)',400,13,30);
            fdata_11 = eegfilt(data_1(:,iCh)',400,50,100);
            
            x_00 = hilbert(fdata_00);
            x_01 = hilbert(fdata_01);
            x_10 = hilbert(fdata_10);
            x_11 = hilbert(fdata_11);

%             res_0(iCh,:) = normalize(real(x_00).*imag(x_00)).*normalize(real(x_01).*imag(x_01));
%             res_1(iCh,:) = normalize(real(x_10).*imag(x_10)).*normalize(real(x_11).*imag(x_11));
            res_0(iCh,:) = (real(x_01).*imag(x_01));
            res_1(iCh,:) = (real(x_11).*imag(x_11));
        end
        res_0 = mean(res_0,1);
        res_1 = mean(res_1,1);

        xs_0(curSeq,session) = mean(res_0);
        ys_0(curSeq,session) = std(res_0);
        xs_1(curSeq,session) = mean(res_1);
        ys_1(curSeq,session) = std(res_1);

        if curSeq == 6
            session = session + 1;
        end
    end
    close(h);

%     subplot(3,1,trainSet);
%     hold on;
%     errorbar(mean(xs_0,2),mean(ys_0,2));
%     errorbar(mean(xs_1,2),mean(ys_1,2));
    
    meanId = 1;
    subplot(3,1,trainSet);
    hold on;
    errorbar(mean(ys_0,meanId),std(ys_0,0,meanId));
    errorbar(mean(ys_1,meanId),std(ys_1,0,meanId));
    
    title(num2str(trainSet));
end

% figure;
% hold on;
% errorbar(mean(xs_0,1),mean(ys_0,1));
% errorbar(mean(xs_1,1),mean(ys_1,1));
% 
% figure;
% for ii=1:6
%     subplot(1,6,ii);
%     hold on;
%     for jj=1:size(xs_0,2)
%         plot(xs_0(ii,jj),ys_0(ii,jj),'.r','color','blue','MarkerSize',15);
%         plot(xs_1(ii,jj),ys_1(ii,jj),'.r','color','red','MarkerSize',15);
%         xlabel('Herbert resultant');
%         ylabel('std');
%         title(num2str(ii));
%     end
% end
%     

% load('/Users/mattgaidica/Dropbox/Projects/Kaggle EEG/1_47_0.mat');
% data_0 = dataStruct.data;
% load('/Users/mattgaidica/Dropbox/Projects/Kaggle EEG/1_47_1.mat')
% data_1 = dataStruct.data;
% 
% h1 = figure;
% for ii=1:16
%     subplot(4,4,ii);
%     hold on;
%     fdata_0 = eegfilt(data_0(:,ii)',400,13,30);
%     fdata_1 = eegfilt(data_1(:,ii)',400,13,30);
%     x_0 = hilbert(fdata_0);
%     x_1 = hilbert(fdata_1);
% 
%     plot(smooth(abs(real(x_0).*imag(x_0)),4000));
%     plot(smooth(abs(real(x_1).*imag(x_1)),4000));
%     xlim([0 length(x_0)]);
% end

% fdata_0 = eegfilt(data_0,400,13,30);
% fdata_1 = eegfilt(data_1,400,13,30);
% 
% x_0 = hilbert(fdata_0);
% x_1 = hilbert(fdata_1);
% 
% ns = 1000;
% figure;
% plot(smooth(x_0,ns));
% hold on;
% plot(smooth(x_1,ns));

% ns = 5000;
% figure;
% plot(smooth(abs(x_0),ns));
% hold on;
% plot(smooth(abs(x_1),ns));