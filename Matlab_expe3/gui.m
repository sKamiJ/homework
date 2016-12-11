function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 10-Dec-2016 22:16:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

%初始化已有输入输出图片状态
handles.hasInputImg = false;
handles.hasOutputImg = false;

%初始功能为灰度图像
handles.fcn = @grayLevelImg;

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.mainFigure);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in openImgBtn.
function openImgBtn_Callback(hObject, eventdata, handles)
% hObject    handle to openImgBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%创建文件名处理对话框，获取路径信息
[fileName,pathName] = uigetfile(...
    '*.jpg;*.jpeg;*.bmp;*.gif;*.png;*.tiff;*.tif','选择图片');
%获取路径信息成功
if ~isequal(fileName,0)
    %读取图片
    inputImg = imread([pathName fileName]);
    %保存输入图片
    handles.inputImg = inputImg;
    %更新已有输入图片状态
    handles.hasInputImg = true;
    guidata(hObject,handles);
    %显示图片
    axes(handles.inputImgAxes);
    imshow(inputImg);
end

% --- Executes on button press in convertImgBtn.
function convertImgBtn_Callback(hObject, eventdata, handles)
% hObject    handle to convertImgBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%有输入图片
if(handles.hasInputImg)
    %处理图片，获取输出图片
    outputImg = handles.fcn(handles.inputImg);
    %保存输出图片
    handles.outputImg = outputImg;
    %更新已有输出图片状态
    handles.hasOutputImg = true;
    guidata(hObject,handles);
    %显示输出图片
    axes(handles.outputImgAxes);
    imshow(outputImg);
%无输入图片
else
	%提示无输入图片
	errordlg('尚无待处理图片！','错误');
end

% --- Executes on button press in loadOutputImgBtn.
function loadOutputImgBtn_Callback(hObject, eventdata, handles)
% hObject    handle to loadOutputImgBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%有输出图片
if(handles.hasOutputImg)
    %获取输出图片
    outputImg = handles.outputImg;
    %读取输出图片至输入图片
    handles.inputImg = outputImg;
    %更新已有输入图片状态
    handles.hasInputImg = true;
    guidata(hObject,handles);
    %显示图片
    axes(handles.inputImgAxes);
    imshow(outputImg);
%无输出图片
else
    %提示无输出图片
	errordlg('尚无转换后图片！','错误');
end

% --- Executes on button press in saveImgBtn.
function saveImgBtn_Callback(hObject, eventdata, handles)
% hObject    handle to saveImgBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%有输出图片
if(handles.hasOutputImg)
    %创建保存文件对话框，获取路径信息
    [fileName,pathName] = uiputfile(...
        '*.jpg;*.jpeg;*.bmp;*.gif;*.png;*.tiff;*.tif','保存图片');
    %获取路径信息成功
    if ~isequal(fileName,0)
        %保存图片
        imwrite(handles.outputImg,[pathName fileName]);
    end
%无输出图片
else
    %提示无输出图片
	errordlg('尚无可保存图片！','错误');
end

% --- Executes on button press in grayLevelImgRadio.
function grayLevelImgRadio_Callback(hObject, eventdata, handles)
% hObject    handle to grayLevelImgRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%将功能设置为灰度图像
handles.fcn = @grayLevelImg;
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of grayLevelImgRadio

% --- Executes on button press in binaryImgRadio.
function binaryImgRadio_Callback(hObject, eventdata, handles)
% hObject    handle to binaryImgRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%将功能设置为二值化图像
handles.fcn = @binaryImg;
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of binaryImgRadio

% --- Executes on button press in histEqRadio.
function histEqRadio_Callback(hObject, eventdata, handles)
% hObject    handle to histEqRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%将功能设置为直方图均衡化
handles.fcn = @histEq;
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of histEqRadio


% --- Executes on button press in histSpecRadio.
function histSpecRadio_Callback(hObject, eventdata, handles)
% hObject    handle to histSpecRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%将功能设置为直方图规定化
handles.fcn = @histSpec;
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of histSpecRadio


% --- Executes on button press in sobelOperatorSharpenRadio.
function sobelOperatorSharpenRadio_Callback(hObject, eventdata, handles)
% hObject    handle to sobelOperatorSharpenRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%将功能设置为Sobel算子锐化
handles.fcn = @sobelOperatorSharpen;
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of sobelOperatorSharpenRadio


% --- Executes on button press in laplasseFilterRadio.
function laplasseFilterRadio_Callback(hObject, eventdata, handles)
% hObject    handle to laplasseFilterRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%将功能设置为拉普拉斯滤波
handles.fcn = @laplasseFilter;
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of laplasseFilterRadio


