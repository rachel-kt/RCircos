install.packages("RCircos")

# required file 1. ideogram data with following coloumns 
# "Chromosome" 
# "ChromStart" 
# "ChromEnd"   
# "Band" - used here to show bands where genes are located      
# "Stain" - junk value since Stain is a requisite column but we dont have data for it

# required file 2. band colour data -  containing colours for depicting bands  
# one column of colours for species alternating with "white" to depict the gene position.

# required file 3. gene data with following coloumns 
# "Chromosome" 
# "ChromStart" 
# "ChromEnd"   
# "Gene"
# "PlotColor" - to differentiate classes of genes if any
setwd("../../media/rachel/Windows/Users/All Users/Documents/project_jnu/Brassica_napus_Trihelix/Figures/circos/")
library("RCircos", lib.loc="~/R/x86_64-pc-linux-gnu-library/3.4")
ideo_data = read.table("idea-data-with bands.csv", sep = ",", header = TRUE, stringsAsFactors = F)
cyto.info <- ideo_data
chr.exclude <- NULL
tracks.inside <- 10;
tracks.outside <- 2;

# initializing core components

RCircos.Set.Core.Components(cyto.info, chr.exclude, tracks.inside, tracks.outside);
rcircos.cyto <- RCircos.Get.Plot.Ideogram()
rcircos.params <- RCircos.Get.Plot.Parameters()
rcircos.position <- RCircos.Get.Plot.Positions();
#RCircos.List.Plot.Parameters()

# resetting default parameters

rcircos.params$char.width = 65
rcircos.params$text.size = 0.5
rcircos.params$base.per.unit = 30000
RCircos.Reset.Plot.Parameters(rcircos.params);

# resetting ideogram data

band_col = read.csv("band_color_all.csv", header = F, stringsAsFactors = F)
rcircos.cyto$BandColor = band_col[2:405,]
RCircos.Reset.Plot.Ideogram(rcircos.cyto)

#creating output file

out.file <- "all-ideogram-NEW.pdf";
pdf(file=out.file, height=30, width=30, compress=TRUE);
RCircos.Set.Plot.Area();
#rcircos.params$track.background = "blue"
par(mai=c(0.25, 0.25, 0.25, 0.25));
#plot.new();
plot.window(c(-2.5,2.5), c(-2.5, 2.5));

# obtaining gene labels and connectors

gene_label_data = read.csv("Ideo-plot-color-all-2.csv", sep = ",", header = T)
name.col <- 4;
gene.data = gene_label_data
gene_label_data$PlotColor = rep("black")
RCircos.Gene.Connector.Plot(gene_label_data,track.num = 1, side = "in", is.sorted = TRUE) #connectors
RCircos.Gene.Name.Plot(gene.data,name.col,track.num = 2, side = "in",is.sorted = TRUE); # labels
RCircos.Draw.Chromosome.Ideogram()
#RCircos.Get.Gene.Name.Plot.Parameters()

Link.data = read.csv("synteny_all.csv", sep = ",", header = TRUE, stringsAsFactors = F)
track.num <- 3;
RCircos.Link.Plot(Link.data, track.num, by.chromosome = FALSE, genomic.columns = 3);

#RCircos.Ribbon.Plot(ribbon.data=Link.data, track.num, by.chromosome=FALSE, twist=FALSE);

# Plotting the ideogram

RCircos.Chromosome.Ideogram.Plot();
dev.off()

