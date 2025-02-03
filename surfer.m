function [U,G] = surfer(root,n,printon)
% SURFER  Create the adjacency graph of a portion of the Web.
%  [U,G] = surfer(root,n,printon) starts at the URL root and follows
%  Web links until it forms an adjacency graph with n nodes.
%  printon indicates if you want the graphs to update while searching.
%  Setting to 1 will slow things down.
%
%  U = a cell array of n strings, the URLs of the nodes.
%  G = an n-by-n sparse matrix with G(i,j)=1 if node j is linked to node i.
%
%    Example:  [U,G] = surfer('http://www.tufts.edu',500,0);
%    See also PAGERANK.
%
%    This function currently has two defects.
%    (1) The algorithm for finding links is naive.  We just look for the
%    string 'http:' or https:'.
%    (2) An attempt to read from a URL that is accessible, but very slow,
%    might take an unacceptably long time to complete.  In some cases,
%    it may be necessary to have the operating system terminate MATLAB.
%    Key words from such URLs can be added to the skip list in surfer.m.

%   Copyright 2013 Cleve Moler and The MathWorks, Inc.

% Initialize
clf

U = cell(n,1);
hash = zeros(n,1);
G = logical(sparse(n,n));
m = 1;
U{m} = root;
hash(m) = hashfun(root);

% Force output of webread to be of type 'char'.
option = weboptions('ContentType','text');  
j = 1;
while j <= n
    if(printon)
        disp(['Checking Page ' num2str(j) ' of ' num2str(n) ': ' U{j}]);
    end
    % Try to open a page.
    try
        page = webread(U{j},option); % Faster without 'option' argument but less stable.
    catch
        j = j+1;
        continue
    end

    % Follow the links from the open page.
    for f = sort([strfind(page,'http:'),strfind(page,'https:')])
        % A link starts with 'http:' or 'https:' and ends with next quote.
        % Maybe modify this next line to avoid http://www links
        e = min([strfind(page(f:end),'"') strfind(page(f:end),'''')]);
        if isempty(e), continue, end
        url = deblank(page(f:f+e-2));
        url(url<' ') = '!';   % Nonprintable characters
        if url(end) == '/', url(end) = []; end

        % Look for links that should be skipped.
        skips = {'.gif','.jpg','.JPG','jpeg','.pdf','.css','.asp','.mwc','.ram', ...
            '.cgi','lmscadsi','cybernet','w3.org','google','yahoo', ...
            'scripts','netscape','shockwave','webex','fansonly','.png', ...
            '.ico','.js','jsx','.rss','.svg'};
        skip = any(url=='!') | any(url=='?') | all(url~='.') | (url(end)=='.');
        k = 0;
        while ~skip && (k < length(skips))
            k = k+1;
            skip = ~isempty(strfind(url,skips{k}));
        end
        if skip
            continue
        end

        % Check if page is already in URL list.
        i = 0;
        for k = find(hash(1:m) == hashfun(url))'
            if isequal(U{k},url)
                i = k;
                break
            end
        end

        % Add a new URL to the graph if there are fewer than n.
        if (i == 0) && (m < n)
            m = m+1;
            U{m} = url;
            hash(m) = hashfun(url);
            i = m;
        end

        % Add a new link.
        if i > 0
            G(i,j) = 1;
        end
    end
    j = j+1;
end

% Plot sparsity pattern
spy(G);
title(['Adjacency Matrix for ' root],'FontSize',14,'FontWeight','bold');
xlabel('Pages','FontSize',14,'FontWeight','bold');
ylabel('Links','FontSize',14,'FontWeight','bold');
TSP = [1,n/5:n/5:n];
set(gca,'Xtick',TSP);
set(gca,'Ytick',TSP);
set(gca,'FontSize',14);

% Convert G from binary data to full matrix of numbers
G = full(G)*1.0;

end

%------------------------

function h = hashfun(url)
% Almost unique numeric hash code for pages already visited.
h = length(url) + 1024*sum(url);
end
