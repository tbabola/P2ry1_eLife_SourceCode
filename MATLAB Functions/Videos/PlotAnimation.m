h = animatedline;
axis([0,4*pi,-1,1])

numpoints = 100000;
x = linspace(0,4*pi,numpoints);
y = sin(x);
i = 1;
for k = 1:100:numpoints-99
    xvec = x(k:k+99);
    yvec = y(k:k+99);
    addpoints(h,xvec,yvec)
    drawnow
    M(i) = getframe;
    i = i+1;
end

%%
figure;
for k = 1:16
	plot(fft(eye(k+16)))
	axis([-1 1 -1 1])
	M(k) = getframe;
end


%% load data
%%
    lt_org = [255, 166 , 38]/255;
    dk_org = [255, 120, 0]/255;
    lt_blue = [50, 175, 242]/255;
    dk_blue = [0, 13, 242]/255;
    h = figure;
    set(h,'Position',[200,0,200*2,375*2]);
    h.Color = [1 1 1];
    ax = gca;
    ax.XLim = [-0.4 0.4];
    ax.YLim = [-12050 50];
    axis off;
    line([0 0],[-12050 0],'Color','k','LineWidth',1); hold on;
    last_i = 1;
    j=1;
    trig = 0;
    for i = 1:50:12048
        temp = pkData(pkData(:,1)<i & pkData(:,1)> last_i ,:);
        lineh = line([-.1 0.1],[-i -i],'LineWidth',2,'Color','k');
        if ~isempty(temp)
            numEvents = size(temp,1);
            if i > 3000 && ~trig
                trig = 1;
                line([-.4 .4],[-3000 -3000],'Color','k','LineStyle','--','LineWidth',2);
                trig
                
            end
            line([-temp(:,2)'; zeros(1,numEvents)],[-temp(:,1)'; -temp(:,1)'],'Color',lt_org,'LineWidth',0.5);
            line([zeros(1,numEvents); (temp(:,4))' ],[-temp(:,3)'; -temp(:,3)'],'Color',lt_blue,'LineWidth',0.5);
            %pause(0.1);
            tempL = temp(temp(:,7)==1,:);
         
            scatter(-tempL(:,2),-tempL(:,1),tempL(:,5)*200,dk_org,'MarkerFaceColor', dk_org); hold on;
            tempR = temp(temp(:,7)==2,:);
            scatter(tempR(:,4),-tempR(:,3),tempR(:,5)*200,dk_blue,'MarkerFaceColor', dk_blue);
            ax.XLim = [-0.4 0.4];
            ax.YLim = [-12050 50];
            drawnow;

        end
        last_i = i;
        M(j) = getframe;
        j = j+1;
        delete(lineh);
    end       
 
    
        
%%
%v = VideoWriter('test5.avi','Uncompressed AVI');
v = VideoWriter('ICactivity.mp4','MPEG-4');
v.Quality = 100;

v.FrameRate = 32.133/2;
open(v);

for i=1:size(M,2)
    writeVideo(v,M(i).cdata);
end
close(v);

%%
time = [1:1:size(bin,1)]/10;
h = figure; %plot(sum(-bin,2),-time); hold on; plot(sum(Rbin,2),-time);
set(h,'Position',[200,0,200*2,375*2]);
h.Color = [1 1 1];

l = getRealEvents(bin);
r = getRealEvents(Rbin);
last_i = 1; j =1;
trig = 0;
for i = 1:50:12048
    area(-time(last_i:i),-l(last_i:i),'FaceColor','k'); hold on; 
    axis off;
    if i == 1
        set(gca,'view',[90 -90])
    end
    if i > 3000 && ~trig
                trig = 1;
                line([-300 -300],[-200 200],'Color','k','LineStyle','--','LineWidth',2);
                trig
                
            end
    area(-time(last_i:i),r(last_i:i),'FaceColor','k');
    lineh = line([-i/10 -i/10],[-50 50],'LineWidth',2,'Color','k');
    drawnow;
    xlim([-1200 0]);
    ylim([-200 200])
    last_i = i;
    N(j) = getframe;
    delete(lineh);
    j = j+1;
end

%%
%%
%v = VideoWriter('test5.avi','Uncompressed AVI');
v = VideoWriter('SCactivity.mp4','MPEG-4');
v.Quality = 100;

v.FrameRate = 32.133/2;
open(v);

for i=1:size(N,2)
    writeVideo(v,N(i).cdata);
end
close(v);
