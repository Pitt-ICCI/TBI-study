% Created by Dooman Arefan in Feb 2019 @ ICCI Lab, University of Pittsburgh
% Head CT preprocessing
%    Typical window width and level values for head and neck
%     brain W:80 L:40
%     subdural W:130-300 L:50-100
%     stroke W:8 L:32 or W:40 L:40 3
%     temporal bones W:2800 L:600
%     soft tissues: W:350–400 L:20–60 4


function out=HCT_preprocessing(im,L,W)
ave_im=mean(mean(im));
    if ave_im<100
        intercept=0;
        slope=1
    else
        intercept=-1024;
        slope=1;
        
    end

  mask = brain_segmentation(im,intercept, slope);
  brain_img = sigmoid_window(im, L, W,intercept, slope);
  im_masked=mask.*brain_img;
  out=im_masked;
end
  
  function img=sigmoid_window(img, window_center, window_width,intercept, slope)
img=double(img);
  U=1;
eps=(1/255);
    img = img * slope + intercept;
    ue = log((U / eps) - 1.0);
    W = (2 / window_width) * ue;
    b = ((-2 * window_center) / window_width) * ue;
    z = W * img + b;
    img = U ./ (1 + exp(-1.0 * z));
    %normalize
    img = (img - min(min(img))) / (max(max(img)) - min(min(img)));
    
end
    
function im_masked=brain_segmentation(img,intercept, slope)
  img = img * slope + intercept;
    B=img>0;
    CC = bwconncomp(B);
   numOfPixels = cellfun(@numel,CC.PixelIdxList);
   [unused,indexOfMax] = max(numOfPixels);
   biggest = zeros(size(B));
   biggest(CC.PixelIdxList{indexOfMax}) = 1;
   im_p_mask=biggest;
   im_masked=double(im_p_mask);
end



    