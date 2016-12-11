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

%��ʼ�������������ͼƬ״̬
handles.hasInputImg = false;
handles.hasOutputImg = false;

%��ʼ����Ϊ�Ҷ�ͼ��
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
%�����ļ�������Ի��򣬻�ȡ·����Ϣ
[fileName,pathName] = uigetfile(...
    '*.jpg;*.jpeg;*.bmp;*.gif;*.png;*.tiff;*.tif','ѡ��ͼƬ');
%��ȡ·����Ϣ�ɹ�
if ~isequal(fileName,0)
    %��ȡͼƬ
    inputImg = imread([pathName fileName]);
    %��������ͼƬ
    handles.inputImg = inputImg;
    %������������ͼƬ״̬
    handles.hasInputImg = true;
    guidata(hObject,handles);
    %��ʾͼƬ
    axes(handles.inputImgAxes);
    imshow(inputImg);
end

% --- Executes on button press in convertImgBtn.
function convertImgBtn_Callback(hObject, eventdata, handles)
% hObject    handle to convertImgBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%������ͼƬ
if(handles.hasInputImg)
    %����ͼƬ����ȡ���ͼƬ
    outputImg = handles.fcn(handles.inputImg);
    %�������ͼƬ
    handles.outputImg = outputImg;
    %�����������ͼƬ״̬
    handles.hasOutputImg = true;
    guidata(hObject,handles);
    %��ʾ���ͼƬ
    axes(handles.outputImgAxes);
    imshow(outputImg);
%������ͼƬ
else
	%��ʾ������ͼƬ
	errordlg('���޴�����ͼƬ��','����');
end

% --- Executes on button press in loadOutputImgBtn.
function loadOutputImgBtn_Callback(hObject, eventdata, handles)
% hObject    handle to loadOutputImgBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%�����ͼƬ
if(handles.hasOutputImg)
    %��ȡ���ͼƬ
    outputImg = handles.outputImg;
    %��ȡ���ͼƬ������ͼƬ
    handles.inputImg = outputImg;
    %������������ͼƬ״̬
    handles.hasInputImg = true;
    guidata(hObject,handles);
    %��ʾͼƬ
    axes(handles.inputImgAxes);
    imshow(outputImg);
%�����ͼƬ
else
    %��ʾ�����ͼƬ
	errordlg('����ת����ͼƬ��','����');
end

% --- Executes on button press in saveImgBtn.
function saveImgBtn_Callback(hObject, eventdata, handles)
% hObject    handle to saveImgBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%�����ͼƬ
if(handles.hasOutputImg)
    %���������ļ��Ի��򣬻�ȡ·����Ϣ
    [fileName,pathName] = uiputfile(...
        '*.jpg;*.jpeg;*.bmp;*.gif;*.png;*.tiff;*.tif','����ͼƬ');
    %��ȡ·����Ϣ�ɹ�
    if ~isequal(fileName,0)
        %����ͼƬ
        imwrite(handles.outputImg,[pathName fileName]);
    end
%�����ͼƬ
else
    %��ʾ�����ͼƬ
	errordlg('���޿ɱ���ͼƬ��','����');
end

% --- Executes on button press in grayLevelImgRadio.
function grayLevelImgRadio_Callback(hObject, eventdata, handles)
% hObject    handle to grayLevelImgRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%����������Ϊ�Ҷ�ͼ��
handles.fcn = @grayLevelImg;
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of grayLevelImgRadio

% --- Executes on button press in binaryImgRadio.
function binaryImgRadio_Callback(hObject, eventdata, handles)
% hObject    handle to binaryImgRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%����������Ϊ��ֵ��ͼ��
handles.fcn = @binaryImg;
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of binaryImgRadio

% --- Executes on button press in histEqRadio.
function histEqRadio_Callback(hObject, eventdata, handles)
% hObject    handle to histEqRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%����������Ϊֱ��ͼ���⻯
handles.fcn = @histEq;
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of histEqRadio


% --- Executes on button press in histSpecRadio.
function histSpecRadio_Callback(hObject, eventdata, handles)
% hObject    handle to histSpecRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%����������Ϊֱ��ͼ�涨��
handles.fcn = @histSpec;
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of histSpecRadio


% --- Executes on button press in sobelOperatorSharpenRadio.
function sobelOperatorSharpenRadio_Callback(hObject, eventdata, handles)
% hObject    handle to sobelOperatorSharpenRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%����������ΪSobel������
handles.fcn = @sobelOperatorSharpen;
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of sobelOperatorSharpenRadio


% --- Executes on button press in laplasseFilterRadio.
function laplasseFilterRadio_Callback(hObject, eventdata, handles)
% hObject    handle to laplasseFilterRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%����������Ϊ������˹�˲�
handles.fcn = @laplasseFilter;
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of laplasseFilterRadio


