function []= mySlidingFigure(cData,cMin,cMax,fNo)
%Code from:
%https://stackoverflow.com/questions/21272559/matlab-adding-slider-on-a-figure

fig=figure(fNo);
set(fig,'Name','Image','Toolbar','figure',...
    'NumberTitle','off')
bgcolor = fig.Color;

% Create an axes to plot in
axes('Position',[.15 .05 .7 .9]);
% sliders for epsilon and lambda
slider1_handle=uicontrol(fig,'Style','slider','Max',33,'Min',1,...
    'Value',2,'SliderStep',[1/(33-1) 1/(33-1)],...
    'Units','normalized','Position',[.02 .02 .14 .05]);
uicontrol(fig,'Style','text','Units','normalized','Position',[.02 .07 .14 .04],...
    'String','Choose Depth Level');
% bl1 = uicontrol('Parent',fig,'Style','text','Position',[.01 .07 .01 .04],...
%                  'String',1,'BackgroundColor',bgcolor);
% 
% bl2 = uicontrol('Parent',fig,'Style','text','Position',[.16 .07 .01 .04],...
%                  'String',32,'BackgroundColor',bgcolor);
% 
% bl3 = uicontrol('Parent',fig,'Style','text','Position',[.2 .06 .01 .04],...
%                  'String','Value','BackgroundColor',bgcolor);


% Set up callbacks
vars=struct('slider1_handle',slider1_handle,'cData',cData);
set(slider1_handle,'Callback',{@slider1_callback,vars,cMin,cMax});


plotterfcn(vars,cMin,cMax)


% End of main file

% Callback subfunctions to support UI actions
function slider1_callback(~,~,vars,cMin,cMax)
    % Run slider1 which controls value of epsilon
    plotterfcn(vars,cMin,cMax)

function plotterfcn(vars,cMin,cMax)
    % Plots the image

    contourf(vars.cData(:,:,round(get(vars.slider1_handle,'Value'))));
    title(num2str(get(vars.slider1_handle,'Value')));
    hcb = colorbar;
set(get(hcb,'Title'),'String',' C [m/s]');
ylabel('Latitude')
xlabel('Longitude');
caxis([cMin cMax]);







    
    