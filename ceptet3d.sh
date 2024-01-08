#PBS -N ali_2D_Sim_Drug_ORd
#PBS -l nodes=1:ppn=6
#PBS -l walltime=20000:00:00
#PBS -e stderr.log
#PBS -o stdout.log
# Specific the shell types
#PBS -S /bin/bash
# Specific the queue type
#PBS -q dque

cd $PBS_O_WORKDIR

ulimit -s unlimited

NPROCS=`wc -l < $PBS_NODEFILE`

cat $PBS_NODEFILE

echo This job has allocated $NPROCS nodes

# Use this to export the library path
export LD_LIBRARY_PATH=/opt/prog/sundial/lib64:$LD_LIBRARY_PATH

rm -rf *.vtk *.plt output.* logfile_square *.log *.scalar result/

#mpirun -v -machinefile $PBS_NODEFILE -np $NPROCS /scratch7/feber/new_code/New-3D-Lab/CEP/bin/cep2018 \
mpirun -v -machinefile $PBS_NODEFILE -np $NPROCS /home/cml/marcell/2DDrugSimulation/bin/CEP6_2D_Drug \
    -input_deck EDISON_INPUT_DECK_2D_3D.txt \
    -femesh_dir ./mesh/ \
    -fibermesh /scratch4/maincode/mesh_elect/vent/human_hf_214319/purkinje/line.inp \
    -heartmesh ./mesh/1_1_0.02_0.02.inp \
    -pace1mesh ./mesh/1_1_0.02_0.02_left_bottom_corner.dat \
    -pace2mesh ./mesh/1_1_0.02_0.02_bottom_half.dat \
    -ecsurf /scratch4/maincode/mesh_elect/vent/human_hf_214319/surf.inp \
    -hill_file ./drugs/bepridil/IC50_optimal.csv >& logfile_square
