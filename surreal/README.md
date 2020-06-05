# Generate Human Walking Meshes From SURREAL

The HumANav dataset uses photorealistic textured meshes from the [SURREAL](https://www.di.ens.fr/willow/research/surreal/) dataset. Please follow the following setup instructions; #1 and #2 are modified from the [SURREAL GitHub page](https://github.com/gulvarol/surreal).

## 1. Accept the SURREAL dataset license

The links to license terms and download procedure are available here:

https://www.di.ens.fr/willow/research/surreal/data/

Once you receive the credentials to download the dataset, you will have a personal username and password.

## 2. Create your own synthetic data
### 2.1. Preparation
#### 2.1.1. SMPL data (~2.6 GB)
a) With the same credentials as with the SURREAL dataset, you can download the necessary SMPL data and place it in `/PATH/TO/HumANav/surreal/download/SURREAL/smpl_data`.

```
chmod +x download_smpl_data.sh
./download_smpl_data.sh /PATH/TO/HumANav/surreal/download yourusername yourpassword
```

b) You need to download **SMPL for MAYA** from http://smpl.is.tue.mpg.de (register an account and download it) in order to run the synthetic data generation code. Once you agree on SMPL license terms and have access to downloads, you will have the following two files (~ 40 MB).

```
basicModel_f_lbs_10_207_0_v1.0.2.fbx
basicModel_m_lbs_10_207_0_v1.0.2.fbx
```

Place these two files under `/PATH/TO/HumANav/surreal/download/SURREAL/smpl_data` folder.

The folder `/PATH/TO/HumANav/surreal/download/SURREAL/smpl_data` should contain the folling files and folders:
```
/PATH/TO/HumANav/surreal/download/SURREAL/smpl_data/
    - basicModel_f_lbs_10_207_0_v1.0.2.fbx
    - basicModel_m_lbs_10_207_0_v1.0.2.fbx
    - female_beta_stds.npy
    - male_beta_stds.npy
    - smpl_data.npz
    - textures/
```


#### 2.1.2. Install Blender 2.79a

You need to download [Blender](http://download.blender.org/release/) and install scipy package to run the first part of the code. The provided code was tested with Blender 2.79, which is shipped with its own python executable as well as distutils package. Therefore, it is sufficient to do the following:


##### For Linux

```sh
# Download Blender 2.79a
wget https://download.blender.org/release/Blender2.79/blender-2.79a-linux-glibc219-x86_64.tar.bz2

# Un-TAR Blender
tar xjf blender-2.79a-linux-glibc219-x86_64.tar.bz2

# Export the BLENDER_PATH
export BLENDER_PATH='/path/to/blender/blender-2.79a-linux-glibc219-x86_64'

# Install pip
wget https://bootstrap.pypa.io/get-pip.py
$BLENDER_PATH/2.79/python/bin/python3.5m get-pip.py

# Make sure you have libglu1
sudo apt-get install libglu1

# Install scipy
# For this step, we want to install scipy. However, installing scipy
# installs a new version of numpy that causes a conflict. To fix this
# issue we need to uninstall the default version of numpy that comes with
# Blender.

## Uninstall numpy
$BLENDER_PATH/2.79/python/bin/python3.5m -m pip uninstall numpy

## Manually delete blender's default numpy installation
rm -rf $BLENDER_PATH/2.79/python/lib/python3.5/site-packages/numpy/

## Install scipy (numpy will also be reinstalled in the process)
$BLENDER_PATH/2.79/python/bin/python3.5m -m pip install scipy

# Check the scipy installation
cd /PATH/TO/HumANav/surreal/download/
$BLENDER_PATH/blender -b -t 1 -P check_numpy.py

# If scipy & numpy are installed correctly the script should print "Success".
```

##### For Mac OS:

```sh
# Install Homebrew if you don't have it (it's a package manager for Mac OS)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# Install Blender
brew cask install /PATH/TO/HumANav/surreal/code/blender.rb

# Download pip to your current directory
wget https://bootstrap.pypa.io/get-pip.py

# Install pip for Blender Python
/Applications/Blender.app/Contents/Resources/2.79/python/bin/python3.5m get-pip.py

# Uninstall default numpy
/Applications/Blender.app/Contents/Resources/2.79/python/bin/python3.5m -m pip uninstall numpy

# Remove numpy folder in site-packages
rm -rf /Applications/Blender.app/Contents/Resources/2.79/python/lib/python3.5/site-packages/numpy/

# Install scipy
/Applications/Blender.app/Contents/Resources/2.79/python/bin/python3.5m -m pip install scipy

# Change directory (cd) to `/PATH/TO/HumANav/surreal/download` and run this command to test scipy installation
blender -b -t 1 -P check_numpy.py

# If scipy & numpy are installed correctly the script should print "Success".
```

## 3. Custom Instructions for HumANav Data Generation

### Make sure your data is organized correctly

### Edit the config file
In the directory **/PATH/TO/HumANav/surreal/code** copy the file **config** to a new file **config_local** and modify the **smpl_data_folder** field.
```
smpl_data_folder   = '/PATH/TO/HumANav/surreal/download/SURREAL/smpl_data'
```

### Test the installation
```sh
cd /PATH/TO/HumANav/surreal/code

# Linux
$BLENDER_PATH/blender -b -t 1 -P export_human_meshes.py -- --idx 2 --ishape 0 --stride 59 --gender female --body_shape 1000 --outdir test_human_mesh_generation


# Mac OS
blender -b -t 1 -P export_human_meshes.py -- --idx 2 --ishape 0 --stride 59 --gender female --body_shape 1000 --outdir test_human_mesh_generation

```
The test should create the following directory structure:
```
test_human_mesh_generation/
    - velocity_0.000_m_s/
    - velocity_0.200_m_s/
    - velocity_0.500_m_s/
        - pose_2_ishape_0_stride_59/
            - body_shape_1000/
                - female/ # (here i is in [1, 2, 3])
                    - human_centering_info_i.pkl
                    - human_mesh_i.mtl
                    - human_mesh_i.obj
    - velocity_0.600_m_s/
        - pose_2_ishape_0_stride_59/
            - body_shape_1000/
                - female/  # (here i is in [4, 5, 6, 7, 8, 18, 19])
                    - human_centering_info_i.pkl
                    - human_mesh_i.mtl
                    - human_mesh_i.obj
```
The **human_mesh_i.obj** (mesh of the corresponding human body), and **human_centering_info_i.pkl** (information to canonically center and position each human) files will be used in the HumANav dataset.

### Generate the Human Mesh Models for HumANav
Note: Full data generation takes around ~4 hours & 5 GB of space.
```
cd /PATH/TO/HumANav/surreal/code

# Linux
sh generate_meshes.sh

# Mac OS
sh generate_meshes_macos.sh
```

Human meshes will be saved in **/PATH/TO/HumANav/surreal/code/human_meshes**.
Human textures will be saved in **/PATH/TO/HumANav/surreal/code/human_textures**.
