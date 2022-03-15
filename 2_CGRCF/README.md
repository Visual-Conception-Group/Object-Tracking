# CGRCF
- Channel graph regularized correlation filters for visual object tracking

## Instructions to run the tracker
1. Install MATLAB_R2020a
2. Clone the repository
3. Start Matlab and navigate to the main folder.  
4. Download pretrained networks from [https://drive.google.com/drive/folders/1s7YxpSP06XsoJrEtJ0BN8U5yN3CbY7c4?usp=sharing](here) and add to the main folder
5. Download MatConvNet-1beta10 from [https://www.vlfeat.org/matconvnet/](https://www.vlfeat.org/matconvnet/), add to the main folder, and compile
6. Run script on a single video:
```
   |>> CGRCF_test.m
```
7. To run tracker on complete TC128 dataset,download and add TC128 dataset in "Datasets" folder and run script:
```
   |>> CGRCF_test_multiple_videos.m
``` 
8. To run the tracker on any other dataset:
    - download the desired dataset
    - place it in the "Datasets" folder
    - edit the data path in the "CGRCF_test_multiple_videos.m"
    - change "load_video_info.m" accordingly 
    - and run "CGRCF_test_multiple_videos.m"  

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
Please cite the above publication if you use the code or compare with the CGRCF tracker in your work. Bibtex entry:
```
@article{jain2021channel,
  title={Channel graph regularized correlation filters for visual object tracking},
  author={Jain, Monika and Tyagi, Arjun and Subramanyam, AV and Denman, Simon and Sridharan, Sridha and Fookes, Clinton},
  journal={IEEE Transactions on Circuits and Systems for Video Technology},
  year={2021},
  publisher={IEEE}
} 
```
