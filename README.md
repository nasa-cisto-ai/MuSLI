# MuSLI

Vegetation Indices (VIs) Calculation Using Harmonized Landsat and Sentinel-2 (HLS) Imagery

## Business Case

Using the Harmonized Landsat and Sentinel-2 (HLS) surface reflectance dataset<sup> [1]</sup>,
the team is developing canopy chlorophyll and Gross Primary Production (GPP) equations based on
Vegetation Indices (VIs). The team was working with extracted HLS data and VIs, and is now applying
the GPP equations to the HLS imagery. The data for this project is currently available under the NASA
Center for Climate Simulation (NCCS) ADAPT system, primarily located in the following directories:

```bash
L30: /att/gpfsfs/briskfs01/ppl/pentchev/OPE3_HLS/HLS.GSFC.18SUJ.L30/L30
S30: /att/gpfsfs/briskfs01/ppl/pentchev/OPE3_HLS/HLS.GSFC.18SUJ.S30/S30
YEARS: 2015-2019
```

This notebook is an enhancement of existing MATLAB scripts in order to calculate VIs from extracted spectral
values. The idea is to apply the calculated indices to the images and make spatial/geo-referenced maps of the
VIs. The team would like to scale the indices 0-1 and apply the canopy chlorophyll and GPP equations to the VI
images (scaled and not scaled). This notebook is arquitected to apply to L30 and S30 imagery, and it will require
slight modifications in order to apply to additional datasets. For additional information on the bands available
via the HLS dataset, feel free to visit <https://lpdaac.usgs.gov/data/get-started-data/collection-overview/missions/harmonized-landsat-sentinel-2-hls-overview/>.

## Download

```bash
wget 2021.10
```

## Usage and installation requirements

Creating a conda environment (One time only)

In order to run this notebook you will need a conda environment with all dependencies installed. ADAPT provides a built-in environment from the JupyterHub interface that is only missing a couple of packages that can be installed on the fly. In order to get started quickly, follow the next steps:

1. Login to adaptlogin.nccs.nasa.gov

2. Load the Anaconda module

```bash
module load anaconda3
```

3. Install new environment or clone the existing environment

```bash
conda config --add channels conda-forge
conda config --set channel_priority strict
conda create -y -n hls-vis-gpp rioxarray cupy cudatoolkit=11.2 dask-cuda cudnn cutensor nccl ipykernel ipywidgets matplotlib geopandas iteration_utilities
```

or

```bash
conda create --name hls-vis --clone /att/nobackup/jacaraba/.conda/envs/hls-vis
```

Now you are ready to move on to JupyterHub.

## Login to ADAPT JupyterHub

To leverage NCCS ADAPT resources, you will need to login to ADAPT JupyterHub. The steps are outlined below.

1. Login to the NCCS JupyterHub <https://www-proxy-dev.nccs.nasa.gov/jupyterhub-prism/>.
2. Open this notebook via the file/upload method.
3. Select kernel, in this case "hls-vis".
4. Start working on your notebook.

## Authors

- Jordan Alexis Caraballo-Vega, <jordan.a.caraballo-vega@nasa.gov>

## References

- [HLS](https://lpdaac.usgs.gov/data/get-started-data/collection-overview/missions/harmonized-landsat-sentinel-2-hls-overview/)
- [Xarray](http://xarray.pydata.org/en/stable/)
- [CuPy](https://cupy.dev/)
- [Rasterio](https://rasterio.readthedocs.io/en/latest/)
- [RioXarray](https://corteva.github.io/rioxarray/stable/)
