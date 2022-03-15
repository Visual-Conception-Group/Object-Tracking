# LSTM-AMP
- LSTM guided ensemble correlation filter tracking with appearance model pool

## Instructions to run the tracker
1. Install MATLAB_R2018a
2. Clone the repository
3. Start Matlab and navigate to the main folder
4. Download the VGG-Net from [here](https://drive.google.com/drive/folders/16XR2LgOeA9uAZfpd-NvaJepJmZZFnUlv?usp=sharing) and add in the main folder
5. Download MatConvNet-1beta10 from [https://www.vlfeat.org/matconvnet/](https://www.vlfeat.org/matconvnet/), add to the main folder, and compile
7. Addpath matconvnet/matlab
8. Run script on a single video:
```
   |>> APP_LSTM_test.m
```
#### APP_LSTM.m is the file to integrate the tracker to the VOT Toolkit

## Datasets download links:

[TC128](https://www3.cs.stonybrook.edu/~hling/data/TColor-128/TColor-128.html)
[OTB](http://cvlab.hanyang.ac.kr/tracker_benchmark/datasets.html)
[LASOT](https://cis.temple.edu/lasot/)
[UAV123](https://cemse.kaust.edu.sa/ivul/uav123)
[GOT-10K](http://got-10k.aitestunion.com/downloads)
[Tracking Dataset](https://cmp.felk.cvut.cz/~vojirtom/)
[VOT2016](https://www.votchallenge.net/vot2016/dataset.html)
[VOT2017](https://www.votchallenge.net/vot2017/dataset.html)
[VOT2018](https://www.votchallenge.net/vot2018/dataset.html)
[VOT2019](https://www.votchallenge.net/vot2019/dataset.html)
[NFS](http://www.ci2cv.net/projects/need-for-speed-dataset/)

## Citation
Please cite the above publication if you use the code or compare with the LSTM-AMP tracker in your work. Bibtex entry:
```
%@article{jain2020lstm,
%  title={LSTM guided ensemble correlation filter tracking with appearance model pool},
%  author={Jain, Monika and Subramanyam, AV and Denman, Simon and Sridharan, Sridha and Fookes, Clinton},
%  journal={Computer Vision and Image Understanding},
%  pages={102935},
%  year={2020},
%  publisher={Elsevier}
%}
```