% --- Executes on button press in fourierTransformRadio.
function fourierTransformRadio_Callback(hObject, eventdata, handles)
% hObject    handle to fourierTransformRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%将功能设置为傅里叶变换
handles.fcn = @fourierTransform;
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of fourierTransformRadio

% --- Executes on button press in dctTransformationRadio.
function dctTransformationRadio_Callback(hObject, eventdata, handles)
% hObject    handle to dctTransformationRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%将功能设置为离散余弦变换
handles.fcn = @dctTransformation;
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of dctTransformationRadio

% --- Executes on button press in flipHorizontalRadio.
function flipHorizontalRadio_Callback(hObject, eventdata, handles)
% hObject    handle to flipHorizontalRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%将功能设置为左右翻转
handles.fcn = @flipHorizontal;
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of flipHorizontalRadio


% --- Executes on button press in flipVerticalRadio.
function flipVerticalRadio_Callback(hObject, eventdata, handles)
% hObject    handle to flipVerticalRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%将功能设置为上下翻转
handles.fcn = @flipVertical;
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of flipVerticalRadio


% --- Executes on button press in rotate90Radio.
function rotate90Radio_Callback(hObject, eventdata, handles)
% hObject    handle to rotate90Radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%将功能设置为顺时针旋转90度
handles.fcn = @rotate90;
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of rotate90Radio


% --- Executes on button press in affineTransformationRadio.
function affineTransformationRadio_Callback(hObject, eventdata, handles)
% hObject    handle to affineTransformationRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%将功能设置为仿射变换
handles.fcn = @affineTransformation;
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of affineTransformationRadio


% --- Executes on button press in huffmanCodingRadio.
function huffmanCodingRadio_Callback(hObject, eventdata, handles)
% hObject    handle to huffmanCodingRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%将功能设置为哈夫曼编码并解码
handles.fcn = @huffmanCoding;
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of huffmanCodingRadio


% --- Executes on button press in arCodingRadio.
function arCodingRadio_Callback(hObject, eventdata, handles)
% hObject    handle to arCodingRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%将功能设置为算术编码并解码
handles.fcn = @arCoding;
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of arCodingRadio


% --- Executes on button press in dctCompressionRadio.
function dctCompressionRadio_Callback(hObject, eventdata, handles)
% hObject    handle to dctCompressionRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%将功能设置为DCT压缩
handles.fcn = @dctCompression;
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of dctCompressionRadio


% --- Executes on button press in motionBlurRadio.
function motionBlurRadio_Callback(hObject, eventdata, handles)
% hObject    handle to motionBlurRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%将功能设置为运动模糊
handles.fcn = @motionBlur;
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of motionBlurRadio


% --- Executes on button press in gaussianNoiseRadio.
function gaussianNoiseRadio_Callback(hObject, eventdata, handles)
% hObject    handle to gaussianNoiseRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%将功能设置为高斯噪声
handles.fcn = @gaussianNoise;
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of gaussianNoiseRadio


% --- Executes on button press in counterFilteringRestorationRadio.
function counterFilteringRestorationRadio_Callback(hObject, eventdata, handles)
% hObject    handle to counterFilteringRestorationRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%将功能设置为逆滤波复原
handles.fcn = @counterFilteringRestoration;
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of counterFilteringRestorationRadio


% --- Executes on button press in wienerFilteringRestorationRadio.
function wienerFilteringRestorationRadio_Callback(hObject, eventdata, handles)
% hObject    handle to wienerFilteringRestorationRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%将功能设置为维纳滤波复原
handles.fcn = @wienerFilteringRestoration;
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of wienerFilteringRestorationRadio


% --- Executes on button press in watershedSegmentationRadio.
function watershedSegmentationRadio_Callback(hObject, eventdata, handles)
% hObject    handle to watershedSegmentationRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%将功能设置为分水岭分割
handles.fcn = @watershedSegmentation;
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of watershedSegmentationRadio


% --- Executes on button press in logOperatorSegmentationRadio.
function logOperatorSegmentationRadio_Callback(hObject, eventdata, handles)
% hObject    handle to logOperatorSegmentationRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%将功能设置为Log算子分割
handles.fcn = @logOperatorSegmentation;
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of logOperatorSegmentationRadio


% --- Executes on button press in cannyOperatorSegmentationRadio.
function cannyOperatorSegmentationRadio_Callback(hObject, eventdata, handles)
% hObject    handle to cannyOperatorSegmentationRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%将功能设置为Canny算子分割
handles.fcn = @cannyOperatorSegmentation;
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of cannyOperatorSegmentationRadio

