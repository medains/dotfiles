
// Developing neural networks with good
// betting fitness
// so far, this is a generic setup see pastebin.com/ZZmSNaHX
//
// Using NEAT principles from http://nn.cs.utexas.edu/downloads/papers/stanley.ec02.pdf
//

var Inputs = 10; //NUMBER OF INPUTS + 1 (for bias)
var Outputs = 5; //NUMBER OF OUTPUTS;

var Population = 300,
    DeltaDisjoint = 2.0,
    DeltaWeights = 0.4,
    DeltaThreshold = 1.0,
    StaleSpecies = 15,
    MutateConnectionsChance = 0.25,
    PerturbChance = 0.90,
    CrossoverChance = 0.75,
    LinkMutationChance = 2.0,
    NodeMutationChance = 0.50,
    BiasMutationChance = 0.40,
    StepSize = 0.1,
    DisableMutationChance = 0.4,
    EnableMutationChance = 0.2,
    TimeoutConstant = 20,
    MaxNodes = 1000000;

function sigmoid(x) {
    return 2/(1+math.exp(-4.9*x))-1;
}

function writeFile(name) {
    // TODO - save the genepool
}
function getInputs() {
    // Return one set of inputs
    // TODO work out a sequence of inputs, last should always be 1 for a bias node
    return [1,1,1,1,1,1,1,1,1,1];
}
function resetInputs() {
    // TODO go back to the start of the input to evaluate a new genome
}

function calculateFitnessDelta(genome, results) {
    //console.log('Placing bets');
    // TODO - place bets based off the genome results, and add the fitness from the results
    // return the new fitness value
    return 0;
}

function newInnovation() {   // seems to use dirty global
    pool.innovation = pool.innovation + 1;
    return pool.innovation;
}

function newPool() {
    return {
        species: [],
        generation: 0,
        innovation: Outputs, // HMM SIDEEFFECT?
        currentSpecies: 0,
        currentGenome: 0,
        currentMatch: 1,
        maxFitness: 0,
    }
}

function newSpecies() {
    return {
        topFitness: 0,
        staleness: 0,
        genomes: [],
        averageFitness: 0,
    }
}

function newGenome() {
    return {
        genes: [],
        fitness: 0,
        adjustedFitness: 0,
        network: {},
        maxneuron: 0,
        globalRank: 0,
        mutationRates: {
            connections: MutateConnectionsChance,
            link: LinkMutationChance,
            bias: BiasMutationChance,
            node: NodeMutationChance,
            enable: EnableMutationChance,
            disable: DisableMutationChance,
            step: StepSize,
        },
    }
}

function basicGenome() {
    var genome = newGenome();
    genome.maxneuron = Inputs + Outputs;
    mutate(genome);
    return genome;
}

function newGene() {
    return {
        into: 0,
        out: 0,
        weight: 0.0,
        enabled: true,
        innovation: 0,
    }
}

function newNeuron() {
    return {
        incoming: [],
        value: 0.0,
    }
}

function generateNetwork(genome) {
    var network = {
        neurons: [],
    };

    for (var x=0; x<(Inputs+Outputs); x++) {
        network.neurons[x] = newNeuron();
    }
    for (var x=0; x<genome.genes.length; x++) {
        var gene = genome.genes[x];
        if (gene.enabled) {
            if (network.neurons[gene.out] == undefined) {
                network.neurons[gene.out] = newNeuron();
            }
            if (network.neurons[gene.into] == undefined) {
                network.neurons[gene.into] = newNeuron();
            }
            var neuron = network.neurons[gene.out];
            neuron.incoming.push(gene);
        }
    }
    genome.network = network;
}

