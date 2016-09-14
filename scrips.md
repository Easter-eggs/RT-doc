# Scrips

Read "From "User Defined" to a module" section of [wiki page](https://rt-wiki.bestpractical.com/index.php?title=WriteCustomAction).

## Scrips in a nutshell

Let's write a scrip that print "Hello World" in console when a ticket is created.
Since this scrip use a already defined condition: "On create", we only need to write an action file.

Global process :

  - create the "action" file
  - register the action and the scrip


### Scrip action file

`/local/lib/RT/Action/SayHelloWorld.pm` :

```perl
package RT::Action::SayHelloWorld;
use base 'RT::Action';

use strict;
use warnings;

sub Commit {
    print STDERR "Hello World\n";
    return 1;
}

1;
```

### Register scrip

Registering a scrip is adding a line in ScripActions and Scrips tables in DB (and maybe ScripConditions if you also define a custom condition).
This is done by writing a file describing objects to add:

#### Create DB file

`SayHelloWorld.db`:

```perl
@ScripActions = (
    {
        Name                 => 'Say hello',
        ExecModule           => 'SayHelloWorld',
    }
    );

@Scrips = (
    {
        Description    => 'On ticket create, say hello',
        ScripCondition => 'On create',
        ScripAction    => 'Say hello',
        Template       => 'Blank'
    },
);
```

=> The link between scrip 'On ticket create, say hello' and the action 'Say hello' is made via 'Say hello' string. Changing the action name breaks the scrip from being executed.

#### Execute rt-setup-database with this file

Once the file is ready, we call the `rt-setup-database` tool to do the DB inserts for us:

    sbin/rt-setup-database --action insert --datafile /path/to/SayHelloWorld.db

## Advanced examples

A bunch of examples are pre-defined in `lib/RT/Action` and `lib/RT/Condition` folders. You can read them to inspire yourself.

### $self

A classic way of beginning an action sub is writing this line:

```perl
my $self = shift;
```

This shif first argument to $self variable. After doing this, you'll have access to $self: an object with these attributes:

  - **Argument**         : String
  - **ScripActionObj**   : RT::ScripAction
  - **ScripObj**         : RT::Scrip
  - **TemplateObj**      : RT::Template
  - **TicketObj**        : RT::Ticket
  - **TransactionObj**   : RT::Transaction
  - **user**             : RT::CurrentUser

### Passing argument

One argument can be passed to conditions and actions.
It is accesible via `$self->Argument`

For example, the `StatusChange` condition (lib/RT/Condition/StatusChange.pm) takes an argument, and is used two times, to define two standard RT conditions:

in `etc/initialdata`:

```perl
{  Name                 => 'On Resolve',                               # loc
   Description          => 'Whenever a ticket is resolved',            # loc
   ApplicableTransTypes => 'Status',
   ExecModule           => 'StatusChange',
   Argument             => 'resolved'
},
{  Name                 => 'On Reject',                                # loc
   Description          => 'Whenever a ticket is rejected',            # loc
   ApplicableTransTypes => 'Status',
   ExecModule           => 'StatusChange',
   Argument             => 'rejected'
},
```
