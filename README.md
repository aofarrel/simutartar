# simutartor 🥧
 [simutator](https://github.com/iqbal-lab-org/simutator) + [ART](https://www.niehs.nih.gov/research/resources/software/biostatistics/art/index.cfm) in WDL. Simulate variants and Illumina reads from a ref genome.

 Note that the ART task is too beefy for most local configurations of Cromwell to handle in a time-effective manner, so it's recommended to run this on a cloud provider or HPC. On Terra, with the provided data and default configs, expect it to finish in about ten minutes.

### Citations
 * ART: Weichun Huang, Leping Li, Jason R. Myers, Gabor T. Marth, ART: a next-generation sequencing read simulator, Bioinformatics, Volume 28, Issue 4, 15 February 2012, Pages 593–594, https://doi.org/10.1093/bioinformatics/btr708
  * Sample inputs (see additional file 1): Hunt, M., Letcher, B., Malone, K.M. et al. Minos: variant adjudication and joint genotyping of cohorts of bacterial genomes. Genome Biol 23, 147 (2022). [https://doi.org/10.1186/s13059-022-02714-x](https://doi.org/10.1186/s13059-022-02714-x)
  * simutator: https://github.com/iqbal-lab-org/simutator
