#!/usr/bin/env perl

use strict;
use warnings;

# data definition

# define an anonymous hash to keep track of the tasks
my %task;

# start populating the tasks;

#task DNK
$task{ 'DNK' } = {};
$task{ 'DNK' }{runtime} = 1;
$task{ 'DNK' }{iteration_started} = 0;
$task{ 'DNK' }{dependancies} = '';

#task XYZ
$task{ 'XYZ' } = {};
$task{ 'XYZ' }{runtime} = 2;
$task{ 'XYZ' }{iteration_started} = 0;
$task{ 'XYZ' }{dependancies} = 'ABC';

#task ABC
$task{ 'ABC' } = {};
$task{ 'ABC' }{runtime} = 1;
$task{ 'ABC' }{iteration_started} = 0;
$task{ 'ABC' }{dependancies} = '';

#task 101
$task{ '101' } = {};
$task{ '101' }{runtime} = 1;
$task{ '101' }{iteration_started} = 0;
$task{ '101' }{dependancies} = 'DNK,XYZ';

my $iteration = 1;
my $key;
do {
    print '-' x 5 . "\n" . "Interation number: $iteration\n" . '-' x 5 . "\n";
    foreach $key (keys %task) {
	print '-' x 10 . "\n";
	print $key . "\n";
	print '-' x 10 . "\n";
	unless(&task_has_completed($key)) {
	    unless($task{$key}{iteration_started}) {
		if($task{$key}{dependancies}) {
		    print "\tDependancies: " . $task{$key}{dependancies} . "\n";
		} else {
		    print "\tThere are no dependancies!\n";
		}
		my $have_all_dependancies_completed = 1;
		my @dependancy = split(',', $task{$key}{dependancies} );
		foreach (@dependancy) {
		    my $dependancy = $_;
		    print "\t";
		    unless( &task_has_completed($dependancy) ) {
			$have_all_dependancies_completed = 0;
			last;
		    }
		}
		if( $have_all_dependancies_completed ) {
		    $task{$key}{iteration_started} = $iteration;
		    print "\t$key scheduled\n";
		}
		
	    } else {
		print "\t$key already scheduled and running\n";
	    }
	}
    }
    print '-'x80 . "\n" . 'End of iteration checks:' . "\n";
    
    $iteration++;
} until( &all_tasks_complete );

print '=' x 80 . "\n";
print 'End of Job Report'."\n";
print '-' x 80 . "\n";
foreach $key (keys %task) {
    print $key . "\n";
    my %temp = %{$task{$key}};
    foreach my $task_key (keys %temp) {
	print "\t" . $task_key . "\t" . $temp{$task_key} . "\n" unless($task_key eq 'dependancies');
    }
    if( $task{$key}{iteration_started} ) {
	print "\t" . "Job finished at the end of iteration ";
	print $task{$key}{iteration_started} + $task{$key}{runtime} - 1 . "\n";
    }
}

sub all_tasks_complete {
    my $answer = 1;
    foreach $key (keys %task) {
	print "Checking $key\n";
	$answer = &task_has_completed($key);
	last unless($answer);
    }
    return($answer)
}

sub task_has_completed {
    my $task_name = shift;
    print "has $task_name completed? ";
    if( $task{$task_name}{iteration_started} ){
	if( $iteration >= $task{$task_name}{iteration_started} + $task{$task_name}{runtime} ) {
	    print 'YES' . "\n";
	    return(1);
	} else {
	    print 'NO' . "\n";
	    return(0);
	}
    } else {
	print 'NO' . "\n";
	return(0);
    }
}
