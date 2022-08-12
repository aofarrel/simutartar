version 1.0

# TODO: Make a docker image for this task
task simutator {
	input {
		File genome
		Int simutator_seed
		Int snps
		String dels
		String ins
		String complex

		# runtime attributes
		Int addldisk = 1
		Int cpu = 4
		Int retries = 3
		Int memory = 8
		Int preempt = 2
	}
	# Estimate disk size required
	Int genome_size = ceil(size(genome, "GB"))
	Int finalDiskSize = 2*genome_size + addldisk

	command <<<
	git clone https://github.com/iqbal-lab-org/simutator
	cd simutator
	pip3 install .

	simutator mutate_fasta --seed ~{simutator_seed} --snps ~{snps} \
	--dels ~{dels} \
	--ins ~{ins} \
	--complex ~{complex} \
	~{genome} ../mutated
	>>>

	runtime {
		cpu: cpu
		docker: "python:3.6.15"
		disks: "local-disk " + finalDiskSize + " HDD"
		maxRetries: "${retries}"
		memory: "${memory} GB"
		preemptibles: "${preempt}"
	}

	output {
		Array[File] mutated_vcfs = glob("*.mutated.vcf")
		Array[File] original_vcfs = glob("*.original.vcf")
		Array[File] mutated_fastas = glob("mutated*.fa")
	}
}

task art {
	input {
		File mutated_fasta
		Int art_seed
		String seqSys = "HS25"
		Int len = 150
		Int fcov = 50
		Int mflen = 500
		Int sdev = 25

		# runtime attributes
		Int addldisk = 10
		Int cpu = 16
		Int retries = 3
		Int memory = 32
		Int preempt = 2
	}
	# Estimate disk size required
	Int fasta_size = ceil(size(mutated_fasta, "GB"))
	Int finalDiskSize = 2*fasta_size + addldisk

	command <<<
	art_illumina --in ~{mutated_fasta} --out reads.out --noALN --seqSys ~{seqSys} \
	--len ~{len} --fcov ~{fcov} --mflen ~{mflen} --sdev ~{sdev} --rndSeed ~{art_seed}
	>>>

	runtime {
		cpu: cpu
		docker: "rpetit3/illumina-simulation:latest"
		disks: "local-disk " + finalDiskSize + " HDD"
		maxRetries: "${retries}"
		memory: "${memory} GB"
		preemptibles: "${preempt}"
	}

	output {
		Array[File] illumina_reads = glob("*.fq")
	}
}

workflow Simutartor {
	input {
		File genome
	}

	call simutator {
		input:
			genome = genome
	}

	# this task is incredibly slow on local, like, one output per hour slow
	scatter(mutated_fasta in simutator.mutated_fastas) {
		call art {
			input:
				mutated_fasta = mutated_fasta
		}
	}
}
