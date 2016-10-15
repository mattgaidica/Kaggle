submission = {};
maxFiles = [1584,2256,2286];
% maxFiles = [5,5,5];
lineCount = 1;
for testSet = 1:3
    h = waitbar(0,['training set ',num2str(testSet)]);
    xs_0 = [];
    ys_0 = [];
    xs_1 = [];
    ys_1 = [];
    session = 1;
    for iFile = 1:maxFiles(testSet)
        waitbar(iFile/maxFiles(testSet),h);
        filePath = ['C:\Users\admin\Downloads\test_',num2str(testSet),'\test_',num2str(testSet),'\',num2str(testSet),'_',num2str(iFile),'.mat'];
        load(filePath);
        data_0 = dataStruct.data;

        res_0 = [];
        for iCh=1:16
            fdata_00 = eegfilt(data_0(:,iCh)',400,50,100);
            x_00 = hilbert(fdata_00);
            res_0(iCh,:) = (real(x_00).*imag(x_00));
        end
        res_0 = mean(res_0,1);

        lineLabel = [num2str(testSet),'_',num2str(iFile),'.mat'];
        score = 0;
        if std(res_0) < 7
            score = 1;
        elseif std(res_0) < 8
            score = 0.5;
        elseif std(res_0) < 9
            score = 0.25;
        end
        submission{lineCount} = [lineLabel,',',num2str(score)];
        lineCount = lineCount + 1;
    end
    close(h);
end

T = table(submission');
writetable(T,'submission');