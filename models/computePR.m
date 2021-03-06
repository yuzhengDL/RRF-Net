clc;
%% compute PR for image-sentence retrieval
  
  % load image and text results
  X0 = load('./Flickr30K_image_embedding_features.txt'); 
  Y0 = load('./Flickr30K_text_embedding_features.txt'); 

  numX = size(X0, 1); numY = size(Y0, 1);
  xDim = size(X0, 2); yDim = size(Y0, 2);
  assert(numY == 5*numX);

  % similarity matrix by dot product
  D_unique = pdist2(X0,Y0,'cosine');
  
  [~,b] = sort(D_unique,2);
  testingID = kron([1:numX],[1 1 1 1 1]);
  %find precision at top 10 retrieved sentences
  res = zeros([numX, 1]);
  for i=1:size(D_unique,1)
    ind = find(testingID(b(i,:))==i);
    res(i) = min(ind);
  end
  acc = zeros([1,3]);
  acc(1) = length(find(res<=1))/numX;
  acc(2) = length(find(res<=5))/numX;
  acc(3) = length(find(res<=10))/numX;
  %acc(4) = length(find(res<=100))/numX;
  
 [~,b_search] = sort(D_unique,1);
 testingID = kron([1:numX],[1 1 1 1 1]);
  
  % find precision at top 10 retrieved sentences
  
  res = zeros([numY, 1]);
  for i=1:size(D_unique,2)
    ind = find(b_search(:,i)== testingID(i));
    res(i) = min(ind);
%     if(res(i)==3)
%         display(i);
%     end
  end
  acc_search = zeros([1,3]);
  acc_search(1) = length(find(res<=1))/numY;
  acc_search(2) = length(find(res<=5))/numY;
  acc_search(3) = length(find(res<=10))/numY;
  %acc_search(4) = length(find(res<=100))/numY;
  
%   
  fprintf('Image-Sentence    R@1 %0.3f, R@5 %0.3f, R@10 %0.3f \n', ...
    acc(1), acc(2), acc(3))
  fprintf('Sentence-Image    R@1 %0.3f, R@5 %0.3f, R@10 %0.3f \n', ...
    acc_search(1), acc_search(2), acc_search(3))
  
