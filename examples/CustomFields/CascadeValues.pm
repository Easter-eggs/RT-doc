#!/usr/bin/perl

#
# Given:
#   - "cf1": CustomField
#   - "cf2": CustomField with values depending on "cf1"'s values
#
# This script prints the values of cf2 for each cf1 value.
#
# Exemple:
#   cf1 - value 1
#      - cf2 - value 1
#   cf1 - value 2
#      - cf2 - value 2
#      - cf2 - value 3
#   cf1 - value 3


use strict;
use warnings;

# use lib qw(/home/bruno/dev/ee/rt/lib);
use RT;
use RT::User;

RT::LoadConfig();
RT::Init();

my $user = RT::User->new();
$user->Load('root');

# Load custom field 1
my $cf1 = RT::CustomField->new($user);
$cf1->LoadByName(Name => 'cf1');
# Load custom field 2
my $cf2 = RT::CustomField->new($user);
$cf2->LoadByName(Name => 'cf2');
# Prepare request for getting cf1 values
my $cf1_values = $cf1->Values;
# Iter through cf1 values
while (my $cf1_value = $cf1_values->Next) {
    print($cf1_value->Name . "\n");
    # Prepare request for getting cf2 values (must be on the loop)
    my $cf2_values = $cf2->Values;
    # Add a filter to the search (WHERE clause in sql request) for limiting result to
    # cf2 values that have for "Category" cf1 value
    $cf2_values->Limit(FIELD => "Category", VALUE => $cf1_value->Name);
    # Print all cf2 values for current cf1 value
    while (my $cf2_value = $cf2_values->Next) {
        print("   - " . $cf2_value->Name . "\n");
    }
}
