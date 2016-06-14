# Accessing RT out of RT

For testing or scripting, it's really usefull to access RT instance without RT server running.
This can be done with the code below. This code will be then used almost everywhere in this doc.

```perl
use strict;
use warnings;
use Data::Printer;  # For "p" function

# use lib qw(/home/bruno/dev/ee/rt/lib);  # Use it if your RT instance is not in a standard path
use RT;
use RT::User;

print "Setting up rt...\n";
RT::LoadConfig();
RT::Init();
```

*Note:* `Data::Printer` can be replaced by standard `Data::Dumper`. In this case, the "p" function can be defined like that:

```perl
sub p {
    my $arg = shift;
    print Dumper($arg);
}
```

# Interract with DB

The is mainly two types of objects to be distinguished:
  - a single result, coming from a SQL request
  - a result set, coming from a SQL request, containing an array of results from a query to DB

## Results sets classes

The first type is represented by RT collections objects (ie class with a 's' at the end of name: *Tickets*, *Queues*, ...).
They are are based on `RT::SearchBuilder`, witch is based on `DBIx::SearchBuilder`.

To have list classes of this type, use grep:

```bash
grep "use base 'RT::SearchBuilder';" * -R
```

This classes are:

  - ACL
  - Articles
  - Assets
  - Attachments
  - Attributes
  - CachedGroupMembers
  - Catalogs
  - Classes
  - CustomFieldValues
  - CustomFields
  - CustomRoles
  - GroupMembers
  - Groups
  - Links
  - ObjectClasses
  - ObjectCustomFieldValues
  - ObjectTopics
  - Principals
  - Queues
  - ScripActions
  - ScripConditions
  - Scrips
  - SearchBuilder::AddAndSort
  - Templates
  - Tickets
  - Topics
  - Transactions
  - Users

### Interracting with DBIx::SearchBuilder

`DBIx::SearchBuilder` is the base class used everywhere in RT where requesting DB. It's important to understand how to use it. Basically, this objects encapsulate SQL requests.

The way you use it is:

  - prepare the request (create a new instance, add constraints)
  - execute the request (this is done automatically when calling a method that need SQL request to be executed)

#### Filtering

RT define many functions to filter results.

Example: `LimitQueue` (used in the example below) defined in `RT::Tickets` adds a WHERE clause to SQL request.
All `Limit*` functions are more or less calls to `DBIx::SearchBuilder->Limit`

#### Complete example

Get the list of tickets of a queue

```perl
my $queueName = 'My Queue';

# Init a new RT::Tickets, (whitch is also a DBIx::SearchBuilder)
my $tickets = RT::Tickets->new(RT->SystemUser);

# Add a filter to this object => adding a 'WHERE' to SQL request
$tickets->LimitQueue(VALUE => $queueName);

# Do the request: call DBIx::SearchBuilder->Count
print $tickets->Count . " tickets founds in queue '" . $queueName . "':\n";

# Display result detail
while (my $ticket = $tickets->Next()) {
    # $ticket is an RT::Ticket instance
    print "   - #" . $ticket->Id . ": " . $ticket->Subject . "\n";
}
```

#### ItemsArrayRef

`DBIx::SearchBuilder` also define `ItemsArrayRef`. In [DBIx::SearchBuilder documentation](http://search.cpan.org/~alexmv/DBIx-SearchBuilder-1.66/lib/DBIx/SearchBuilder.pm#ItemsArrayRef) we acan read :

    Return a refernece to an array containing all objects found by this search.

It's usefull to know the existance of this function while testing as it can list results of a search without having to iterate over results.

Example:

```perl
my $tickets = RT::Tickets->new(RT->SystemUser);
$tickets->LimitQueue(VALUE => 'My Queue');
p $tickets->ItemsArrayRef;
```

## Single result classes

To list classes of this type, use grep:

```bash
grep "use base 'RT::Record';" * -R
```

This classes are:

  - ACE
  - Article
  - Asset
  - Attachment
  - Attribute
  - CachedGroupMember
  - Catalog
  - Class
  - CustomField
  - CustomFieldValue
  - CustomRole
  - Group
  - GroupMember
  - Link
  - ObjectClass
  - ObjectCustomFieldValue
  - Principal
  - Queue
  - Record::AddAndSort
  - Scrip
  - ScripAction
  - ScripCondition
  - Template
  - Ticket
  - Topic
  - Transaction
  - User

A **very usefull** and undocumented thing to know is that all that classes have properties accessibles. For example, a `Ticket` instance have the `Subject` property accessible.

```perl
# Instanciate a new RT::Ticket object
my $ticket = RT::Ticket->new(RT->SystemUser);
# Set this object to reflect first ticket in DB
$ticket->Load(1);
# Access Subject property and print it
p $ticket->Subject;
```

To find all that accessibles properties, you'll have to look at `_OverlayAccessible`, `_VendorAccessible` or `_LocalAccessible` methods of previously listed clasees.

The [attributes_list.md](RT Record attributes/attributes_list.md) in the `RT Record attributes` folder list them for you.
