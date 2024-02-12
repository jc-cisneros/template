#/bin/bash
echo "Running full_run.sh"
git submodule init
git submodule update
conda env create -f setup/conda_env.yaml
conda activate template
R -e "IRkernel::installspec(user = FALSE)"
cd setup
python check_setup.py
cd ..
python run_all.py