# IGSSTRCF
- IGSSTRCF: Importance Guided Sparse Spatio-Temporal Regularized Correlation Filters For Tracking

## Citation
Please cite the above publication if you use the code or compare with the IGSSTRCF tracker in your work. Bibtex entry:
```
@inproceedings{jain2021igsstrcf,
  title={IGSSTRCF: Importance Guided Sparse Spatio-Temporal Regularized Correlation Filters For Tracking},
  author={Jain, Monika and Subramanyam, AV and Denman, Simon and Sridharan, Sridha and Fookes, Clinton},
  booktitle={2021 IEEE Winter Conference on Applications of Computer Vision (WACV)},
  pages={2774--2783},
  year={2021},
  organization={IEEE}
}```
## Instructions to run the tracker
1. Install MATLAB_R2020a
2. Download MatConvNet-1beta10 from [https://www.vlfeat.org/matconvnet/](https://www.vlfeat.org/matconvnet/), add to the main folder, and compile
3. Start Matlab and navigate to the main folder. 
4. To run tracker on complete LASOT dataset,download and add LASOT dataset in "Datasets" folder and run script:
```
   |>> IGSSTRCF_test.m
``` 
5. To run the tracker on any other dataset:
    - download the desired dataset
    - place it in the "Datasets" folder
    - edit the data path in the "IGSSTRCF_test.m"
    - change "load_video_info.m" accordingly 
    - and run "IGSSTRCF_test.m" 

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