% --- Executes on button press in fourierTransformRadio.
function fourierTransformRadio_Callback(hObject, eventdata, handles)
% hObject    handle to fourierTransformRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%����������Ϊ����Ҷ�任
handles.fcn = @fourierTransform;
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of fourierTransformRadio

% --- Executes on button press in dctTransformationRadio.
function dctTransformationRadio_Callback(hObject, eventdata, handles)
% hObject    handle to dctTransformationRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%����������Ϊ��ɢ���ұ任
handles.fcn = @dctTransformation;
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of dctTransformationRadio

% --- Executes on button press in flipHorizontalRadio.
function flipHorizontalRadio_Callback(hObject, eventdata, handles)
% hObject    handle to flipHorizontalRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%����������Ϊ���ҷ�ת
handles.fcn = @flipHorizontal;
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of flipHorizontalRadio


% --- Executes on button press in flipVerticalRadio.
function flipVerticalRadio_Callback(hObject, eventdata, handles)
% hObject    handle to flipVerticalRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%����������Ϊ���·�ת
handles.fcn = @flipVertical;
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of flipVerticalRadio


% --- Executes on button press in rotate90Radio.
function rotate90Radio_Callback(hObject, eventdata, handles)
% hObject    handle to rotate90Radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%����������Ϊ˳ʱ����ת90��
handles.fcn = @rotate90;
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of rotate90Radio


% --- Executes on button press in affineTransformationRadio.
function affineTransformationRadio_Callback(hObject, eventdata, handles)
% hObject    handle to affineTransformationRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%����������Ϊ����任
handles.fcn = @affineTransformation;
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of affineTransformationRadio


% --- Executes on button press in huffmanCodingRadio.
function huffmanCodingRadio_Callback(hObject, eventdata, handles)
% hObject    handle to huffmanCodingRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%����������Ϊ���������벢����
handles.fcn = @huffmanCoding;
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of huffmanCodingRadio


% --- Executes on button press in arCodingRadio.
function arCodingRadio_Callback(hObject, eventdata, handles)
% hObject    handle to arCodingRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%����������Ϊ�������벢����
handles.fcn = @arCoding;
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of arCodingRadio


% --- Executes on button press in dctCompressionRadio.
function dctCompressionRadio_Callback(hObject, eventdata, handles)
% hObject    handle to dctCompressionRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%����������ΪDCTѹ��
handles.fcn = @dctCompression;
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of dctCompressionRadio


% --- Executes on button press in motionBlurRadio.
function motionBlurRadio_Callback(hObject, eventdata, handles)
% hObject    handle to motionBlurRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%����������Ϊ�˶�ģ��
handles.fcn = @motionBlur;
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of motionBlurRadio


% --- Executes on button press in gaussianNoiseRadio.
function gaussianNoiseRadio_Callback(hObject, eventdata, handles)
% hObject    handle to gaussianNoiseRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%����������Ϊ��˹����
handles.fcn = @gaussianNoise;
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of gaussianNoiseRadio


% --- Executes on button press in counterFilteringRestorationRadio.
function counterFilteringRestorationRadio_Callback(hObject, eventdata, handles)
% hObject    handle to counterFilteringRestorationRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%����������Ϊ���˲���ԭ
handles.fcn = @counterFilteringRestoration;
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of counterFilteringRestorationRadio


% --- Executes on button press in wienerFilteringRestorationRadio.
function wienerFilteringRestorationRadio_Callback(hObject, eventdata, handles)
% hObject    handle to wienerFilteringRestorationRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%����������Ϊά���˲���ԭ
handles.fcn = @wienerFilteringRestoration;
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of wienerFilteringRestorationRadio


% --- Executes on button press in watershedSegmentationRadio.
function watershedSegmentationRadio_Callback(hObject, eventdata, handles)
% hObject    handle to watershedSegmentationRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%����������Ϊ��ˮ��ָ�
handles.fcn = @watershedSegmentation;
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of watershedSegmentationRadio


% --- Executes on button press in logOperatorSegmentationRadio.
function logOperatorSegmentationRadio_Callback(hObject, eventdata, handles)
% hObject    handle to logOperatorSegmentationRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%����������ΪLog���ӷָ�
handles.fcn = @logOperatorSegmentation;
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of logOperatorSegmentationRadio


% --- Executes on button press in cannyOperatorSegmentationRadio.
function cannyOperatorSegmentationRadio_Callback(hObject, eventdata, handles)
% hObject    handle to cannyOperatorSegmentationRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%����������ΪCanny���ӷָ�
handles.fcn = @cannyOperatorSegmentation;
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of cannyOperatorSegmentationRadio

