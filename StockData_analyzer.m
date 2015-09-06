%A set of functions which can be used to manipulate stock data from Stock Data.
% Copyright (C) 2015 Himanshu Kattelu <himanshu.kattelu@stonybrook.edu>,
% Created : 05-September-2015
% Last Modified : 05-September-2015

classdef StockData_analyzer
    %StockData_analyzer A set of functions which can be used to manipulate
    %stock data from StockData.
    %
    %Data from the Stock Data price table is organized in format:
    % Symbol|date_ex|open_price|close_price|high_price|low_price|volume|adjusted_close_price
    %
    % The first thing to do is put your Javaclasspath and the end of
    % classpath.txt
    
    methods (Static)
    
        function conn = connectDB(DBNAME,USERNAME,PASSWORD,DRIVER,DBURL,JAVACLASSPATH)
        %function connectDB Given the information about your MySQL server,
        %connects to the database and returns the connection.
        %Note: Currently only works if database is in MySQL local root
        %database
            javaclasspath(JAVACLASSPATH);
            
            conn = database(DBNAME, USERNAME, PASSWORD, DRIVER, DBURL);

        end
        
        function closeConn(conn)
        %function closeConn Closes the connection to the Database
        close(conn);
        end
        
        function curs = getData(conn,SQL_statement)
        %function getData retreives data from the connection based on 
        %SQL instructions given by the user    
            curs = exec(conn,SQL_statement);
            curs = fetch(curs);
        end
        
        function [Mean,Variance] = analyzeSet(curs,col,numel)
        %function analyzeSet retrieves data from the connection based on SQL instructions
        %to obtain a set of Data, and then returns some quantifiers of the
        %data - Mean, Variance
            dataSet = cell2mat(curs.Data(1:numel,col));
            Mean = mean(dataSet);
            Variance = var(dataSet);
            
        end
        
        function scatter(curs,col1,col2,numel)
        %function scatter Creates a scatter plot of elements from one
        %column of the table against another column
            dataSet1 = cell2mat(curs.Data(1:numel,col1));
            dataSet2 = cell2mat(curs.Data(1:numel,col2));
            figure
            scatter(dataSet1,dataSet2,9,'filled')
            xlabel(StockData_analyzer.col2word(col1))
            ylabel(StockData_analyzer.col2word(col2))
            title([StockData_analyzer.col2word(col1) ' vs. ' StockData_analyzer.col2word(col2)])
        end
        
        function manual_scatter(set1,set2,name1,name2)
        %function manual_scatter Creates a scatter plot of elments from
        % two different data sets. Sets must be inputted completely into
        % the function, as a result this allows you to edit sets for more
        % interesting data. set1 and set2 are both matrices, not cell
        % structures. name1 and name2 are the string names of the specific sets
        figure
        scatter(set1,set2,9,'filled')
        xlabel(name1)
        ylabel(name2)
        title([name1 ' vs. ' name2])
        
        end
        
        function str = col2word(col)
           %function col2word Takes in a column number and returns the title of that
           %column as a string. Returns empty string if column is not in
           %the data table.
           
           if col == 1
               str = 'symbol';
           elseif col == 2
               str = 'date';
           elseif col == 3
               str = 'opening price';
           elseif col == 4
               str = 'closing price';
           elseif col == 5
               str = 'high price';
           elseif col == 6
               str = 'low price';
           elseif col == 7
               str = 'volume';
           elseif col == 8  
               str = 'adjusted closing price';
           else
               str = '';
           end   
        end
        
        function scatterTime(curs,colTime,col2,numel)
        %function scatterTime Plots a column of data against time. colTime
        %must be a column containing date strings.
        dataSet1 = curs.Data(1:numel,colTime);
        dataSet1 = datenum(dataSet1,'yyyy-mm-dd');
        dataSet2 = cell2mat(curs.Data(1:numel,col2));
        figure
        scatter(dataSet1,dataSet2,9,'filled')
        xlabel('time')
        ylabel(StockData_analyzer.col2word(col2))
        ax = gca;
        ax.XTick = [];
        title(['time vs. ' StockData_analyzer.col2word(col2)])
        end
        
        function audio = getAudio(curs,colm,cols,numel)
        %function getAudio Takes data from two columns and returns it as an 
        % audio matrix that can be played with soundsc(x)    
            dataSet1 = cast(cell2mat(curs.Data(1:numel,colm)),'single');
            dataSet2 = cast(cell2mat(curs.Data(1:numel,cols)),'single');
            audio = [dataSet1 dataSet2];
        end
        
    end
    
end