function evaluateNetwork(network, inputs) {
    if (inputs.length != Inputs) {
        return [];
    }
    for (var x=0; x<Inputs; x++) {
        network.neurons[x].value = inputs[x];
    }
    for (var n in network.neurons) {
        if (network.hasOwnProperty(n)) {
            var neuron = network.neurons[n];
            var sum = 0;
            for (var j=0; j<neuron.incoming.length; j++) {
                var incoming = neuron.incoming[j];
                var other = network.neurons[incoming.into];
                sum = sum + incoming.weight * other.value;
            }
            if (neuron.incoming.length > 0) {
                neuron.value = sigmoid(sum);
            }
        }
    }
    var outputs = [];
    for (var x=0; x<Outputs; x++) {
        if (network.neurons[Inputs+x].value > 0) {
            outputs.push(network.neurons[Inputs+x].value);
        } else {
            outputs.push(false);
        }
    }
    return outputs;
}

function copyGenome(g) {
    return g;
}
function copyGene(g) {
    return g;
}

function crossover(g1, g2) {
    // crossover g1 and g2
    if (g1.fitness < g2.fitness) {
        tempg = g1;
        g1 = g2;
        g2 = tempg;
    }
    var child = newGenome();
    var in2 = [];
    for (var x=0; x<g2.genes.length; x++) {
        in2[ g2.genes[x].innovation ] = g2.genes[x];
    }
    for (var x=0; x<g1.genes.length; x++) {
        var gene1 = g1.genes[x];
        var gene2 = in2[gene1.innovation];
        if (gene2 != undefined && getRandomIntInclusive(0,1) == 1 && gene2.enabled) {
            child.genes.push(copyGene(gene2));
        } else {
            child.genes.push(copyGene(gene1));
        }
    }
    child.maxneuron = Math.max(g1.maxneuron, g2.maxneuron);

    // TODO inherit g1's mutationRates

    return child;
}

function getRandomIntInclusive(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
}

function randomNeuron(genome, nonInput) {
    var start = nonInput ? Inputs : 0;
    return getRandomIntInclusive(start, genome.maxneuron);
}

function containsLink(genes, link) {
    for (var x=0; x<genes.length; x++) {
        var gene = genes[x];
        if (gene.into == link.into && gene.out == link.out) {
            return true;
        }
    }
    return false;
}

function pointMutate(genome) {
    // Mutates all the genes in the genome
    var step = genome.mutationRates.step;
    for (var x=0; x<genome.genes.length; x++) {
        var gene = genome.genes[x];
        if (Math.random() < PerturbChance) {
            gene.weight = gene.weight + Math.random() * step*2 - step;
        } else {
            gene.weight = Math.random() * 4 - 2;
        }
    }
}

function linkMutate(genome, forceBias) {
    var newLink = newGene();
    if (forceBias) {
        newLink.into = Inputs - 1; // bias neuron
    } else {
        newLink.into = randomNeuron(genome, false);
    }
    newLink.out = randomNeuron(genome, true);
    if (containsLink(genome.genes, newLink)) {
        return;
    }
    newLink.innovation = newInnovation();
    newLink.weight = Math.random()*4 - 2;
    genome.genes.push(newLink);
}

function nodeMutate(genome) {
    if (genome.genes.length == 0) {
        return;
    }
    var gene = genome.genes[getRandomIntInclusive(0,genome.genes.length-1)];
    if (!gene.enabled) {
        return;
    }
    // add a node between two existing nodes
    genome.maxneuron = genome.maxneuron + 1;

    var gene1 = copyGene(gene);
    gene1.out = genome.maxneuron;
    gene1.weight = 1.0;
    gene1.innovation = newInnovation();
    gene1.enabled = true;
    genome.genes.push(gene1);
    var gene2 = copyGene(gene);
    gene2.into = genome.maxneuron;
    gene2.innovation = newInnovation();
    gene2.enabled = true;
    genome.genes.push(gene2);
}

function enableDisableMutate(genome, enable) {
    // TODO enable/disable a random gene
    var candidates = [];
    for (var x=0; x<genome.genes.length; x++) {
        if (genome.genes[x].enabled = !enable) {
            candidates.push(x);
        }
    }
    if (candidates.length == 0) {
        return;
    }
    var x = candidates[getRandomIntInclusive(0,candidates.length-1)];
    genome.genes[x].enabled = enable;
}

