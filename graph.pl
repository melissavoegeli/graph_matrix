#!/bin/perl
#PERL GRAPH FUN

use Graph::Kruskal qw(:all);
use Data::Dumper;
use strict;
use warnings;

my $nodes   = 5;  #nodes in tree
my $alpha   = .9; #chance of assigning an edge
my @graph   = (); #the matrix
my $weight  = 10; #weight range for edges
my @q       = (); #Queue for BFS algorithm
my @visited = (); #Keep track of visted nodes for BFS
my $start   = 0;  #Start at node 0
my $rear    = 0;  #When rear and start converge then you're done

# Set up graph edges
foreach my $x (0..($nodes-1)) {
  foreach my $y (0..($nodes-1)) {
    my $_ = rand(1);
    if ($_ <= $alpha) {
    print "edge exists!\n";
    $graph[$x][$y] = $_;
    }
    else {
     $graph[$x][$y] = 0;
     }
  }
}

# Prune edges  -- If an edge exists from 0 to 1 but not 1 to 0 then delete
foreach my $x (0..($nodes-1)) {
  foreach my $y (0..($nodes-1)) {
    unless ($graph[$x][$y] > 0 && $graph[$y][$x] > 0) {
      $graph[$x][$y] = 0;
      $graph[$y][$x] = 0;
    }
    if ($x == $y) {
      $graph[$x][$y] = 0;
    }
  }
}

# Assign random weights to each edge
foreach my $x (0..($nodes-1)) {
  foreach my $y (0..($nodes-1)) {
    my $_ = int(rand($weight));
    unless ($graph[$x][$y] == 0) {
      $graph[$x][$y] = $_;
      $graph[$y][$x] = $_;
    }
  }
}

# This is a really cheap way to see the matrix
# Data Dumper loves you!
print Dumper(@graph);

# Breadth First Search to find if this graph is fully connected
push @q, $start;
push @visited,1;
while(@q) {
  $start = pop @q;
  print "$start";
  foreach my $i (0..($nodes -1)) {
    if($graph[$start][$i] && !$visited[$i]) {
     push @q, $i;
     $visited[$i]=1;
    }
  }
}

# Kruskal's Algorithm for Min. Spanning Tree
# Wow this module sucks, no wonder no one maintains it anymore
define_vortices(1..$nodes);
foreach my $v ( @Graph::Kruskal::V ) {
    print $v, "\n";
}
foreach my $x (0..($nodes-1)) {
 foreach my $y (0..$x) {
   push @edges, ($x+1,$y+1,$graph[$x][$y]) if $graph[$x][$y];
 }
}
define_edges(@edges);
foreach my $e ( @Graph::Kruskal::E ) {
    print "Edge: From: " . $e->{'from'} . "; To: " . $e->{'to'} . "; Cost: " . $e->{'cost'}, "\n" if defined $e;
}

kruskal;

foreach my $e (@Graph::Kruskal::T) {
    print "MST: From: " . $e->{'from'} . "; To: " . $e->{'to'} . "; Cost: " . $e->{'cost'}, "\n" if defined $e;
}
