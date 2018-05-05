v = VideoWriter('video_divide.avi');
open(v)
for img_index = 1 : 310
     writeVideo(v,imread(strcat('C:\Users\chanc\Desktop\project_finall\FG\',num2str(img_index),'.png')));
end
close(v)