function mutate(genome) {
    // TODO Mutate the mutation rates of the genome?!
    if (Math.random() < genome.mutationRates.connections) {
        pointMutate(genome);
    }
    var p = genome.mutationRates.link;
    while (p > 0) {
        if (Math.random() < p) {
            linkMutate(genome, false);
        }
        p = p-1;
    }

    p = genome.mutationRates.bias;
    while (p > 0) {
        if (Math.random() < p) {
            linkMutate(genome, true);
        }
        p = p-1;
    }

    p = genome.mutationRates.node;
    while (p > 0) {
        if (Math.random() < p) {
            nodeMutate(genome);
        }
        p = p-1;
    }

    p = genome.mutationRates.enable;
    while (p > 0) {
        if (Math.random() < p) {
            enableDisableMutate(genome, true);
        }
        p = p-1;
    }

    p = genome.mutationRates.disable;
    while (p > 0) {
        if (Math.random() < p) {
            enableDisableMutate(genome, false);
        }
        p = p-1;
    }
}

function disjoint(g1,g2) {
    var i1 = [];
    for (var x=0; x<g1.length; x++) {
        i1[g1[x].innovation] = true;
    }
    var i2 = [];
    for (var x=0; x<g2.length; x++) {
        i2[g2[x].innovation] = true;
    }
    var disjointGenes = 0; 
    for (var x=0; x<g1.length; x++) {
        if (i2[g1[x].innovation] == undefined) {
            disjointGenes++;
        }
    }
    for (var x=0; x<g2.length; x++) {
        if (i1[g2[x].innovation] == undefined) {
            disjointGenes++;
        }
    }
    // amount the two genes are disjoint
    return disjointGenes / Math.max(g1.length, g2.length);
}
function weights(g1,g2) {
    // amount the two genes differ in weight for matching genes
    var i2 = [];
    for (var x=0; x<g2.length; x++) {
        i2[g2[x].innovation] = g2;
    }
    var sum = 0,
        coincident = 0;
    for (var x=0; x<g1.length; x++) {
        if(i2[g1[x].innovation] != undefined) {
            sum = sum + Math.abs(g1[x].weight - i2[g1[x].innovation].weight);
            coincident = coincident + 1;
        }
    }

    return sum / coincident;
}
function sameSpecies(g1, g2) {
    var dd = DeltaDisjoint * disjoint(g1.genes, g2.genes);
    var dw = DeltaWeights * weights(g1.genes, g2.genes);
    return dd + dw < DeltaThreshold;
}
function rankGlobally() {
    // rank all genomes in the pool by fitness
    var global = [];
    for (var x=0; x<pool.species.length; x++) {
        for (var y=0; y<pool.species[x].genomes.length; y++) {
            global.push([ x, y ]);
        }
    }
    global.sort(function(a,b) {
        var ga = pool.species[a[0]].genomes[a[1]];
        var gb = pool.species[b[0]].genomes[b[1]];
        return ga.fitness - gb.fitness;
    });
    for (var g=1; g<=global.length; g++) {
        var a = global[g-1];
        pool.species[a[0]].genomes[a[1]].globalRank = g;
    }

}
function calculateAverageFitness(species) {
    // calc average RANK of a species
    var total = 0;
    for (var g=0; g<species.genomes.length; g++) {
        total = total + species.genomes[g].globalRank;
    }
    species.averageFitness = total / species.genomes.length;
}
function totalAverageFitness() {
    var total = 0;
    for (var s=0; s<pool.species.length; s++) {
        total = total + pool.species[s].averageFitness;
    }
    return total;
}
function cullSpecies(cutToOne) {
    //  cull the lowest half of each species - or keep only the best
    for (var s=0; s<pool.species.length; s++) {
        pool.species[s].genomes.sort(function(a,b){
            return b.fitness - a.fitness;
        });
        var remaining = cutToOne ? 1 : Math.ceil( pool.species[s].genomes.length / 2);
        pool.species[s].genomes = pool.species[s].genomes.slice(0, remaining);
    }
}
function breedChild(species) {
    var child = {};
    if (Math.random() > CrossoverChance) {
        g1 = species.genomes[getRandomIntInclusive(0,species.genomes.length-1)];
        g2 = species.genomes[getRandomIntInclusive(0,species.genomes.length-1)];
        child = crossover(g1, g2);
    } else {
        g = species.genomes[getRandomIntInclusive(0,species.genomes.length-1)];
        child = copyGenome(g);
    }
    mutate(child);
    return child;
}
function removeStaleSpecies() {
    // TODO kill any species that has not improved for a threshold of generations (unless its the best in the pool)
}
function removeWeakSpecies() {
    // kill any species that has a relatively low average fitness - in comparison to the pool
    // Basically, any species so weak that it would produce 0 children
    var survived = [];
    var sum = totalAverageFitness();
    for (var x=0; x<pool.species.length; x++) {
        var species = pool.species[x];
        var breed = Math.floor(species.averageFitness / sum * Population);
        if (breed>=1) {
            survived.push(species);
        }
    }
    pool.species = survived;
}
function addToSpecies(child) {
    // Add a new child to the correct species in the pool
    var foundSpecies = false;
    for (var x=0; x<pool.species.length; x++) {
        var species = pool.species[x];
        if (!foundSpecies && sameSpecies(child, species.genomes[0])) {
            console( 'Oooh, matching species' );
            species.genomes.push(child);
            foundSpecies = true;
        }
    }
    if (!foundSpecies) {
        var childSpecies = newSpecies();
        childSpecies.genomes.push(child);
        pool.species.push(childSpecies);
    }
}
function newGeneration() {
    cullSpecies(false);
    rankGlobally();
    removeStaleSpecies();
    rankGlobally();
    for (var x=0; x<pool.species.length; x++) {
        var species = pool.species[x];
        calculateAverageFitness(species);
    }
    removeWeakSpecies();
    var sum = totalAverageFitness();
    var children = [];
    for (var x=0; x<pool.species.length; x++) {
        var species = pool.species[x];
        var breed = Math.floor(species.averageFitness / sum * Population);
        for (var y=1; y<breed; y++) {
            children.push(breedChild(species));
        }
    }
    cullSpecies(true); // kill all but the best in each species
    while (children.length + pool.species.length < Population) {
        var species = pool.species[getRandomIntInclusive(0, pool.species.length-1)];
        children.push(breedChild(species));
    }
    for (var x=0; x<children.length; x++) {
        var child = children[x];
        addToSpecies(child);
    }
    pool.generation = pool.generation + 1;

    writeFile('Somebackup');
}
function initializePool() {
    pool = newPool();
    for (var x=0; x<Population; x++) {
        console.log('Starting with '+x);
        var basic = basicGenome();
        addToSpecies(basic);
    }
    initializeRun();
}
function initializeRun() {
    resetInputs();

    var species = pool.species[pool.currentSpecies];
    var genome = species.genomes[pool.currentGenome];
    generateNetwork(genome);
}
function evaluateCurrent() {
    var species = pool.species[pool.currentSpecies];
    var genome = species.genomes[pool.currentGenome];
    // TODO - for each input set
    var inputs = getInputs();
    var result = evaluateNetwork(genome.network, inputs);
    return calculateFitnessDelta(genome, result);
}

function nextGenome() {
    pool.currentGenome = pool.currentGenome + 1;
    if (pool.currentGenome >= pool.species[pool.currentSpecies].genomes.length) {
        pool.currentGenome = 0;
        pool.currentSpecies = pool.currentSpecies + 1;
        if (pool.currentSpecies >= pool.species.length) {
            pool.currentSpecies = 0;
            newGeneration();
            report();
        }
    }
}

function report() {
    console.log('Generation #'+pool.generation);
    console.log('Species '+pool.species.length);
}
var pool;
initializePool();
report();
while (true) {
    var f = evaluateCurrent();
    if (f > pool.maxfitness) {
        pool.maxfitness = f;
    }
    nextGenome();
    initializeRun();
}


//console.log( 'foo bar' );

